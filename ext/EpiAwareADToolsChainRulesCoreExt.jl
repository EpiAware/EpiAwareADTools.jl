module EpiAwareADToolsChainRulesCoreExt

using EpiAwareADTools: primal, _gamma_cdf, _gamma_cdf_value_and_partials,
    _gamma_logccdf, _gamma_logccdf_value_and_partials,
    _beta_cdf, _beta_cdf_value_and_partials,
    NonDifferentiable
using ChainRulesCore: ChainRulesCore, NoTangent

# `primal` is a tape-strip returning a non-differentiable primal value (a
# quadrature-window endpoint, a clamp location — just *where* to do something,
# carrying no gradient). Marking it `@non_differentiable` keeps reverse-mode AD
# — and Mooncake, which lifts ChainRules rules — from tracing through it.
ChainRulesCore.@non_differentiable primal(::Any)

# `NonDifferentiable` (EpiAwareADTools#37) generalises the same
# non-differentiable-primitive discipline `primal` gets above to an
# arbitrary user function, registered ONCE here rather than once per user
# function. The call's own body already strips both its arguments and its
# result via `primal`, so this marking is defence-in-depth for a
# ChainRules-consuming context beyond the four backends this package tests
# directly (mirrors `primal`'s own registration above).
ChainRulesCore.@non_differentiable (nd::NonDifferentiable)(args...)

# Reverse- and forward-mode rules for `_gamma_cdf(k, θ, x) = P(k, x/θ)`. The
# analytical partials live in `_gamma_cdf_value_and_partials` (in
# `src/gamma_ad.jl`) so the ForwardDiff Dual path and the direct Enzyme rule
# share the same formulas. Only the k-partial is non-trivial — that's the term
# SpecialFunctions' own ChainRule leaves as `@not_implemented`; see
# `_grad_p_a_series` for the series form (Moore 1982 AS 187, the same
# construction Stan and JAX use).
function ChainRulesCore.rrule(::typeof(_gamma_cdf), k::Real, θ::Real, x::Real)
    Ω, dk, dθ, dx = _gamma_cdf_value_and_partials(k, θ, x)
    function _gamma_cdf_pullback(ȳ)
        return (NoTangent(), dk * ȳ, dθ * ȳ, dx * ȳ)
    end
    return Ω, _gamma_cdf_pullback
end

# Forward-mode rule, used by Mooncake's forward mode via the `@from_chainrules`
# lift in `EpiAwareADToolsMooncakeExt` (ForwardDiff dispatches on `Dual` types
# directly, so it never reaches here). Without this, Mooncake's forward lift
# calls `ChainRulesCore.frule`, which returns `nothing` for an undefined rule
# and trips `iterate(::Nothing)`.
function ChainRulesCore.frule(
        (_, Δk, Δθ, Δx), ::typeof(_gamma_cdf), k::Real, θ::Real, x::Real
    )
    Ω, dk, dθ, dx = _gamma_cdf_value_and_partials(k, θ, x)
    return Ω, dk * Δk + dθ * Δθ + dx * Δx
end

# Reverse- and forward-mode rules for `_gamma_logccdf(k, θ, x) =
# log(Q(k, x/θ))`, the log-space survival companion to `_gamma_cdf`
# (EpiAwareADTools#47). The analytical partials live in
# `_gamma_logccdf_value_and_partials` (in `src/gamma_ad.jl`), which reuses
# `_gamma_cdf_value_and_partials`'s `(dk, dθ, dx)` divided by an
# accurately-computed `Q` rather than a literal `1 - P`.
function ChainRulesCore.rrule(
        ::typeof(_gamma_logccdf), k::Real, θ::Real, x::Real
    )
    Ω, dk, dθ, dx = _gamma_logccdf_value_and_partials(k, θ, x)
    function _gamma_logccdf_pullback(ȳ)
        return (NoTangent(), dk * ȳ, dθ * ȳ, dx * ȳ)
    end
    return Ω, _gamma_logccdf_pullback
end

function ChainRulesCore.frule(
        (_, Δk, Δθ, Δx), ::typeof(_gamma_logccdf), k::Real, θ::Real, x::Real
    )
    Ω, dk, dθ, dx = _gamma_logccdf_value_and_partials(k, θ, x)
    return Ω, dk * Δk + dθ * Δθ + dx * Δx
end

# Reverse- and forward-mode rules for `_beta_cdf(α, β, x) = I_x(α, β)`. The
# analytical partials live in `_beta_cdf_value_and_partials` (in
# `src/beta_ad.jl`) so the ForwardDiff Dual path and the direct Enzyme rule
# share the same formulas. The α/β-partials are the terms `beta_inc`'s own
# `ChainRule` leaves unimplemented; see `_rib_value_and_partials` for the
# continued-fraction form (Boik & Robinson-Cox 1998).
function ChainRulesCore.rrule(::typeof(_beta_cdf), α::Real, β::Real, x::Real)
    Ω, dα, dβ, dx = _beta_cdf_value_and_partials(α, β, x)
    function _beta_cdf_pullback(ȳ)
        return (NoTangent(), dα * ȳ, dβ * ȳ, dx * ȳ)
    end
    return Ω, _beta_cdf_pullback
end

function ChainRulesCore.frule(
        (_, Δα, Δβ, Δx), ::typeof(_beta_cdf), α::Real, β::Real, x::Real
    )
    Ω, dα, dβ, dx = _beta_cdf_value_and_partials(α, β, x)
    return Ω, dα * Δα + dβ * Δβ + dx * Δx
end

end
