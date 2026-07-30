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
through a `GeneralizedGamma`'s three parameters.

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
using Distributions: Distributions, Gamma, Beta, logcdf
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
        f, AutoForwardDiff(), θ, contexts...)
end

"""
    backends()

AD backends tested, as `(; name, backend)` named tuples. The `name` is what
`test/ad/scenarios.jl` selects by tag.
"""
function backends()
    return [
        (name = "ForwardDiff", backend = AutoForwardDiff()),
        (name = "ReverseDiff (tape)",
            backend = AutoReverseDiff(compile = false)),
        (name = "Mooncake reverse",
            backend = AutoMooncake(config = nothing)),
        (name = "Mooncake forward", backend = AutoMooncakeForward()),
        (name = "Enzyme reverse",
            backend = AutoEnzyme(
                mode = Enzyme.set_runtime_activity(Enzyme.Reverse))),
        (name = "Enzyme forward",
            backend = AutoEnzyme(
                mode = Enzyme.set_runtime_activity(Enzyme.Forward)))
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

    function _push!(name, f, θ₀, contexts)
        res1 = with_reference ? _reference(f, θ₀, contexts) : nothing
        prep_args = (; x = θ₀, contexts = contexts)
        push!(out,
            res1 === nothing ?
            DIT.Scenario{:gradient, :out}(
                f, θ₀, contexts...; prep_args = prep_args, name = name) :
            DIT.Scenario{:gradient, :out}(
                f, θ₀, contexts...;
                res1 = res1, prep_args = prep_args, name = name))
    end

    # Each hook, differentiated through a Gamma's shape/scale. The `Gamma`
    # methods route through `_gamma_cdf`, so these exercise the reverse-mode
    # rrule (ReverseDiff, Mooncake reverse, Enzyme reverse), the forward frule
    # (Mooncake forward), and the ForwardDiff Dual methods end to end.
    _push!("cdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> cdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),))
    _push!("logcdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> logcdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),))
    _push!("ccdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> ccdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),))
    _push!("logccdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> logccdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),))
    # `pdf_ad_safe` on a Gamma differentiates through `pdf(Gamma)`, whose shape
    # partial calls `SpecialFunctions.gamma`; on Enzyme this exercises the
    # `gamma` rule in `EpiAwareADToolsEnzymeExt` (Enzyme's own lowering is wrong
    # by a factor of Γ(x)).
    _push!("pdf_ad_safe Gamma",
        (θ, obs) -> sum(x -> pdf_ad_safe(Gamma(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs),))

    # The internal `_gamma_cdf(k, θ, x)` differentiated in all three arguments,
    # exercising the dk / dθ / dx partials of the shared rule directly.
    _push!("_gamma_cdf direct",
        (θ, _obs) -> _gamma_cdf(θ[1], θ[2], θ[3]),
        [2.3, 1.7, 1.9], (Constant(obs),))

    # Beta support is (0,1); `obs_beta` spans both sides of the α/(α+β)
    # reflection threshold `_beta_cdf_value_and_partials` switches branches
    # on, so both the direct and reflected continued-fraction paths get
    # exercised end to end.
    obs_beta = [0.05, 0.2, 0.4, 0.6, 0.8, 0.95]

    _push!("cdf_ad_safe Beta",
        (θ, obs) -> sum(x -> cdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),))
    _push!("logcdf_ad_safe Beta",
        (θ, obs) -> sum(x -> logcdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),))
    _push!("ccdf_ad_safe Beta",
        (θ, obs) -> sum(x -> ccdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),))
    _push!("logccdf_ad_safe Beta",
        (θ, obs) -> sum(x -> logccdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),))
    _push!("pdf_ad_safe Beta",
        (θ, obs) -> sum(x -> pdf_ad_safe(Beta(θ[1], θ[2]), x), obs),
        [2.0, 1.0], (Constant(obs_beta),))

    # The internal `_beta_cdf(α, β, x)` differentiated in all three
    # arguments, exercising the dα / dβ / dx partials of the shared rule
    # directly, at a point on the reflected branch (x > α/(α+β)).
    _push!("_beta_cdf direct",
        (θ, _obs) -> _beta_cdf(θ[1], θ[2], θ[3]),
        [1.7, 2.3, 0.85], (Constant(obs_beta),))

    # `logsumexp_stream` (EpiAwareADTools#39): a parameterised geometric
    # series Σ_{k≥0} exp(-k·θ), differentiated in θ. Plain generic control
    # flow with no non-differentiable primitive, so this needs no bespoke
    # per-backend rule — the scenario exists to confirm every backend
    # differentiates straight through the accumulator's loop.
    _push!("logsumexp_stream geometric",
        (θ, _obs) -> EpiAwareADTools.logsumexp_stream(
            k -> -k * θ[1]).value,
        [1.0], (Constant(obs),))
    # Each hook on a `SurvivalDistributions.GeneralizedGamma`, differentiated
    # in all three of its parameters, which the constructor takes in the order
    # `(sigma, nu, gamma)`. The methods live in
    # `EpiAwareADToolsSurvivalDistributionsExt` and route the inner
    # `Gamma(nu/gamma, sigma^gamma)` through `cdf_ad_safe` at the transformed
    # point `x^gamma`, so these check the gradient survives both the parameter
    # transform and the shared `_gamma_cdf` rule. Without the extension the
    # stock path reaches `StatsFuns._gammalogccdf` and errors on every backend.
    θ_gg = [1.5, 2.0, 1.3]

    _push!("cdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> cdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs),
        θ_gg, (Constant(obs),))
    _push!("logcdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logcdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x),
            obs),
        θ_gg, (Constant(obs),))
    _push!("ccdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> ccdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs),
        θ_gg, (Constant(obs),))
    _push!("logccdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logccdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x),
            obs),
        θ_gg, (Constant(obs),))
    # `pdf_ad_safe` needs no bespoke GeneralizedGamma method — `logpdf(GG)` is
    # elementary bar `loggamma` — but it is the half of a survival likelihood
    # the CDF hooks do not supply, and `loggamma` is exactly what the package's
    # bespoke Enzyme `gamma` rule exists for. Swept here so the fallthrough is
    # pinned across the matrix rather than assumed.
    _push!("pdf_ad_safe GeneralizedGamma",
        (θ, obs) -> sum(
            x -> pdf_ad_safe(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs),
        θ_gg, (Constant(obs),))
    # The public `logcdf` method the extension adds: `SurvivalDistributions`
    # leaves `logcdf` unclaimed, so this pins that a bare `logcdf` call on a
    # GeneralizedGamma differentiates rather than falling through to the
    # generic `log(cdf(d, x))`, which reaches `StatsFuns._gammalogccdf` via
    # `SurvivalDistributions`' survival-defined `cdf`.
    _push!("logcdf GeneralizedGamma",
        (θ, obs) -> sum(
            x -> logcdf(SD.GeneralizedGamma(θ[1], θ[2], θ[3]), x), obs),
        θ_gg, (Constant(obs),))

    return out
end

end # module ADFixtures
