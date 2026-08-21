# [`xlogy`/`xlog1py` Mooncake rules](@id xlogy)

## The problem

Mooncake has no rule for `LogExpFunctions.xlogy` or `xlog1py`, so it derives
one by differentiating the primal

```julia
xlogy(x, y) = iszero(x) && !isnan(y) ? zero(x * log(y)) : x * log(y)
```

The `iszero(x)` branch returns a constant, so the derived rule reports
`∂/∂x = 0` at `x == 0` where the correct value is `log(y)`.

`Distributions.gammalogpdf` computes `xlogy(shape - 1, x / scale)`, so the
first argument is exactly zero whenever a Gamma log-density is differentiated
at `shape == 1`.
The shape component of the gradient then comes back as `-digamma(1) ≈ 0.5772`
instead of `log(x / scale) - digamma(1)`, in both Mooncake modes.
Nothing errors; the number is simply wrong, and only at that one point.

A shared-hyperparameter model reaches this more often than the exponent
suggests: a population-level draw can land a stratum's reconstructed shape on
exactly `1.0`, which is what
[ComposedDistributions#99](https://github.com/EpiAware/ComposedDistributions.jl/issues/99)
first hit.

## The fix

`EpiAwareADToolsLogExpFunctionsMooncakeExt` registers both functions as
Mooncake primitives on `Base.IEEEFloat` arguments and lifts the rules
`LogExpFunctionsChainRulesCoreExt` already ships:

```julia
Mooncake.@from_chainrules Mooncake.DefaultCtx Tuple{
    typeof(xlogy), Base.IEEEFloat, Base.IEEEFloat}
```

`@from_chainrules` rather than `@from_rrule` is deliberate.
LogExpFunctions supplies an `frule` as well as an `rrule`, and `@from_rrule`
lifts only the reverse direction, leaving Mooncake forward mode deriving the
same wrong zero
([ComposedDistributions#214](https://github.com/EpiAware/ComposedDistributions.jl/issues/214)).

This is narrowly-scoped type piracy on functions this package does not own.
It is hosted here so that consumers share one copy: two packages each defining
it is a duplicate method registration, which Julia 1.12 rejects as method
overwriting during precompilation
([DistributionsInference#73](https://github.com/EpiAware/DistributionsInference.jl/issues/73)).

## What a consumer has to do

The extension's triggers are `ChainRulesCore`, `LogExpFunctions` and
`Mooncake`, so all three must be *loaded modules* in the session, not merely
listed in a `[deps]` section.

- `Mooncake` is loaded by whoever chose the backend, and it brings
  `ChainRulesCore` with it.
- `LogExpFunctions` is usually already there through
  `Distributions` → `StatsFuns` → `LogExpFunctions`, but relying on that is
  relying on someone else's dependency graph.
  A package that needs the rules should load it itself, for effect if not for
  names, alongside `EpiAwareADTools`.
- `EpiAwareADTools` counts too, since an extension of it cannot load before it
  does.
  A test that loads only the triggers gets Mooncake's derived rule and the
  wrong gradient.

`ComposedDistributions` and `DistributionsInference` both do this, and both
keep a `shape == 1` gradient scenario in their AD matrices as the regression
test that the rules still reach them.

## Upstream target

A rule for `xlogy`/`xlog1py` in `Mooncake.jl` itself.
The report
([issue #1241](https://github.com/chalk-lab/Mooncake.jl/issues/1241)) was
withdrawn as bot-filed rather than fixed, so the gap is still open in Mooncake
0.5.46 and the report awaits a re-file.
This extension is deleted once Mooncake registers its own primitives.
