"""
    ADFixtures

Shared AD gradient scenarios and backend metadata for EpiAwareADTools. Used by
`test/ad/runtests.jl`. The scenarios differentiate the AD-safe hooks
(`cdf_ad_safe`, `logcdf_ad_safe`, `ccdf_ad_safe`, `logccdf_ad_safe`,
`pdf_ad_safe`) and the internal `_gamma_cdf`/`_beta_cdf` directly with respect
to a Gamma's shape/scale or a Beta's two shape parameters (and, for the
internal functions, the evaluation point), across the ForwardDiff /
ReverseDiff / Enzyme / Mooncake backend matrix. The hook methods the
`SurvivalDistributions` extension adds are covered the same way, differentiated
through a `GeneralizedGamma`'s three parameters. A stock `logpdf(Gamma)`
scenario pinned at `shape == 1` covers the `xlogy`/`xlog1py` Mooncake rules.

The reference gradient is computed with `ForwardDiff`, which propagates its Dual
numbers through the package's own gamma-CDF machinery and matches the reverse
backends (ReverseDiff, Mooncake reverse, Enzyme reverse) to ~1e-6.
"""
module ADFixtures

# `__precompile__(false)` skips the precompile cache so the Mooncake / Enzyme
# load chain does not break the package build on CI. Negligible cost — this
# module is only loaded by the AD test.
__precompile__(false)

using EpiAwareADTools
using EpiAwareADTools: _gamma_cdf, _beta_cdf
using Distributions: Distributions, Gamma, Beta, Exponential, Normal,
    truncated, logcdf, logpdf, quantile
# Loads `EpiAwareADToolsSurvivalDistributionsExt`, whose GeneralizedGamma hook
# methods the survival scenarios below differentiate.
import SurvivalDistributions as SD
using ADTypes: ADTypes, AutoForwardDiff, AutoReverseDiff, AutoMooncake,
    AutoMooncakeForward, AutoEnzyme
using DifferentiationInterface: DifferentiationInterface, Constant
import DifferentiationInterfaceTest as DIT
import ForwardDiff, ReverseDiff, Mooncake, Enzyme

export scenarios, backends, broken_scenario_names,
    backend_broken_scenarios, backend_skip_scenarios

# `contexts` is a tuple of `Constant`-wrapped data passed positionally to DI's
# `gradient` and to the differentiated function.
function _reference(f, θ, contexts)
    return DifferentiationInterface.gradient(
        f, AutoForwardDiff(), θ, contexts...
    )
end

"""
    backends()

AD backends tested, as `(; name, backend)` named tuples. The `name` is what
`test/ad/scenarios.jl` selects by tag.
"""
function backends()
    return [
        (name = "ForwardDiff", backend = AutoForwardDiff()),
        (
            name = "ReverseDiff (tape)",
            backend = AutoReverseDiff(compile = false),
        ),
        (
            name = "Mooncake reverse",
            backend = AutoMooncake(config = nothing),
        ),
        (name = "Mooncake forward", backend = AutoMooncakeForward()),
        (
            name = "Enzyme reverse",
            backend = AutoEnzyme(
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse)
            ),
        ),
        (
            name = "Enzyme forward",
            backend = AutoEnzyme(
                mode = Enzyme.set_runtime_activity(Enzyme.Forward)
            ),
        ),
    ]
end

"Scenario names broken on every backend."
broken_scenario_names() = String[]

"Per-backend broken scenario names (`Dict{String, Set{String}}`)."
backend_broken_scenarios() = Dict{String, Set{String}}()

"Per-backend scenario names too unstable to run at all."
backend_skip_scenarios() = Dict{String, Set{String}}()

