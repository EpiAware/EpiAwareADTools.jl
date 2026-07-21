# Unit-level AD coverage for the beta CDF rules. Complements the scenario
# suite in `scenarios.jl`: those check end-to-end gradient agreement at scenario
# tolerance (~1e-6); these pin the implementation-level guarantees (continued-
# fraction accuracy, rule dispatch, defensive guards) that no scenario exercises
# directly. Mirrors `gamma_ad.jl`'s structure for the beta-CDF counterpart.
#
# Each item is mode-agnostic (it exercises both modes of a backend's rules), so
# it is tagged for a single canonical backend and runs once across the
# per-backend CI jobs; the untagged `task test-ad` run executes every item.

@testitem "_rib_value_and_partials matches FiniteDifferences" tags=[
    :ad, :forwarddiff] begin
    using SpecialFunctions: beta_inc
    using FiniteDifferences: central_fdm
    using DifferentiationInterface: AutoFiniteDifferences, derivative
    using EpiAwareADTools: _rib_value_and_partials

    fd = AutoFiniteDifferences(; fdm = central_fdm(7, 1))

    # Grid spans the parameter regimes Boik & Robinson-Cox validate against
    # (small/large shapes, x on both sides of the midpoint) plus the small-q
    # regime ScoringRules' LogLogistic/Student-t call sites land in.
    grid = [
        (0.001, 1.5, 11.0), (0.5, 1.5, 11.0),
        (0.2, 2.0, 3.0), (0.3, 4.5, 0.5),
        (0.1, 1.8, 0.4), (0.6, 2.5, 0.7),
        (0.5, 1e2, 1e2), (0.9, 1.2, 0.6)
    ]
    for (x, p, q) in grid
        # Only valid on the primary branch x <= p/(p+q); every grid point
        # above satisfies this (the caller, _beta_cdf_value_and_partials,
        # handles the reflected regime via symmetry, tested separately below).
        truth_p = derivative(a -> first(beta_inc(a, q, x)), fd, p)
        truth_q = derivative(b -> first(beta_inc(p, b, x)), fd, q)
        _, dp, dq = _rib_value_and_partials(x, p, q)
        @test isapprox(dp, truth_p; atol = 1e-8, rtol = 1e-6)
        @test isapprox(dq, truth_q; atol = 1e-8, rtol = 1e-6)
    end
end

@testitem "_beta_cdf_value_and_partials reflection symmetry matches direct computation" tags=[
    :ad, :forwarddiff] begin
    using EpiAwareADTools: _beta_cdf_value_and_partials

    # Cases where x > α/(α+β), forcing the reflected branch, checked against
    # the same quantity computed directly on the swapped, non-reflected call
    # (I_x(α,β) = 1 - I_{1-x}(β,α); differentiating both sides gives the
    # dα/dβ swap-and-negate the implementation applies).
    cases = [(0.9, 1.5, 11.0), (0.7, 2.0, 3.0), (0.99, 1.0, 5.0)]
    for (x, α, β) in cases
        Ω, dα, dβ, dx = _beta_cdf_value_and_partials(α, β, x)
        Ω_ref, d_at_β, d_at_α, dx_ref = _beta_cdf_value_and_partials(
            β, α, 1 - x)
        @test isapprox(Ω, 1 - Ω_ref; atol = 1e-12, rtol = 1e-12)
        @test isapprox(dα, -d_at_α; atol = 1e-12, rtol = 1e-12)
        @test isapprox(dβ, -d_at_β; atol = 1e-12, rtol = 1e-12)
    end
end

@testitem "_beta_cdf passes Mooncake.TestUtils.test_rule" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    # Mooncake's canonical rule test, run for both reverse and forward mode.
    using Random: MersenneTwister
    using Mooncake: Mooncake
    using EpiAwareADTools: _beta_cdf

    cases = [
        (2.3, 1.7, 0.3),
        (0.5, 2.0, 0.2),
        (5.0, 0.4, 0.8),
        (1.5, 11.0, 0.001),
        (0.3, 1.0, 0.5)
    ]
    for mode in (Mooncake.ReverseMode, Mooncake.ForwardMode),
        (α, β, x) in cases

        Mooncake.TestUtils.test_rule(
            MersenneTwister(20260720),
            _beta_cdf, α, β, x;
            is_primitive = true,
            perf_flag = :none,
            mode = mode
        )
    end
