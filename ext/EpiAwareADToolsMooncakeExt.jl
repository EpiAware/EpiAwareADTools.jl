module EpiAwareADToolsMooncakeExt

using EpiAwareADTools: primal, _gamma_cdf
using Mooncake: Mooncake

# Lifts the `ChainRulesCore.rrule` and `ChainRulesCore.frule` defined in
# `EpiAwareADToolsChainRulesCoreExt` into Mooncake's rule registry (default mode
# generates both reverse `rrule!!` and forward `frule!!`) for every scalar
# `Real` triple, so callers that pass mixed concrete types (e.g.
# `_gamma_cdf(k + 1, θ, t)`, a `Float32` parameter, or `BigFloat` for
# higher-precision testing) hit the explicit rule rather than falling back to
# Mooncake tracing the function body. The forward `frule` is what closes the
# gap: without it the generated `frule!!` calls `ChainRulesCore.frule`, gets
# `nothing`, and errors with `iterate(::Nothing)`.
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(_gamma_cdf), Real, Real, Real}

# `primal` is a tape-strip returning a non-differentiable primal value. Mooncake
# does not lift the ChainRules `@non_differentiable primal` mark automatically,
# so without an explicit rule it traces the identity and can propagate a
# gradient a caller intends to cut. `@zero_derivative` (no mode argument: covers
# both ForwardMode and ReverseMode) registers the primitive and generates a zero
# `frule!!` and a zero `rrule!!`, keeping the strip off the AD path on both
# Mooncake modes.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(primal), Real}

end
