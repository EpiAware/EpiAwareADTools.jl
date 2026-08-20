# Unit-level AD coverage for the Student-t CDF path. Complements the scenario
# suite in `scenarios.jl`: those check end-to-end gradient agreement at scenario
# tolerance (~1e-6); these pin the implementation-level guarantees (agreement
# with Distributions.jl, the `x == 0` guard, tail accuracy, and the `truncated`
# constructor issue #80 reported) that no scenario exercises directly. Mirrors
# `beta_ad.jl`'s structure for the Student-t counterpart.
#
# `_t_cdf` composes over `_beta_cdf` rather than carrying rules of its own, so
# the per-backend items below verify that the inherited coverage is real rather
# than assumed.

@testitem "_t_cdf matches Distributions on both branches" tags = [
    :ad, :forwarddiff,
] begin
    using Distributions: TDist, cdf, ccdf, logcdf, logccdf
    using EpiAwareADTools: _t_cdf, _t_ccdf, _t_logcdf, _t_logccdf

    # `x` spans both sides of the `x < 0` branch and the `x == 0` guard; `ν`
    # spans the heavy-tailed (ν < 1) through nearly-Gaussian regimes.
    for ν in (0.5, 1.0, 2.5, 5.0, 30.0, 200.0),
            x in (-4.0, -1.0, -0.25, 0.0, 0.25, 1.0, 4.0)

        d = TDist(ν)
        @test isapprox(_t_cdf(ν, x), cdf(d, x); rtol = 1.0e-10)
        @test isapprox(_t_ccdf(ν, x), ccdf(d, x); rtol = 1.0e-10)
        @test isapprox(_t_logcdf(ν, x), logcdf(d, x); rtol = 1.0e-10)
        @test isapprox(_t_logccdf(ν, x), logccdf(d, x); rtol = 1.0e-10)
    end
end

@testitem "_t_logcdf holds the small tail against its asymptote" tags = [
    :ad, :forwarddiff,
] begin
    # The small tail is computed directly rather than as `1 - F`, so it stays
    # accurate far past the point where the stock evaluator (which reaches the
    # tail through the complementary branch) has lost most of its significant
    # digits. Ground truth is the leading term of the incomplete beta as its
    # argument goes to zero, `I_u(p, q) → u^p / (p B(p, q))`, which gives
    # `P(T_ν ≤ -x) → (ν / x^2)^(ν/2) / (ν B(ν/2, 1/2))` — independent of the
    # implementation and of Distributions.jl.
    using SpecialFunctions: logbeta
    using EpiAwareADTools: _t_logcdf, _t_logccdf

    asymptote(ν, x) = (ν / 2) * log(ν / x^2) - log(ν) - logbeta(ν / 2, 0.5)

    for ν in (1.5, 5.0, 12.0), x in (1.0e4, 1.0e6, 1.0e8)
        @test isapprox(_t_logcdf(ν, -x), asymptote(ν, x); rtol = 1.0e-8)
        # The survival is the CDF at the reflected point, so it gets the
        # same treatment and needs no `log1p(-F)` on either side.
        @test isapprox(_t_logccdf(ν, x), asymptote(ν, x); rtol = 1.0e-8)
        @test isfinite(_t_logcdf(ν, x))
        @test isfinite(_t_logccdf(ν, -x))
    end
end

@testitem "_t_cdf carries the density through the x == 0 guard" tags = [
    :ad, :forwarddiff,
] begin
    # At `x == 0` the beta argument `ν / (ν + x^2)` sits at 1, where
    # `_beta_cdf`'s x-partial diverges while the inner derivative is exactly
    # zero, so the chain rule asks for `0 * Inf`. The guard has to test the
    # PRIMAL: ForwardDiff's `==` and `iszero` compare a `Dual`'s partials too,
    # so a seeded zero tests unequal to `0` and an unguarded implementation
    # sails past.
    using Distributions: TDist, pdf
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _t_cdf, _t_logcdf

    for ν in (0.5, 2.5, 5.0, 30.0)
        @test _t_cdf(ν, 0.0) == 0.5
        # `F_ν(0) = 1/2` for every ν, so the ν-partial is EXACTLY zero.
        @test ForwardDiff.derivative(n -> _t_cdf(n, 0.0), ν) == 0.0
        # The x-partial is the density at the origin, which is finite.
        dx = ForwardDiff.derivative(x -> _t_cdf(ν, x), 0.0)
        @test isapprox(dx, pdf(TDist(ν), 0.0); rtol = 1.0e-12)
        dlogx = ForwardDiff.derivative(x -> _t_logcdf(ν, x), 0.0)
        @test isapprox(dlogx, 2 * pdf(TDist(ν), 0.0); rtol = 1.0e-12)
    end
