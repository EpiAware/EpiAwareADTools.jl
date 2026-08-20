# [ChainRulesCore + LogExpFunctions + Mooncake extension](@id ext-log-exp-functions-mooncake)

`EpiAwareADToolsLogExpFunctionsMooncakeExt` loads when `ChainRulesCore`, `LogExpFunctions` and `Mooncake` are all loaded alongside `EpiAwareADTools`.
All three must be loaded modules in the session, not merely entries in a `[deps]` section.
`Mooncake` brings `ChainRulesCore` with it, and `LogExpFunctions` usually arrives through `Distributions` → `StatsFuns`.
A package that needs these rules should load `LogExpFunctions` itself rather than rely on someone else's dependency graph.

`ChainRulesCore` is a trigger because the rules being lifted are supplied by `LogExpFunctionsChainRulesCoreExt`, which fires on `ChainRulesCore` rather than on Mooncake.

## What it registers

Two Mooncake primitives in `Mooncake.DefaultCtx`, both lifted with `@from_chainrules`:

```julia
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(xlogy), Base.IEEEFloat, Base.IEEEFloat,
}
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(xlog1py), Base.IEEEFloat, Base.IEEEFloat,
}
```

`@from_chainrules` rather than `@from_rrule` is deliberate.
`LogExpFunctions` ships an `frule` as well as an `rrule`, and `@from_rrule` lifts only the reverse direction, leaving Mooncake's forward mode to derive the wrong value.
The signatures are restricted to `Base.IEEEFloat`, so nothing else in `LogExpFunctions` is touched.

This is the only extension that registers rules for functions the package does not own.
It is hosted here so consumers share one copy: two packages each registering the same Mooncake primitive is a duplicate method registration, which Julia 1.12 rejects as method overwriting during precompilation.

## What fails without it

Nothing errors.
The number is simply wrong, at one point.

Mooncake has no rule of its own for `xlogy`, so it differentiates the primal

```julia
xlogy(x, y) = iszero(x) && !isnan(y) ? zero(x * log(y)) : x * log(y)
```

whose `iszero(x)` branch returns a constant.
The derived rule reports `∂/∂x = 0` at `x == 0`, where the correct value is `log(y)`.
`Distributions.gammalogpdf` computes `xlogy(shape - 1, x / scale)`, so a Gamma log-density differentiated at `shape == 1` gets `-digamma(1) ≈ 0.5772` for its shape gradient instead of `log(x / scale) - digamma(1)`, in both Mooncake modes.

A shared-hyperparameter model reaches `shape == 1` more often than the exponent suggests, since a population-level draw can land a stratum's reconstructed shape exactly there.
The [`xlogy`/`xlog1py` Mooncake rules](@ref xlogy) page carries the full account, including the consumer packages that keep a `shape == 1` scenario in their AD matrices as a regression test.

The `[compat]` floor of `LogExpFunctions = "0.3.2"` belongs to this extension.
That is the first release whose ChainRules cover `xlog1py` as well as `xlogy`, and 0.3.0 has no `ChainRulesCore` dependency at all.
An older resolve would register primitives with no rule behind them.

## Upstream target

A rule for `xlogy` and `xlog1py` in `Mooncake.jl` itself.
The report ([issue #1241](https://github.com/chalk-lab/Mooncake.jl/issues/1241)) was withdrawn as bot-filed rather than fixed, so the gap is still open in Mooncake 0.5.46 and the report awaits a re-file.
The extension is deleted once Mooncake registers its own primitives.
