module EpiAwareADToolsEnzymeExt

using EpiAwareADTools: primal, _gamma_cdf, _gamma_cdf_value_and_partials,
                       _beta_cdf, _beta_cdf_value_and_partials,
                       NonDifferentiable
using Enzyme: Enzyme
using Enzyme.EnzymeRules: EnzymeRules
using SpecialFunctions: gamma, digamma

# `primal` is a tape-strip returning a non-differentiable primal value, so it is
# marked `EnzymeRules.inactive`: Enzyme runs the primal unchanged and treats the
# result as a constant, contributing no tangent / no cotangent in either mode.
# `inactive` covers every activity / batch-width / mode permutation uniformly.
# Other backends get the same treatment via the ChainRules `@non_differentiable
# primal` mark, the ForwardDiff/ReverseDiff primal-stripping methods, and the
# Mooncake `@zero_derivative` rule.
EnzymeRules.inactive(::typeof(primal), args...) = nothing

# `NonDifferentiable` (EpiAwareADTools#37): the same `inactive` marking,
# generalised from the one specific function `primal` to ANY instance of the
# wrapper type, regardless of the wrapped function `F` — one registration
# covers every user function wrapped with `nondifferentiable`, including a
# closure, since dispatch matches on the wrapper's own (unparametrised)
# type. Enzyme treats the whole call as a constant in every mode (confirmed
# directly: this also silently zeroes a captured value's contribution if the
# wrapped closure closes over a live differentiated value rather than
# receiving it as an argument — see `nondifferentiable`'s docstring).
EnzymeRules.inactive(::NonDifferentiable, args...) = nothing

# `EnzymeRules.@easy_rule` expands into both the reverse-mode
# (`augmented_primal` / `reverse`) and forward-mode (`forward`) rules for
# `_gamma_cdf`. The analytical (dk, dθ, dx) come from
# `_gamma_cdf_value_and_partials` in `src/gamma_ad.jl`, the single
# source-of-truth helper shared with the ChainRules rrule and the ForwardDiff
# Dual path. Routing `_gamma_cdf` through this rule avoids Enzyme
# differentiating `SpecialFunctions.gamma_inc` directly.
EnzymeRules.@easy_rule(_gamma_cdf(k::Real, θ::Real, x::Real),
    @setup(_vp=_gamma_cdf_value_and_partials(k, θ, x),
        dk=_vp[2],
        dθ=_vp[3],
        dx=_vp[4],),
    (dk, dθ, dx))

# Rule for `SpecialFunctions.gamma`, derivative `d/dx Γ(x) = Γ(x) ψ(x)` (`Ω`
# binds to the primal `Γ(x)`; same formula as the ChainRules `gamma` frule/rrule
# that Mooncake/ReverseDiff pick up). Enzyme's own `EnzymeSpecialFunctionsExt`
# ships no `gamma` rule and instead mis-lowers `gamma(x)` to the `loggamma`
# known-op, returning `ψ(x)` — wrong by a factor of `Γ(x)` in both modes
# (an upstream Enzyme bug). The `_gamma_cdf_value_and_partials`
# helper calls `pdf(Gamma(...))`, which uses `gamma` outside the `_gamma_cdf`
# rule, so this keeps the shape partial correct.
EnzymeRules.@easy_rule(gamma(x::Real), (Ω * digamma(x),))

# `EnzymeRules.@easy_rule` for `_beta_cdf`, the `_gamma_cdf` rule's counterpart.
# The analytical (dα, dβ, dx) come from `_beta_cdf_value_and_partials` in
# `src/beta_ad.jl`, the same source-of-truth helper the ChainRules rrule and
# the ForwardDiff Dual path use. Routing `_beta_cdf` through this rule avoids
# Enzyme differentiating `SpecialFunctions.beta_inc` directly, and — since
# Enzyme never traces into the black-box helper — the `gamma(x)` mis-lowering
# noted above cannot affect the `pdf(Beta(...))` call `_beta_cdf_value_and_partials`
# makes for `dx` either.
EnzymeRules.@easy_rule(_beta_cdf(α::Real, β::Real, x::Real),
    @setup(_vp=_beta_cdf_value_and_partials(α, β, x),
        dα=_vp[2],
        dβ=_vp[3],
        dx=_vp[4],),
    (dα, dβ, dx))

end