"""
    scenarios(; with_reference::Bool = false, category::Symbol = :marginal)

The AD gradient scenarios. Each is a `DIT.Scenario{:gradient, :out}` whose
`res1` carries a ForwardDiff reference when `with_reference = true`. All
scenarios sit in one group, so `category` is accepted for the harness contract
but unused.
"""
function scenarios(; with_reference::Bool = false, category::Symbol = :marginal)
    obs = [0.5, 1.2, 2.5, 3.8, 5.1]

    out = DIT.Scenario{:gradient, :out}[]

    # `reference` pins the expected gradient instead of computing it with
    # ForwardDiff. Use it where the property under test is the VALUE of the
    # gradient rather than agreement between backends: a self-computed
    # reference moves with any regression ForwardDiff itself is subject to,
    # so the check would stay green while the answer went wrong.
    function _push!(name, f, θ₀, contexts; reference = nothing)
        res1 = if !with_reference
            nothing
        elseif reference === nothing
            _reference(f, θ₀, contexts)
        else
            reference
        end
        prep_args = (; x = θ₀, contexts = contexts)
        return push!(
            out,
            res1 === nothing ?
                DIT.Scenario{:gradient, :out}(
                    f, θ₀, contexts...; prep_args = prep_args, name = name
                ) :
                DIT.Scenario{:gradient, :out}(
                    f, θ₀, contexts...;
                    res1 = res1, prep_args = prep_args, name = name
                )
        )
    end

    # Each hook, differentiated through a Gamma's shape/scale. The `Gamma`
    # methods route through `_gamma_cdf`, so these exercise the reverse-mode
    # rrule (ReverseDiff, Mooncake reverse, Enzyme reverse), the forward frule
    # (Mooncake forward), and the ForwardDiff Dual methods end to end.
    _push!(
        "cdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> cdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),)
    )
    _push!(
        "logcdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> logcdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),)
    )
    _push!(
        "ccdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> ccdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),)
    )
    _push!(
        "logccdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> logccdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),)
    )
    # `pdf_ad_safe` on a Gamma differentiates through `pdf(Gamma)`, whose shape
    # partial calls `SpecialFunctions.gamma`; on Enzyme this exercises the
    # `gamma` rule in `EpiAwareADToolsEnzymeExt` (Enzyme's own lowering is wrong
    # by a factor of Γ(x)).
    _push!(
        "pdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> pdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),)
    )

    # Stock `logpdf(Gamma)` at shape EXACTLY 1.0, where `gammalogpdf`'s
    # `xlogy(shape - 1, x / scale)` hits `xlogy` at a zero first argument. The
    # `xlogy`/`xlog1py` rules in
    # `EpiAwareADToolsLogExpFunctionsMooncakeExt` are what keep the two
    # Mooncake modes agreeing with the reference here; without them both
    # return `-digamma(1)` for the shape component.
    _push!(
        "logpdf Gamma at shape 1",
        (θ, obs) -> sum(x -> logpdf(Gamma(θ[1], θ[2]), x), obs),
        [1.0, 2.0], (Constant(obs),)
    )

    # The internal `_gamma_cdf(k, θ, x)` differentiated in all three arguments,
    # exercising the dk / dθ / dx partials of the shared rule directly.
    _push!(
        "_gamma_cdf direct",
        (θ, _obs) -> _gamma_cdf(θ[1], θ[2], θ[3]),
        [2.3, 1.7, 1.9], (Constant(obs),)
    )

    # Beta support is (0,1); `obs_beta` spans both sides of the α/(α+β)
    # reflection threshold `_beta_cdf_value_and_partials` switches branches
    # on, so both the direct and reflected continued-fraction paths get
    # exercised end to end.
    obs_beta = [0.05, 0.2, 0.4, 0.6, 0.8, 0.95]

    _push!(
        "cdf_ad_safe Beta",
        (θ, obs) -> sum(x -> cdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),)
    )
    _push!(
        "logcdf_ad_safe Beta",
        (θ, obs) -> sum(x -> logcdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),)
    )
    _push!(
        "ccdf_ad_safe Beta",
        (θ, obs) -> sum(x -> ccdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),)
    )
    _push!(
        "logccdf_ad_safe Beta",
        (θ, obs) -> sum(x -> logccdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),)
    )
    _push!(
        "pdf_ad_safe Beta",
        (θ, obs) -> sum(x -> pdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),)
    )

    # The internal `_beta_cdf(α, β, x)` differentiated in all three
    # arguments, exercising the dα / dβ / dx partials of the shared rule
    # directly, at a point on the reflected branch (x > α/(α+β)).
    _push!(
        "_beta_cdf direct",
        (θ, _obs) -> _beta_cdf(θ[1], θ[2], θ[3]),
        [1.7, 2.3, 0.85], (Constant(obs_beta),)
    )

    # `nondifferentiable` (EpiAwareADTools#37): `θ[1]` flows only through the
    # wrapped term, `θ[2]` only through the plain one, so the reference
    # gradient's first component is EXACTLY zero regardless of backend —
    # this scenario's whole point is confirming every backend agrees on
    # that, not just that the numbers happen to match.
    _push!(
        "nondifferentiable wrapped term",
        (θ, _obs) -> nondifferentiable(x -> x^2)(θ[1]) + θ[2]^2,
        [2.0, 1.5], (Constant(obs),)
    )
    # The same, with the whole live parameter VECTOR as the argument, so
    # `primal(::AbstractArray)` is swept on every backend. Both components
    # reach the wrapped term and neither derivative survives it, leaving the
    # plain term as the only contribution: the gradient is `[0, 2θ[2]]`.
    _push!(
        "nondifferentiable array argument",
        (θ, _obs) -> nondifferentiable(sum)(θ) + θ[2]^2,
        [2.0, 1.5], (Constant(obs),)
    )
    # A CAPTURED value rather than an argument: `θ[1]` reaches the wrapped
    # function by closure, so the argument-strip never sees it and only the
    # wrapper's RESULT-strip (plus the `inactive` / `@zero_derivative` marks
    # the backends without one rely on) drives its contribution to zero. That
    # makes this the scenario that pins the result-strip in place; the two
    # above pass on argument-stripping alone. The reference is written out
    # rather than taken from ForwardDiff precisely because ForwardDiff is one
    # of the backends that reads the captured value through the body: drop the
    # result-strip and its reference would go wrong alongside its gradient,
    # and the scenario would keep passing. Gradient is `[0, 2θ[2]]`.
    _push!(
        "nondifferentiable captured value",
        (θ, _obs) -> nondifferentiable(() -> θ[1]^2)() + θ[2]^2,
        [2.0, 1.5], (Constant(obs),); reference = [0.0, 3.0]
    )
    # `primal_distribution` on a `Truncated` (EpiAwareADTools#57, #58): the
    # window quantile of a pre-truncated component must be a constant. `θ[1]`
    # reaches the result ONLY through the strip and `θ[2]` only through the
    # plain term, so the first gradient component is EXACTLY zero. The
    # reference is written out for the same reason as the captured-value
    # scenario above: a ForwardDiff self-reference would move with the very
    # regression this pins. `Exponential`/`Normal` rather than `Gamma` —
    # `truncated(Gamma{Dual}, l, u)` cannot be built at all, since
    # `_logcdf_noninclusive` reaches `gamma_inc` on a `Dual`.
    _push!(
        "primal_distribution truncated window",
        (θ, _obs) -> quantile(
            primal_distribution(truncated(Exponential(θ[1]), 0.5, 10.0)),
            0.9
        ) + θ[2]^2,
        [1.5, 2.0], (Constant(obs),); reference = [0.0, 4.0]
    )
    # The same for a one-sided truncation, which routes the absent bound
    # through `primal(::Nothing)` on every backend.
    _push!(
        "primal_distribution left-truncated window",
        (θ, _obs) -> quantile(
            primal_distribution(truncated(Normal(θ[1], θ[2]); lower = 0.5)),
            0.9
        ) + θ[2]^2,
        [1.5, 2.0], (Constant(obs),); reference = [0.0, 4.0]
    )
    # `logsumexp_stream` (EpiAwareADTools#39): a parameterised geometric
    # series Σ_{k≥0} exp(-k·θ), differentiated in θ. Plain generic control
    # flow with no non-differentiable primitive, so this needs no bespoke
    # per-backend rule — the scenario exists to confirm every backend
    # differentiates straight through the accumulator's loop.
    _push!(
        "logsumexp_stream geometric",
        (θ, _obs) -> EpiAwareADTools.logsumexp_stream(
            k -> -k * θ[1]
        ).value,
        [1.0], (Constant(obs),)
    )
    # `fixed_draw` (EpiAwareADTools#38): `θ[1]` reaches the result only
    # through the pinned draw, so its derivative is EXACTLY zero regardless
    # of backend — the reparameterisation-trick complement of the
    # `nondifferentiable` scenarios above, pinned the same way. `θ[2]`
    # reaches the plain term, giving gradient `[0, 2θ[2]]`.
    _push!(
        "fixed_draw pinned realisation",
        (θ, _obs) -> fixed_draw(θ[1]) + θ[2]^2,
        [2.0, 1.5], (Constant(obs),)
    )
    # `ad_eltype` (EpiAwareADTools#38): a `Vector{Float64}` buffer errors
    # the moment a `Dual`/`TrackedReal` term is written into it (see
    # `test/unit/reparameterise.jl`'s direct demonstration), so this
    # scenario seeds the buffer at `ad_eltype(θ)` instead and checks the
    # gradient survives on every backend — including Enzyme and Mooncake,
    # which never surface a wrapper type to the primal computation at all,
    # so `ad_eltype` is a harmless `Float64` no-op there and the buffer
    # never risked the footgun in the first place.
    _push!(
        "ad_eltype seeds a differentiable buffer",
        (θ, obs) -> begin
            T = EpiAwareADTools.ad_eltype(θ)
            buf = Vector{T}(undef, length(obs))
            for (i, x) in enumerate(obs)
                buf[i] = θ[1] * x + θ[2]
            end
            sum(buf)
        end,
        [2.0, 1.5], (Constant(obs),)
    )
    # Each hook on a `SurvivalDistributions.GeneralizedGamma`, differentiated
    # in all three of its parameters, which the constructor takes in the order
    # `(sigma, nu, gamma)`. The methods live in
    # `EpiAwareADToolsSurvivalDistributionsExt` and route the inner
    # `Gamma(nu/gamma, sigma^gamma)` through `cdf_ad_safe` at the transformed
    # point `x^gamma`, so these check the gradient survives both the parameter
    # transform and the shared `_gamma_cdf` rule. Without the extension the
    # stock path reaches `StatsFuns._gammalogccdf` and errors on every backend.
    θ_gg = [1.5, 2.0, 1.3]

    _push!(
        "cdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> cdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs
        ),
        θ_gg, (Constant(obs),)
    )
    _push!(
        "logcdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logcdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x),
            obs
        ),
        θ_gg, (Constant(obs),)
    )
    _push!(
        "ccdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> ccdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs
        ),
        θ_gg, (Constant(obs),)
    )
    _push!(
        "logccdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logccdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x),
            obs
        ),
        θ_gg, (Constant(obs),)
    )
    # `pdf_ad_safe` needs no bespoke GeneralizedGamma method — `logpdf(GG)` is
    # elementary bar `loggamma` — but it is the half of a survival likelihood
    # the CDF hooks do not supply, and `loggamma` is exactly what the package's
    # bespoke Enzyme `gamma` rule exists for. Swept here so the fallthrough is
    # pinned across the matrix rather than assumed.
    _push!(
        "pdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> pdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs
        ),
        θ_gg, (Constant(obs),)
    )
    # The public `logcdf` method the extension adds: `SurvivalDistributions`
    # leaves `logcdf` unclaimed, so this pins that a bare `logcdf` call on a
    # GeneralizedGamma differentiates rather than falling through to the
    # generic `log(cdf(d, x))`, which reaches `StatsFuns._gammalogccdf` via
    # `SurvivalDistributions`' survival-defined `cdf`.
    _push!(
        "logcdf GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logcdf(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs
        ),
        θ_gg, (Constant(obs),)
    )

    return out
end

end # module ADFixtures