end

@testitem "truncated Student-t gradient matches central differences" tags = [
    :ad, :forwarddiff,
] begin
    # Issue #80's own reproduction. `truncated` normalises eagerly, so
    # building the distribution calls `logcdf` before any density is
    # evaluated; without the `Dual` methods this errors inside
    # `SpecialFunctions.beta_inc` rather than returning a wrong number.
    using Distributions: TDist, truncated, logpdf
    using FiniteDifferences: FiniteDifferences, central_fdm
    using ForwardDiff: ForwardDiff

    fdm = central_fdm(5, 1)

    # Location and scale, with the degrees of freedom held constant: the
    # location-scale wrapper is what a `θ[1] + θ[2] * TDist(ν)` call site
    # builds, and it promotes the untouched `ν` to a `Dual` on the way in.
    f(θ) = logpdf(truncated(θ[1] + θ[2] * TDist(5.0), -2.0, 2.0), 1.2)
    θ₀ = [0.0, 1.0]
    g = ForwardDiff.gradient(f, θ₀)
    ref = first(FiniteDifferences.grad(fdm, f, θ₀))
    @test isapprox(g, ref; rtol = 1.0e-8, atol = 1.0e-10)

    # Degrees of freedom alone, on a bare `TDist`.
    h(ν) = logpdf(truncated(TDist(ν), -2.0, 2.0), 1.2)
    dν = ForwardDiff.derivative(h, 5.0)
    @test isapprox(dν, fdm(h, 5.0); rtol = 1.0e-8, atol = 1.0e-10)

    # A one-sided truncation whose bound sits exactly at the `x == 0` guard.
    k(θ) = logpdf(truncated(θ[1] + θ[2] * TDist(4.0); lower = 0.0), 1.2)
    gk = ForwardDiff.gradient(k, θ₀)
    refk = first(FiniteDifferences.grad(fdm, k, θ₀))
    @test isapprox(gk, refk; rtol = 1.0e-8, atol = 1.0e-10)
end

@testitem "ReverseDiff differentiates _t_cdf through the _beta_cdf rule" tags = [
    :ad, :reversediff,
] begin
    # `_t_cdf` is a composition over `_beta_cdf`, not a primitive of its own,
    # so every backend that carries a `_beta_cdf` rule should inherit its
    # coverage without a per-backend rule. Pinned rather than assumed.
    using ADTypes: AutoForwardDiff, AutoReverseDiff
    using DifferentiationInterface: gradient
    using ForwardDiff: ForwardDiff
    using ReverseDiff: ReverseDiff
    using EpiAwareADTools: _t_cdf

    f(v) = _t_cdf(v[1], v[2])
    for input in ([5.0, -1.3], [2.5, 0.4], [0.5, -0.05], [30.0, 2.0])
        ref = gradient(f, AutoForwardDiff(), input)
        for backend in (
                AutoReverseDiff(compile = false),
                AutoReverseDiff(compile = true),
            )
            @test isapprox(
                gradient(f, backend, input), ref;
                rtol = 1.0e-10, atol = 1.0e-12
            )
        end
    end
end

@testitem "Mooncake differentiates _t_cdf through the _beta_cdf rule" tags = [
    :ad, :mooncake, :mooncake_reverse,
] begin
    using ADTypes: AutoForwardDiff, AutoMooncake, AutoMooncakeForward
    using DifferentiationInterface: gradient
    using ForwardDiff: ForwardDiff
    using Mooncake: Mooncake
    using EpiAwareADTools: _t_cdf

    f(v) = _t_cdf(v[1], v[2])
    for input in ([5.0, -1.3], [2.5, 0.4], [0.5, -0.05], [30.0, 2.0])
        ref = gradient(f, AutoForwardDiff(), input)
        for backend in (AutoMooncake(config = nothing), AutoMooncakeForward())
            @test isapprox(
                gradient(f, backend, input), ref;
                rtol = 1.0e-10, atol = 1.0e-12
            )
        end
    end
end

@testitem "Enzyme differentiates _t_cdf through the _beta_cdf rule" tags = [
    :ad, :enzyme, :enzyme_reverse,
] begin
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _t_cdf

    f(v) = _t_cdf(v[1], v[2])
    for input in ([5.0, -1.3], [2.5, 0.4], [0.5, -0.05], [30.0, 2.0])
        ref = gradient(f, AutoForwardDiff(), input)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), input)
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), input)
        @test isapprox(g_rev, ref; rtol = 1.0e-10, atol = 1.0e-12)
        @test isapprox(g_fwd, ref; rtol = 1.0e-10, atol = 1.0e-12)
    end
end