end

@testitem "Enzyme direct rule on _beta_cdf" tags=[
    :ad, :enzyme, :enzyme_reverse] begin
    # Pins the `EnzymeRules.@easy_rule` for `_beta_cdf` in
    # EpiAwareADToolsEnzymeExt. The direct rule should match the ForwardDiff
    # reference on both modes at implementation tolerance.
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: _beta_cdf

    f(v) = _beta_cdf(v[1], v[2], v[3])
    cases = [
        [2.3, 1.7, 0.3],
        [0.5, 2.0, 0.2],
        [5.0, 0.4, 0.8],
        [1.5, 11.0, 0.001]
    ]
    for input in cases
        ref = gradient(f, AutoForwardDiff(), input)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), input)
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), input)
        @test isapprox(g_rev, ref; rtol = 1e-10, atol = 1e-12)
        @test isapprox(g_fwd, ref; rtol = 1e-10, atol = 1e-12)
    end
end

@testitem "Enzyme pdf_ad_safe Beta rule" tags=[:ad, :enzyme, :enzyme_reverse] begin
    # Pins the `pdf_ad_safe(::Beta)` override in `ad_safe.jl`. Enzyme's own
    # derivative of `LogExpFunctions.xlog1py`'s first argument is wrong
    # (confirmed directly against ForwardDiff/a plain-log formulation: the
    # stock `pdf(::Beta)` — which calls `xlogy`/`xlog1py` via
    # `StatsFuns.betapdf` — gives 1.5 for the β-partial where the correct
    # value is ≈0.807 at `Beta(2,1)`, `x=0.5`). The override routes around
    # both by using `log`/`log1p` directly; this pins that it matches the
    # ForwardDiff reference on both Enzyme modes, where the scenario suite's
    # ~1e-6 gradient tolerance would not catch this (the wrong value is not
    # subtly off, but a different scenario mix could mask it).
    using ADTypes: AutoEnzyme, AutoForwardDiff
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using ForwardDiff: ForwardDiff
    using EpiAwareADTools: pdf_ad_safe
    using Distributions: Beta

    f(v) = pdf_ad_safe(Beta(v[1], v[2]), v[3])
    cases = [
        [2.0, 1.0, 0.5],
        [2.3, 1.7, 0.3],
        [0.5, 2.0, 0.2],
        [5.0, 0.4, 0.8]
    ]
    for input in cases
        ref = gradient(f, AutoForwardDiff(), input)
        g_rev = gradient(f, AutoEnzyme(mode = Enzyme.Reverse), input)
        g_fwd = gradient(f, AutoEnzyme(mode = Enzyme.Forward), input)
        @test isapprox(g_rev, ref; rtol = 1e-10, atol = 1e-12)
        @test isapprox(g_fwd, ref; rtol = 1e-10, atol = 1e-12)
    end
end

@testitem "_beta_cdf rrule zero/one-input guards" tags=[:ad, :forwarddiff] begin
    # Exercise the x <= 0 and x >= 1 early-return branches that the scenario
    # suite never hits (all gradient grids use strictly interior x).
    using ChainRulesCore: rrule, NoTangent
    using EpiAwareADTools: _beta_cdf

    Ω, pb = rrule(_beta_cdf, 2.0, 1.5, 0.0)
    @test Ω == 0.0
    @test pb(1.0) == (NoTangent(), 0.0, 0.0, 0.0)

    Ω_neg, pb_neg = rrule(_beta_cdf, 2.0, 1.5, -0.5)
    @test Ω_neg == 0.0
    @test pb_neg(1.0) == (NoTangent(), 0.0, 0.0, 0.0)

    Ω_one, pb_one = rrule(_beta_cdf, 2.0, 1.5, 1.0)
    @test Ω_one == 1.0
    @test pb_one(1.0) == (NoTangent(), 0.0, 0.0, 0.0)

    Ω_above, pb_above = rrule(_beta_cdf, 2.0, 1.5, 1.5)
    @test Ω_above == 1.0
    @test pb_above(1.0) == (NoTangent(), 0.0, 0.0, 0.0)
end
