# [AD-safe evaluation hooks](@id ad-safe-hooks)

## The problem

The stock `Distributions.jl` evaluators for a `Gamma` or a `Beta` are not
differentiable in the distribution's shape (and, for `Gamma`, scale).
`cdf(::Gamma)` routes through `SpecialFunctions.gamma_inc` and `cdf(::Beta)`
through `SpecialFunctions.beta_inc`; both leave their shape partials
unimplemented in their `ChainRule`s, and the corresponding `logcdf`/`logccdf`
paths (`StatsFuns._gammalogcdf`/`_gammalogccdf` and the `beta_inc`-routed
`Beta` equivalents) have no `Dual` shape method either.
A downstream numeric kernel that evaluates a Gamma or Beta component's CDF,
survival, or density inside a differentiated integrand therefore breaks under
every supported AD backend.

## The fix

Five hooks give a wrapper package one sanctioned surface to evaluate a
component through:

- [`cdf_ad_safe`](@ref)
- [`logcdf_ad_safe`](@ref)
- [`ccdf_ad_safe`](@ref)
- [`logccdf_ad_safe`](@ref)
- [`pdf_ad_safe`](@ref)

Each is an extension point.
The generic method falls through to the stock `Distributions` function, so a
distribution that already differentiates cleanly is untouched.
The `Gamma` methods route through the [gamma-CDF derivative](@ref gamma-cdf),
and the `Beta` methods through the [beta-CDF derivative](@ref beta-cdf), so
each stays differentiable in its parameters.

```@example ad-safe-hooks
using EpiAwareADTools, Distributions

d = Gamma(2.0, 1.0)
cdf_ad_safe(d, 3.0), logccdf_ad_safe(d, 3.0)

db = Beta(2.0, 1.0)
cdf_ad_safe(db, 0.3), logccdf_ad_safe(db, 0.3)
```

## Extending the hooks

A wrapper package adds a method for its own component type.
For example, a package whose modified density is not AD-safe under a given
backend adds a `pdf_ad_safe` method for its type, and the numeric kernel that
calls `pdf_ad_safe` then differentiates cleanly:

```julia
import EpiAwareADTools: pdf_ad_safe

pdf_ad_safe(d::MyModifiedDist, t::Real) = my_ad_safe_density(d, t)
```

## [Survival distributions](@id survival-hooks)

Loading `SurvivalDistributions.jl` alongside this package adds hook methods for
`SurvivalDistributions.GeneralizedGamma`, supplied by the
`EpiAwareADToolsSurvivalDistributionsExt` extension.

A `GeneralizedGamma(σ, ν, γ)` carries an inner `Gamma(ν/γ, σ^γ)` and defines its
survival as `logccdf(d, t) = logccdf(d.G, t^γ)`, so its CDF family inherits
exactly the `Gamma` problem above: any kernel differentiating through a
GeneralizedGamma leaf reaches `StatsFuns._gammalogccdf` and errors on every
backend.
The extension routes the inner Gamma through [`cdf_ad_safe`](@ref) at the
transformed point `t^γ`.
The transform and the inner shape/scale are elementary, so the gradient flows
through all three parameters.

```@example ad-safe-hooks
using SurvivalDistributions

dg = GeneralizedGamma(1.5, 2.0, 1.3)
cdf_ad_safe(dg, 3.0), logccdf_ad_safe(dg, 3.0)
```

The extension also claims `Distributions.logcdf(::GeneralizedGamma, ::Real)`.
`SurvivalDistributions` defines `logccdf` but no `logcdf`, so a bare `logcdf`
call otherwise falls through to the generic method and evaluates the inner
Gamma's non-differentiable log-CDF.
`cdf`, `ccdf`, and `logccdf` are owned by `SurvivalDistributions` and are left
alone; redefining them would be method-overwriting piracy.

`SurvivalDistributions.LogLogistic` needs no methods: its evaluators are built
from elementary operations and differentiate through the generic fallback.

## Upstream target

The family exists because the Gamma and Beta CDFs are not differentiable in
their parameters upstream — the same gaps the [gamma-CDF
derivative](@ref gamma-cdf) ([SpecialFunctions.jl issue
#531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) and the
[beta-CDF derivative](@ref beta-cdf) (no tracking issue yet) fill.
The hooks are deleted once a Gamma CDF and a Beta CDF differentiable in their
parameters ship upstream and wrapper packages can call `cdf`/`logcdf`
directly.
