module EpiAwareADToolsMooncakeExt

using EpiAwareADTools: primal, _gamma_cdf, _beta_cdf, NonDifferentiable
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

# Same lift for `_beta_cdf(α, β, x) = I_x(α, β)`.
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(_beta_cdf), Real, Real, Real}

# `primal` is a tape-strip returning a non-differentiable primal value. Mooncake
# does not lift the ChainRules `@non_differentiable primal` mark automatically,
# so without an explicit rule it traces the identity and can propagate a
# gradient a caller intends to cut. `@zero_derivative` (no mode argument: covers
# both ForwardMode and ReverseMode) registers the primitive and generates a zero
# `frule!!` and a zero `rrule!!`, keeping the strip off the AD path on both
# Mooncake modes.
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(primal), Real}

# `NonDifferentiable` (EpiAwareADTools#37): the same `@zero_derivative`
# treatment, generalised from the one specific function `primal` to ANY
# instance of the wrapper type via the bare (unparametrised) `Vararg`
# pattern below — one registration covers every user function wrapped with
# `nondifferentiable`, including a closure, regardless of the wrapped
# function's own type. Confirmed directly on both Mooncake modes (forward
# and reverse) and against a closure that captures a live differentiated
# value: the captured contribution is silently zeroed too, the same as
# every other supported backend (see `nondifferentiable`'s docstring).
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{NonDifferentiable, Vararg}

end
