module EpiAwareADToolsLogExpFunctionsMooncakeExt

using LogExpFunctions: xlogy, xlog1py
using Mooncake: Mooncake

# Mooncake has no rule for `xlogy`/`xlog1py`, so it derives one from the primal
#
#     xlogy(x, y) = iszero(x) && !isnan(y) ? zero(x * log(y)) : x * log(y)
#
# whose `iszero(x)` branch returns a constant, giving `∂/∂x = 0` at `x == 0`
# instead of the correct `log(y)`. `Distributions.gammalogpdf` computes
# `xlogy(shape - 1, x / scale)`, so any Gamma log-density differentiated at
# `shape == 1` gets a wrong shape-gradient under Mooncake.
#
# `LogExpFunctionsChainRulesCoreExt` already ships correct `rrule`s AND
# `frule`s, so lift both directions rather than re-deriving the maths. That
# extension fires on ChainRulesCore, which is why ChainRulesCore is a trigger
# here as well as LogExpFunctions and Mooncake: Mooncake hard-depends on it
# today, but the rules being lifted do not. `@from_chainrules` rather than
# `@from_rrule` is what closes the forward-mode half
# (ComposedDistributions#214) — `@from_rrule` alone leaves Mooncake forward
# deriving the same wrong zero.
#
# Deliberate, narrowly-scoped type piracy on functions this package does not
# own, hosted here so ComposedDistributions (#99) and DistributionsInference
# (#73) share one copy instead of each defining a conflicting one — Julia 1.12
# rejects the duplicate registration as method overwriting during
# precompilation. Remove once Mooncake ships its own rule. The upstream report
# chalk-lab/Mooncake.jl#1241 was withdrawn as bot-filed rather than fixed: the
# gap is still there in Mooncake 0.5.45 and the report awaits a re-file.
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(xlogy), Base.IEEEFloat, Base.IEEEFloat,
}
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(xlog1py), Base.IEEEFloat, Base.IEEEFloat,
}

end
