# Unit-level AD coverage for the gamma CDF rules. Complements the scenario
# suite in `scenarios.jl`: those check end-to-end gradient agreement at scenario
# tolerance (~1e-6); these pin the implementation-level guarantees (series
# accuracy, rule dispatch, defensive guards) that no scenario exercises
# directly. Ported from the CensoredDistributions.jl / ConvolvedDistributions.jl
# AD suite alongside the gamma helpers.
#
# Each item is mode-agnostic (it exercises both modes of a backend's rules), so
# it is tagged for a single canonical backend and runs once across the
# per-backend CI jobs; the untagged `task test-ad` run executes every item.

@testitem "_grad_p_a_series matches FiniteDifferences" tags=[
    :ad, :forwarddiff] begin
    using SpecialFunctions: gamma_inc
    using FiniteDifferences: central_fdm
    using DifferentiationInterface: AutoFiniteDifferences, derivative
    using EpiAwareADTools: _grad_p_a_series

    fd = AutoFiniteDifferences(; fdm = central_fdm(7, 1))

    # Restrict grid to (a, z) values where ∂P/∂a is large enough that the
    # finite-difference baseline is meaningful (i.e. away from P-saturation).
    # Includes k≪1 cases — the singular regime that breaks naive
    # implementations of the shape-parameter derivative. Lower bound on a is set
    # by the fdm probe radius (`central_fdm(7, 1)` reaches into negative a if
    # started below ~0.1).
    grid = [
        (0.1, 0.1), (0.1, 0.5), (0.1, 1.0),
        (0.3, 0.1), (0.3, 0.5), (0.3, 1.0),
        (0.5, 0.1), (0.5, 0.9), (0.5, 5.0),
        (1.0, 0.1), (1.0, 1.0), (1.0, 5.0),
        (2.3, 0.1), (2.3, 1.0), (2.3, 5.0),
        (10.0, 0.5), (10.0, 9.5), (10.0, 25.0),
        (50.0, 5.0), (50.0, 49.5)
    ]
    for (a, z) in grid
        truth = derivative(a -> first(gamma_inc(a, z)), fd, a)
        series = _grad_p_a_series(a, z)
        @test isapprox(series, truth; atol = 1e-10, rtol = 1e-10)
    end
end

@testitem "_gamma_cdf passes Mooncake.TestUtils.test_rule" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    # Mooncake's canonical rule test, run for both reverse and forward mode.
    # `@from_chainrules` (default mode) lifts the `rrule` into an `rrule!!` and
    # the `frule` into an `frule!!`, so both interfaces are registered. For each
    # mode, verifies (a) the rule is actually invoked (is_primitive = true
    # asserts this) and (b) primal + derivative match Richardson-extrapolated
    # finite differences.
    using Random: MersenneTwister
    using Mooncake: Mooncake
    using EpiAwareADTools: _gamma_cdf

    cases = [
        (2.3, 1.7, 1.9),
        (0.5, 2.0, 0.3),
        (5.0, 0.4, 1.0),
        (10.0, 1.0, 9.5),
        (0.3, 1.0, 0.5)
    ]
    for mode in (Mooncake.ReverseMode, Mooncake.ForwardMode),
        (k, θ, x) in cases

        Mooncake.TestUtils.test_rule(
            MersenneTwister(20260711),
            _gamma_cdf, k, θ, x;
            is_primitive = true,
            perf_flag = :none,
            mode = mode
        )
    end
end

@testitem "Enzyme direct rule on _gamma_cdf" tags=[
    :ad, :enzyme, :enzyme_reverse] begin
    # Pins the `EnzymeRules.@easy_rule` for `_gamma_cdf` in
    # EpiAwareADToolsEnzymeExt (the original `Enzyme.@import_rrule` lift returned
    # the wrong ∂P/∂k, ~8% off). The direct rule should match the ForwardDiff
    # reference on both modes at implementation tolerance — scenario grids only
    # agree to ~1e-6, where a wrong shape partial can slip through.
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _gamma_cdf

    f(v) = _gamma_cdf(v[1], v[2], v[3])
    cases = [
        [2.3, 1.7, 1.9],
        [0.5, 2.0, 0.3],
        [5.0, 0.4, 1.0],
        [10.0, 1.0, 9.5]
    ]
    for input in cases
        ref = gradient(f, AutoForwardDiff(), input)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), input)
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), input)
        @test isapprox(g_rev, ref; rtol = 1e-10, atol = 1e-12)
        @test isapprox(g_fwd, ref; rtol = 1e-10, atol = 1e-12)
    end
