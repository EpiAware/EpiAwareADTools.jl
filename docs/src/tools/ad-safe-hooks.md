# [AD-safe evaluation hooks](@id ad-safe-hooks)

## The problem

The stock `Distributions.jl` evaluators for a `Gamma` are not differentiable in
the distribution's shape and scale.
`cdf(::Gamma)` routes through `SpecialFunctions.gamma_inc`, whose `ChainRule`
leaves the shape partial unimplemented, and `logcdf`/`logccdf` route through
`StatsFuns._gammalogcdf`/`_gammalogccdf`, which have no `Dual` shape method.
A downstream numeric kernel that evaluates a Gamma component's CDF, survival, or
density inside a differentiated integrand therefore breaks under every supported
AD backend.

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
The `Gamma` methods route through the [gamma-CDF derivative](@ref gamma-cdf) so a
Gamma component stays differentiable in its parameters.

```@example ad-safe-hooks
using EpiAwareADTools, Distributions

d = Gamma(2.0, 1.0)
cdf_ad_safe(d, 3.0), logccdf_ad_safe(d, 3.0)
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

## Upstream target

The family exists because the Gamma CDF is not differentiable in its parameters
upstream — the same gap the [gamma-CDF derivative](@ref gamma-cdf) fills
([SpecialFunctions.jl issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)).
The hooks are deleted once a Gamma CDF differentiable in its parameters ships
upstream and wrapper packages can call `cdf`/`logcdf` directly.
