module EpiAwareADToolsEnzymeExt

using EpiAwareADTools: primal, _gamma_cdf, _gamma_cdf_value_and_partials
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

end
