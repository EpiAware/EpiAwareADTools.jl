# Unit-level AD coverage for the Student-t CDF composition, pinning what the
# `*_ad_safe TDist` scenarios in `ADFixtures` do not reach: the `x == 0` guard,
# the tail accuracy of the reflected branch, and the ForwardDiff
# `logcdf`/`logccdf` methods that make `truncated` constructible on a `Dual`.

@testitem "_t_cdf matches Distributions on the primal path" tags = [
    :ad, :forwarddiff,
] begin
    using Distributions: TDist, cdf
    using EpiAwareADTools: _t_cdf

    for ν in (0.5, 1.5, 5.0, 30.0, 1.0e3),
            x in (-1.0e3, -60.0, -8.0, -2.0, -0.3, 0.0, 0.3, 2.0, 8.0, 60.0)

        # 1e-10 rather than the continued fraction's own 1e-13 exit tolerance:
        # the composition adds the `ν/(ν + x²)` transform and the halving on top
        # of it, and `Distributions` reaches the value by a different route, so
        # the two disagree in the last couple of digits at the grid extremes.
        @test isapprox(_t_cdf(ν, x), cdf(TDist(ν), x); rtol = 1.0e-10)
    end
end

@testitem "_t_cdf derivatives at x = 0" tags = [:ad, :forwarddiff] begin
    using Distributions: TDist, pdf
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _t_cdf

    # `ν/(ν + x²)` reaches 1 at `x == 0`, where the incomplete beta's x-partial
    # diverges and the chain rule would return `0 * Inf`. The guard substitutes
    # the closed form, and both derivatives must come back finite and correct.
    for ν in (1.5, 5.0, 30.0)
        dx = ForwardDiff.derivative(x -> _t_cdf(ν, x), 0.0)
        @test isapprox(dx, pdf(TDist(ν), 0.0); rtol = 1.0e-12)
        @test ForwardDiff.derivative(n -> _t_cdf(n, 0.0), ν) == 0.0
    end
end

@testitem "_t_cdf derivatives match FiniteDifferences" tags = [
    :ad, :forwarddiff,
] begin
    using FiniteDifferences: central_fdm
    using DifferentiationInterface: AutoFiniteDifferences, derivative
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _t_cdf

    fd = AutoFiniteDifferences(; fdm = central_fdm(7, 1))
    for ν in (1.5, 5.0, 30.0), x in (-6.0, -1.2, -0.1, 0.4, 2.0, 7.0)
        truth_ν = derivative(n -> _t_cdf(n, x), fd, ν)
        truth_x = derivative(u -> _t_cdf(ν, u), fd, x)
        @test isapprox(
            ForwardDiff.derivative(n -> _t_cdf(n, x), ν), truth_ν;
            atol = 1.0e-9, rtol = 1.0e-6
        )
        @test isapprox(
            ForwardDiff.derivative(u -> _t_cdf(ν, u), x), truth_x;
            atol = 1.0e-9, rtol = 1.0e-6
        )
    end
end

@testitem "truncated Student-t is constructible and differentiable" tags = [
    :ad, :forwarddiff,
] begin
    using Distributions: TDist, truncated, logpdf
    using FiniteDifferences: central_fdm
    using DifferentiationInterface: AutoFiniteDifferences, gradient
    using ForwardDiff: ForwardDiff

    # `truncated` normalises eagerly, calling `logcdf` at the bounds when the
    # object is built, so construction itself threw before any integrand ran
    # (EpiAwareADTools#80).
    fd = AutoFiniteDifferences(; fdm = central_fdm(7, 1))

    # Location-scale: `μ` and `σ` carry the `Dual`s, `ν` does not.
    locscale(θ) = logpdf(truncated(θ[1] + θ[2] * TDist(4.0), 0.5, 3.0), 1.2)
    @test isapprox(
        ForwardDiff.gradient(locscale, [0.3, 1.1]),
        gradient(locscale, fd, [0.3, 1.1]);
        atol = 1.0e-9, rtol = 1.0e-6
    )

    # Degrees of freedom, and a `Dual` truncation bound with plain parameters.
    df(θ) = logpdf(truncated(TDist(θ[1]), -1.0, 2.0), 0.5)
    @test isapprox(
        ForwardDiff.gradient(df, [4.0]), gradient(df, fd, [4.0]);
        atol = 1.0e-9, rtol = 1.0e-6
    )

    bound(θ) = logpdf(truncated(TDist(4.0), -1.0, θ[1]), 0.5)
    @test isapprox(
        ForwardDiff.gradient(bound, [2.0]), gradient(bound, fd, [2.0]);
        atol = 1.0e-9, rtol = 1.0e-6
    )
end

@testitem "TDist hooks keep the far tails accurate under AD" tags = [
    :ad, :forwarddiff,
] begin
    using Distributions: TDist, logccdf
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: logccdf_ad_safe

    # The survival is the CDF at the reflected point, so it never forms `1 - F`
    # and both the value and its ν-derivative stay finite far into the tail,
    # where `log1p(-F)` has already collapsed to `-Inf`.
    for x in (20.0, 60.0, 200.0, 1.0e4)
        @test isapprox(
            logccdf_ad_safe(TDist(5.0), x), logccdf(TDist(5.0), x);
            rtol = 1.0e-9
        )
        d = ForwardDiff.derivative(ν -> logccdf_ad_safe(TDist(ν), x), 5.0)
        @test isfinite(d)
    end
end
