# The AD-safe evaluation hooks. Each is an extension point: the generic method
# falls through to the stock Distributions function, and the `Gamma` methods
# route through the differentiable `_gamma_cdf` so a Gamma component stays
# differentiable in its shape/scale. A wrapper package adds methods for its own
# component types whose stock evaluation is not AD-safe.
#
# Upstream target: the whole family exists because `Distributions.cdf`/`logcdf`
# for `Gamma` route through `SpecialFunctions.gamma_inc` (and StatsFuns'
# `_gammalogcdf`/`_gammalogccdf`), which carry no shape derivative — the same
# gap `_gamma_cdf` fills (SpecialFunctions.jl issue #531). The hooks are deleted
# once a Gamma CDF differentiable in its parameters ships upstream and wrapper
# packages can call `cdf`/`logcdf` directly.

@doc """
AD-safe `logcdf(dist, u)` for use inside differentiable integrands.

`logcdf_ad_safe` is the log-CDF member of the AD-safe hook family. Generic
dispatch falls through to `Distributions.logcdf`. The `Gamma` method routes
through [`_gamma_cdf`](@ref) so its `ChainRulesCore.rrule` is picked up by
reverse-mode AD; without this, the integrand calls `gamma_inc` and breaks under
every supported AD backend.

An extension point: a downstream package adds methods for component types whose
stock `logcdf` is not AD-safe, the same pattern as [`pdf_ad_safe`](@ref).

# Arguments
- `dist`: the distribution whose log CDF is evaluated.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

logcdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
logcdf_ad_safe(dist::UnivariateDistribution, u::Real) = logcdf(dist, u)

function logcdf_ad_safe(dist::Gamma, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return log(_gamma_cdf(shape(dist), scale(dist), u))
end

function logcdf_ad_safe(dist::Beta, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return log(_beta_cdf(dist.α, dist.β, u))
end

@doc """
AD-safe `cdf(dist, u)` companion to [`logcdf_ad_safe`](@ref).

Same dispatch idea: route `Gamma` through [`_gamma_cdf`](@ref) so a CDF
evaluation remains differentiable under reverse-mode AD in its shape/scale. A
downstream numeric kernel that evaluates components through this hook can add a
method for a component type with a non-AD-safe `cdf`.

An extension point: a wrapper package adds methods the same way as
[`pdf_ad_safe`](@ref).

# Arguments
- `dist`: the distribution whose CDF is evaluated.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

cdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
cdf_ad_safe(dist::UnivariateDistribution, u::Real) = cdf(dist, u)

function cdf_ad_safe(dist::Gamma, u::Real)
    return _gamma_cdf(shape(dist), scale(dist), u)
end

function cdf_ad_safe(dist::Beta, u::Real)
    return _beta_cdf(dist.α, dist.β, u)
end

@doc raw"""
AD-safe `logccdf(dist, u)`: the log survival ``\log(1 - F(u))``.

`logccdf_ad_safe` is the log-survival companion to [`logcdf_ad_safe`](@ref).
Generic dispatch falls through to `Distributions.logccdf`; the `Gamma` method
routes through the AD-safe ``F`` so a survival term differentiates w.r.t. the
Gamma shape/scale (the stock `logccdf(::Gamma)` calls `_gammalogccdf`, which has
no `ForwardDiff.Dual` shape method and errors).

An extension point: a downstream package adds methods for its own component
types, the same pattern as [`pdf_ad_safe`](@ref).

# Arguments
- `dist`: the distribution whose log survival is evaluated.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

logccdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
logccdf_ad_safe(dist::UnivariateDistribution, u::Real) = logccdf(dist, u)

function logccdf_ad_safe(dist::Gamma, u::Real)
    u <= 0 && return zero(float(u))
    return log1p(-_gamma_cdf(shape(dist), scale(dist), u))
end

function logccdf_ad_safe(dist::Beta, u::Real)
    u <= 0 && return zero(float(u))
    return log1p(-_beta_cdf(dist.α, dist.β, u))
end

@doc raw"""
AD-safe `ccdf(dist, u)`: the survival ``1 - F(u)``.

`ccdf_ad_safe` is the survival companion to [`cdf_ad_safe`](@ref). Generic
dispatch falls through to `Distributions.ccdf`; the `Gamma` method routes
through the AD-safe ``F`` so the survival differentiates w.r.t. the Gamma
shape/scale.

An extension point: a downstream package adds methods for its own component
types, the same pattern as [`pdf_ad_safe`](@ref).

# Arguments
- `dist`: the distribution whose survival is evaluated.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

ccdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
ccdf_ad_safe(dist::UnivariateDistribution, u::Real) = ccdf(dist, u)

function ccdf_ad_safe(dist::Gamma, u::Real)
    return 1 - _gamma_cdf(shape(dist), scale(dist), u)
end

function ccdf_ad_safe(dist::Beta, u::Real)
    return 1 - _beta_cdf(dist.α, dist.β, u)
end

@doc """
AD-safe `pdf(dist, t)` for a component density inside a differentiable
quadrature.

`pdf_ad_safe` is the density companion to [`cdf_ad_safe`](@ref). Generic
dispatch falls through to `Distributions.pdf`, and a downstream extension adds a
method for a component whose stock `pdf` routes through functions that are not
differentiable under the supported AD backends.

An extension point: a wrapper package hooks it so its modified components stay
differentiable inside the quadrature, the same pattern as [`ccdf_ad_safe`](@ref).

# Arguments
- `dist`: the component distribution whose density is evaluated.
- `t`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

pdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
pdf_ad_safe(dist::UnivariateDistribution, t::Real) = pdf(dist, t)

# The stock `pdf(::Beta)` routes through `StatsFuns.betapdf`, which computes
# `exp(xlogy(α-1, x) + xlog1py(β-1, -x) - logbeta(α, β))`. Enzyme's own rule
# for `LogExpFunctions.xlog1py`'s first argument is wrong (confirmed against a
# ForwardDiff/plain-log reference: returns 1.5 instead of the correct ≈0.807
# for a `Beta(2,1)` density at `x=0.5`) — `xlogy`'s own first-argument
# derivative is fine, only `xlog1py`'s is affected. Routes around both by
# using `log`/`log1p` directly, safe here because the `t <= 0 || t >= 1`
# guard already excludes the `0 * log(0)` edge case `xlogy`/`xlog1py`
# themselves exist to handle.
function pdf_ad_safe(dist::Beta, t::Real)
    (t <= 0 || t >= 1) && return zero(float(t))
    α, β = dist.α, dist.β
    return exp((α - 1) * log(t) + (β - 1) * log1p(-t) - logbeta(α, β))
end
