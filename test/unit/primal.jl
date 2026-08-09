# Value-level unit tests for `primal`'s container contract. The per-backend
# strip methods and non-differentiability marks are pinned by the `:ad` items
# in `test/ad/primal.jl`; these pin what `primal` accepts and returns with no
# AD backend loaded.

@testitem "primal is the identity on a real and keeps its type" begin
    using EpiAwareADTools: primal

    @test primal(3.0) === 3.0
    @test primal(3.0f0) === 3.0f0
    @test primal(3) === 3
end

@testitem "primal strips containers elementwise and recursively" begin
    using EpiAwareADTools: primal

    @test primal((1.0, 2.0)) === (1.0, 2.0)
    @test primal(((1.0, 2.0), 3.0)) === ((1.0, 2.0), 3.0)
    # Arrays strip into a new container of the same shape, so a
    # vector-valued hyperparameter (a grid of integration nodes) is covered.
    @test primal([1.0, 2.0]) == [1.0, 2.0]
    @test primal([1.0 2.0; 3.0 4.0]) == [1.0 2.0; 3.0 4.0]
    @test size(primal([1.0 2.0; 3.0 4.0])) == (2, 2)
    @test primal(0.0:0.5:1.0) == [0.0, 0.5, 1.0]
    # Containers nest in either order.
    @test primal([(1.0, 2.0), (3.0, 4.0)]) == [(1.0, 2.0), (3.0, 4.0)]
    @test primal(([1.0, 2.0], 3.0)) == ([1.0, 2.0], 3.0)
end

@testitem "primal passes an absent bound through" begin
    using EpiAwareADTools: primal

    @test primal(nothing) === nothing
    @test primal((1.0, nothing)) === (1.0, nothing)
    @test primal([1.0, nothing]) == [1.0, nothing]
end

@testitem "primal_distribution rebuilds an interval-truncated distribution" begin
    using Distributions: Gamma, Exponential, Truncated, truncated, params, cdf
    using EpiAwareADTools: primal_distribution

    d = truncated(Gamma(2.0, 1.0), 0.0, 10.0)
    p = primal_distribution(d)
    @test p isa Truncated{Gamma{Float64}}
    @test params(p) === params(d)
    @test all(x -> cdf(p, x) == cdf(d, x), [0.5, 1.0, 3.0, 9.0, 12.0])

    # Single-parameter family: `params` is the Float64 TRIPLE issue #58
    # reports.
    e = truncated(Exponential(1.0), 0.0, 10.0)
    @test params(primal_distribution(e)) === (1.0, 0.0, 10.0)
end

@testitem "primal_distribution rebuilds a one-sided truncation" begin
    using Distributions: Gamma, Poisson, truncated, params, cdf
    using EpiAwareADTools: primal_distribution

    lo = truncated(Gamma(2.0, 1.0); lower = 1.0)
    @test primal_distribution(lo).upper === nothing
    @test params(primal_distribution(lo)) === (2.0, 1.0, 1.0, nothing)

    hi = truncated(Gamma(2.0, 1.0); upper = 5.0)
    @test primal_distribution(hi).lower === nothing

    # Issue #57's reproducer: an unbounded DISCRETE component.
    pois = truncated(Poisson(3.0); lower = 1)
    @test params(primal_distribution(pois)) === (3.0, 1.0, nothing)

    # A nested truncation collapses to intersected bounds, cdf unchanged.
    n = truncated(truncated(Gamma(2.0, 1.0); lower = 1.0); upper = 5.0)
    @test all(
        x -> cdf(primal_distribution(n), x) == cdf(n, x), [0.5, 2.0, 6.0])
end

@testitem "primal_distribution rebuilds a censored distribution" begin
    using Distributions: Normal, Gamma, censored, truncated, cdf
    using EpiAwareADTools: primal_distribution

    for d in (censored(Normal(), 0.0, 1.0), censored(Normal(); lower = 0.0),
        censored(Normal(); upper = 1.0),
        censored(truncated(Gamma(2.0, 1.0); lower = 0.5), 1.0, 4.0))
        p = primal_distribution(d)
        @test typeof(p) === typeof(d)
        @test all(x -> cdf(p, x) == cdf(d, x), [-1.0, 0.0, 0.5, 1.0, 3.0])
    end
end

@testitem "primal_distribution names the type it cannot rebuild" begin
    using Distributions: Categorical
    using EpiAwareADTools: primal_distribution

    @test_throws ArgumentError primal_distribution(Categorical([0.2, 0.3,
        0.5]))
    msg = try
        primal_distribution(Categorical([0.2, 0.3, 0.5]))
    catch err
        sprint(showerror, err)
    end
    @test occursin("Categorical", msg)
    @test occursin("primal_distribution", msg)
end
