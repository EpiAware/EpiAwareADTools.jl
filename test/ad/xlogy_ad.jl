# Unit-level AD coverage for the `xlogy`/`xlog1py` Mooncake rules in
# `EpiAwareADToolsLogExpFunctionsMooncakeExt`. Complements the
# "logpdf Gamma at shape 1" scenario in `scenarios.jl`: that one checks the
# end-to-end gradient against the ForwardDiff reference, these pin the rules
# themselves (registered as primitives, correct in both Mooncake modes, at the
# `x == 0` point where Mooncake's derived rule returns the wrong zero).
#
# Each item is mode-agnostic (it exercises both modes of the rules), so it is
# tagged for a single canonical backend and runs once across the per-backend CI
# jobs; the untagged `task test-ad` run executes every item.

@testitem "xlogy/xlog1py pass Mooncake.TestUtils.test_rule" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    # `is_primitive = true` asserts the lifted rule is actually invoked, so
    # this fails if the registration is absent or narrowed away from the
    # `Base.IEEEFloat` argument types; the finite-difference comparison then
    # fails if the derivative is wrong. `x == 0` is the case that matters.
    using Random: MersenneTwister
    using Mooncake: Mooncake
    using LogExpFunctions: xlogy, xlog1py

    cases = [(0.0, 2.0), (0.0, 0.5), (1.5, 2.0), (-2.0, 0.25)]
    for mode in (Mooncake.ReverseMode, Mooncake.ForwardMode),
        f in (xlogy, xlog1py),
        (x, y) in cases
        Mooncake.TestUtils.test_rule(
            MersenneTwister(20260803),
            f, x, y;
            is_primitive = true,
            perf_flag = :none,
            mode = mode
        )
    end
end

@testitem "Gamma log-density shape gradient at shape == 1" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    # The real-world trigger. `Distributions.gammalogpdf` computes
    # `xlogy(shape - 1, x / scale)`, so at `shape == 1` the first argument is
    # exactly zero. Without the lifted rules Mooncake derives `∂/∂x = 0` from
    # the primal's `iszero(x)` branch and both modes return
    # `-digamma(1) = γ ≈ 0.5772` for the shape component instead of
    # `log(x / scale) - digamma(1)`.
    using ADTypes: AutoMooncake, AutoMooncakeForward
    using DifferentiationInterface: gradient
    using Distributions: Gamma, logpdf
    using Mooncake: Mooncake
    using SpecialFunctions: digamma

    f(θ, x) = logpdf(Gamma(θ[1], θ[2]), x)
    backends = (AutoMooncake(config = nothing), AutoMooncakeForward())

    for (scale, x) in ((2.0, 3.0), (0.5, 0.25), (1.0, 4.0))
        θ = [1.0, scale]
        analytic = [log(x / scale) - digamma(1.0), x / scale^2 - 1.0 / scale]
        # The wrong shape-gradient the derived rule returns, pinned so a
        # future regression cannot pass by coincidence.
        wrong_shape = -digamma(1.0)
        @test !isapprox(analytic[1], wrong_shape; atol = 1e-3)
        for backend in backends
            g = gradient(θ -> f(θ, x), backend, θ)
            @test isapprox(g, analytic; rtol = 1e-10, atol = 1e-12)
        end
    end
end