end

@testitem "Enzyme gamma rule" tags=[:ad, :enzyme, :enzyme_reverse] begin
    # Pins the `SpecialFunctions.gamma` rule in EpiAwareADToolsEnzymeExt. With
    # only EnzymeSpecialFunctionsExt loaded, Enzyme mis-lowers `gamma` to the
    # `loggamma` known-op and returns `ψ(x)` instead of `Γ(x) ψ(x)` — silently
    # wrong by a factor of `Γ(x)` in both modes. `_gamma_cdf_value_and_partials`
    # calls `pdf(Gamma(...))`, which uses `gamma` outside the `_gamma_cdf` rule,
    # so this gap would corrupt the shape partial of the whole pipeline.
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using SpecialFunctions: gamma, digamma

    f(v) = gamma(v[1])
    for x in (0.7, 1.5, 2.0, 3.4, 7.0)
        truth = gamma(x) * digamma(x)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), [x])
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), [x])
        @test isapprox(g_rev[1], truth; rtol = 1e-10, atol = 1e-12)
        @test isapprox(g_fwd[1], truth; rtol = 1e-10, atol = 1e-12)
    end
end

@testitem "_gamma_cdf rrule zero-input guards" tags=[:ad, :forwarddiff] begin
    # Exercise the non-positive-input early-return branch that the scenario
    # suite never hits (all gradient grids use strictly positive x). Without
    # this, the x <= 0 path in `_gamma_cdf_value_and_partials` appears as
    # uncovered defensive code in patch coverage.
    using ChainRulesCore: rrule, NoTangent
    using EpiAwareADTools: _gamma_cdf

    Ω, pb = rrule(_gamma_cdf, 2.0, 1.5, 0.0)
    @test Ω == 0.0
    @test pb(1.0) == (NoTangent(), 0.0, 0.0, 0.0)

    Ω_neg, pb_neg = rrule(_gamma_cdf, 2.0, 1.5, -0.5)
    @test Ω_neg == 0.0
    @test pb_neg(1.0) == (NoTangent(), 0.0, 0.0, 0.0)
end

# AD coverage for `_gamma_logccdf`, the log-space survival companion to
# `_gamma_cdf` (EpiAwareADTools#47). Mirrors the `_gamma_cdf` items above at
# implementation tolerance, plus a tail-specific regression pinning the
# partials' underflow floor that `_gamma_cdf` has no analogue of.

@testitem "_gamma_logccdf matches FiniteDifferences away from the tail" tags=[
    :ad, :forwarddiff] begin
    # `_gamma_logccdf_value_and_partials` reuses `_gamma_cdf`'s shape/scale
    # partials, so this pins that the log-space survival's OWN gradient (not
    # just its value) is correct where the naive `log1p(-F)` formula it
    # replaces used to hold up, following the same finite-difference
    # discipline as `_grad_p_a_series matches FiniteDifferences`.
    using FiniteDifferences: central_fdm
    using DifferentiationInterface: AutoFiniteDifferences, gradient
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _gamma_logccdf

    fd = AutoFiniteDifferences(; fdm = central_fdm(5, 1))
    cases = [(2.3, 1.7, 1.9), (0.5, 2.0, 0.3), (5.0, 0.4, 1.0)]
    for (k, θ, x) in cases
        f(v) = _gamma_logccdf(v[1], v[2], v[3])
        truth = gradient(f, fd, [k, θ, x])
        got = ForwardDiff.gradient(f, [k, θ, x])
        @test isapprox(got, truth; atol = 1e-6, rtol = 1e-6)
    end
end

@testitem "_gamma_logccdf passes Mooncake.TestUtils.test_rule" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    # Mirrors `_gamma_cdf passes Mooncake.TestUtils.test_rule` for the
    # log-space survival rule.
    using Random: MersenneTwister
    using Mooncake: Mooncake
    using EpiAwareADTools: _gamma_logccdf

    cases = [
        (2.3, 1.7, 1.9),
        (0.5, 2.0, 0.3),
        (5.0, 0.4, 1.0),
        (10.0, 1.0, 9.5),
        (0.3, 1.0, 0.5)
    ]
    for mode in (Mooncake.ReverseMode, Mooncake.ForwardMode),
        (k, θ, x) in cases

        Mooncake.TestUtils.test_rule(
            MersenneTwister(20260711),
            _gamma_logccdf, k, θ, x;
            is_primitive = true,
            perf_flag = :none,
            mode = mode
        )
    end
