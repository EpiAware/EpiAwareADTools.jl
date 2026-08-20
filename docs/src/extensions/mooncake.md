# [ChainRulesCore + Mooncake extension](@id ext-mooncake)

`EpiAwareADToolsMooncakeExt` loads when `ChainRulesCore` and `Mooncake` are both loaded alongside `EpiAwareADTools`.
Mooncake depends on `ChainRulesCore` today, so in practice loading Mooncake is enough, but the rules this extension lifts are defined by the [ChainRulesCore extension](@ref ext-chain-rules-core) and that extension fires on `ChainRulesCore`.
Naming both triggers keeps the two in step if Mooncake ever drops the dependency.

## What it registers

Three lifts of the ChainRules rules into Mooncake's rule registry, one per internal CDF primitive:

```julia
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(_gamma_cdf), Real, Real, Real,
}
```

and the same for `_gamma_logccdf` and `_beta_cdf`.
The default mode generates both an `rrule!!` and an `frule!!`, so forward and reverse Mooncake are covered by one registration.
The signatures are abstract `Real` triples rather than concrete floats, so a call that mixes types, such as `_gamma_cdf(k + 1, θ, t)` with a `Float32` parameter or a `BigFloat` used for a higher-precision check, still hits the explicit rule instead of falling back to Mooncake tracing the function body.

Two zero-derivative registrations:

```julia
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{typeof(primal), Real}
Mooncake.@zero_derivative Mooncake.DefaultCtx Tuple{NonDifferentiable, Vararg}
```

The first keeps the [tape-strip](@ref tape-strip) off the AD path.
The second does the same for every instance of the [`nondifferentiable`](@ref nondifferentiable) wrapper.
The bare, unparametrised pattern means one registration covers any wrapped function, a closure included, whatever its own type.
Neither macro takes a mode argument, so both forward and reverse mode get a zero rule.

## What fails without it

Mooncake does not lift the ChainRules `@non_differentiable primal` mark automatically.
Without the `@zero_derivative` registration it traces `primal` as the identity and can propagate a gradient the caller meant to cut, silently.

For the CDF primitives, an unloaded extension leaves Mooncake tracing into `gamma_inc` and `beta_inc`.
Reverse mode is left without the shape partial that `SpecialFunctions` marks `@not_implemented`.
Forward mode fails harder: the generated `frule!!` calls `ChainRulesCore.frule`, gets `nothing` for an undefined rule, and errors with `iterate(::Nothing)`.

Wrapping a function with `nondifferentiable` and differentiating it under Mooncake also has a consequence worth stating.
A wrapped closure that captures a live differentiated value, rather than receiving it as an argument, has that captured contribution silently zeroed too.
This is the same behaviour as every other supported backend, and it is confirmed directly on both Mooncake modes.

Note that the `xlogy` and `xlog1py` rules are not here.
They live in the separate [ChainRulesCore + LogExpFunctions + Mooncake extension](@ref ext-log-exp-functions-mooncake), which needs `LogExpFunctions` as a third trigger.

## Upstream target

The three lifts are deleted when `SpecialFunctions.jl` carries complete `ChainRule`s for `gamma_inc` ([issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) and `beta_inc`, since the primitives they cover go with them.
The two zero-derivative rules go once a shared cross-backend stop-gradient primitive exists.
