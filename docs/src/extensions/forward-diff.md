# [ForwardDiff extension](@id ext-forward-diff)

`EpiAwareADToolsForwardDiffExt` loads when `ForwardDiff` is loaded alongside `EpiAwareADTools`.
ForwardDiff dispatches on the `Dual` argument type and does not read ChainRules, so this extension adds methods directly rather than lifting the rules the [ChainRulesCore extension](@ref ext-chain-rules-core) defines.

## What it registers

A tape-strip method:

```julia
primal(x::Dual) = primal(value(x))
```

It recurses, so a nested `Dual` from a higher-order tag chain still reduces to the scalar value.
[`fixed_draw`](@ref) delegates to [`primal`](@ref), so it becomes a genuine stop-gradient on this backend through the same method.

Seven methods each for `_gamma_cdf`, `_gamma_logccdf` and `_beta_cdf`, covering every combination of the three arguments in which at least one is a `Dual`.
All of them route to a shared `_impl` helper that reads out the values, calls the matching `_value_and_partials` helper, and rebuilds a `Dual` from the analytic partials and the incoming ones.
`Dual <: Real`, so the seven methods overlap, and the three double-`Dual` methods and the all-`Dual` method are the resolvers for those overlaps.
The `Dual` slots are deliberately left unparametrised.
A shared `{T, V, N}` parametrisation across slots would pin the tags equal, the resolvers would then not dominate the mixed-tag intersections, and `detect_ambiguities` would flag every partial pair.
The tag and partial width are read from the first `Dual` at run time instead.

Two edge cases are unsupported and error inside the helper rather than through ambiguous dispatch: nested `Dual`s, and mixed tags across arguments.
ForwardDiff never asks for either in a single differentiation pass.

Twelve `Distributions` methods, six for `Gamma` and six for `Beta`:

```julia
Distributions.logcdf(d::Gamma{<:Dual}, x::Real) = logcdf_ad_safe(d, x)
Distributions.logcdf(d::Gamma, x::Dual) = logcdf_ad_safe(d, x)
Distributions.logcdf(d::Gamma{<:Dual}, x::Dual) = logcdf_ad_safe(d, x)
```

and the `logccdf` counterparts, then the same six for `Beta`.
Methods are added only for the `Dual` arguments `StatsFuns` cannot handle, so the plain float path is untouched.
The `Gamma{<:Dual}` method catches `Dual` parameters with a constant evaluation point, the `::Dual` evaluation-point method catches a `Dual` bound, and the both-`Dual` method resolves their overlap.

```@example ext-forward-diff
using EpiAwareADTools, Distributions, ForwardDiff

ForwardDiff.derivative(k -> logcdf(Gamma(k, 1.5), 3.0), 2.0)
```

## What fails without it

`StatsFuns._gammalogcdf` has no `Dual` method, and neither does the `beta_inc` path behind `logcdf(::Beta)`.
A `truncated(Gamma; lower)` builds its normaliser eagerly at construction, so constructing one with `Dual` parameters breaks under ForwardDiff before any density is evaluated.
The `logcdf`/`logccdf` methods above are what close that gap, by routing through [`logcdf_ad_safe`](@ref) and [`logccdf_ad_safe`](@ref) and so through the analytic shape and scale partials.

Without the `Dual` methods on the CDF primitives, the [AD-safe hooks](@ref ad-safe-hooks) themselves have nothing differentiable to call, since the generic primitives return a plain float and drop the partials.

Without the `primal(::Dual)` method, `primal` is the identity on a `Dual`, so a strip a caller relied on silently does nothing and the gradient flows on through.

## Upstream target

The same condition as the rest of the family: a `Gamma` and `Beta` CDF differentiable in their parameters upstream, tracked for the gamma side by [SpecialFunctions.jl issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531).
The `primal(::Dual)` method goes with the rest of the tape-strip once a shared cross-backend stop-gradient primitive exists.