end

@testitem "Enzyme direct rule on _gamma_logccdf" tags=[
    :ad, :enzyme, :enzyme_reverse] begin
    # Mirrors `Enzyme direct rule on _gamma_cdf` for the log-space survival
    # rule.
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _gamma_logccdf

    f(v) = _gamma_logccdf(v[1], v[2], v[3])
    cases = [
        [2.3, 1.7, 1.9],
        [0.5, 2.0, 0.3],
        [5.0, 0.4, 1.0],
        [10.0, 1.0, 9.5]
    ]
    for input in cases
        ref = gradient(f, AutoForwardDiff(), input)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), input)
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), input)
        @test isapprox(g_rev, ref; rtol = 1e-10, atol = 1e-12)
        @test isapprox(g_fwd, ref; rtol = 1e-10, atol = 1e-12)
    end
end

@testitem "_gamma_logccdf_value_and_partials deep-tail gradients" tags=[
    :ad, :forwarddiff] begin
    # EpiAwareADTools#47 (PR #61 review): the partials of a *log* survival
    # converge to finite, non-zero limits in the deep tail — `-dx` is the
    # hazard rate, which tends to `1/θ` — so they must stay accurate past
    # the point where `Q` itself underflows, not floor to `0`. For
    # `Gamma(2, 1)`, `Q(2, z) = (1 + z)exp(-z)` gives closed forms
    # `dx = -z/(1 + z)` and `dθ = z^2/(1 + z)`; the shape partial is
    # checked against finite differences of the stock `logccdf`, which
    # stays finite and accurate here.
    using EpiAwareADTools: _gamma_logccdf_value_and_partials
    using Distributions: Gamma, logccdf
    using FiniteDifferences: central_fdm

    fd = central_fdm(5, 1)

    x = 1000.0
    Ω, dk, dθ, dx = _gamma_logccdf_value_and_partials(2.0, 1.0, x)
    @test Ω ≈ logccdf(Gamma(2.0, 1.0), x)
    @test dx ≈ -x / (1 + x) rtol=1e-12
    @test dθ ≈ x^2 / (1 + x) rtol=1e-12
    # `Q` has underflowed here, so `dk` comes from the `log(z) - ψ(k)`
    # asymptote, accurate to `O(1/z)`.
    @test dk ≈ fd(k -> logccdf(Gamma(k, 1.0), x), 2.0) rtol=2e-3

    # A point where the naive `log1p(-F)` formula was `-Inf` on `main` but
    # `Q` is still a normal float exercises the exact-series `dk` path.
    x2 = 40.0
    Ω2, dk2, dθ2, dx2 = _gamma_logccdf_value_and_partials(2.0, 1.0, x2)
    @test Ω2 ≈ logccdf(Gamma(2.0, 1.0), x2)
    @test dx2 ≈ -x2 / (1 + x2) rtol=1e-10
    @test dθ2 ≈ x2^2 / (1 + x2) rtol=1e-10
    @test dk2 ≈ fd(k -> logccdf(Gamma(k, 1.0), x2), 2.0) rtol=1e-6

    # No NaN/Inf far beyond the underflow boundary either.
    Ω3, dk3, dθ3, dx3 = _gamma_logccdf_value_and_partials(2.0, 1.0, 1.0e6)
    @test all(isfinite, (Ω3, dk3, dθ3, dx3))
end

@testitem "_gamma_logccdf rrule zero-input guards" tags=[
    :ad, :forwarddiff] begin
    # Mirrors `_gamma_cdf rrule zero-input guards` for the log-space survival
    # rule.
    using ChainRulesCore: rrule, NoTangent
    using EpiAwareADTools: _gamma_logccdf

    Ω, pb = rrule(_gamma_logccdf, 2.0, 1.5, 0.0)
    @test Ω == 0.0
    @test pb(1.0) == (NoTangent(), 0.0, 0.0, 0.0)

    Ω_neg, pb_neg = rrule(_gamma_logccdf, 2.0, 1.5, -0.5)
    @test Ω_neg == 0.0
    @test pb_neg(1.0) == (NoTangent(), 0.0, 0.0, 0.0)
end
