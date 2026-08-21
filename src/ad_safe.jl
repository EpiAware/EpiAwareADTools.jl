# The AD-safe evaluation hooks. Each is an extension point: the generic method
# falls through to the stock Distributions function, and the `Gamma` methods
# route through the differentiable `_gamma_cdf` so a Gamma component stays
# differentiable in its shape/scale. A wrapper package adds methods for its own
# component types whose stock evaluation is not AD-safe.
#
# The generic method carries no type bound on `dist`. A leaf that implements
# the univariate interface by adding methods to the `Distributions` generic
# functions, without subtyping `UnivariateDistribution`, is evaluated the same
# way. The bound is dropped rather than replaced by a `hasmethod`/`applicable`
# gate: the fallback body is exactly the generic call, so a type that does not
# implement it already fails with a `MethodError` naming the missing method
# (`cdf(::Foo, ::Float64)`), which is the message a gate would have to
# reproduce.
#
# Upstream target: the whole family exists because `Distributions.cdf`/`logcdf`
# for `Gamma` route through `SpecialFunctions.gamma_inc` (and StatsFuns'
# `_gammalogcdf`/`_gammalogccdf`), which carry no shape derivative — the same
# gap `_gamma_cdf` fills (SpecialFunctions.jl issue #531). The hooks are deleted
# once a Gamma CDF differentiable in its parameters ships upstream and wrapper
# packages can call `cdf`/`logcdf` directly.
#
# The `TDist` methods (and those for `TLocationScale`, a t given a location
# and scale) are the same story one composition further out: a Student-t CDF
# is a regularised incomplete beta, so `Distributions.logcdf(::TDist)` reaches
# `beta_inc` through `StatsFuns.tdistlogcdf` and breaks the same way. They
# route through `_t_cdf` and its companions, which compose over
# `_beta_cdf`. `tdistlogcdf` is typed `(ν::T, x::T)`, so it promotes an
# untouched degrees of freedom to the AD type: the break lands even when
# only the location and scale are differentiated.
#
# The `LogNormal`/`Weibull` methods are a narrower case: their stock
# evaluators are already differentiable in shape/scale everywhere *inside*
# the support, so no analytic replacement is needed. Below the support
# (`u <= 0`), though, both route the fixed `-Inf`/`0` boundary value through
# an expression that still carries the Dual parameters -- `log(max(u, 0))`
# for `LogNormal` (Distributions.jl `lognormal.jl`), `log1mexp(-zval)` with
# `zval = (max(u, 0)/θ)^α = 0` for `Weibull` (`weibull.jl`) -- and both
# produce `0 * (-Inf)` or `0/0` in the chain rule, so a finite primal comes
# back with a `NaN` gradient (ConvolvedDistributions.jl#194). The guards
# below short-circuit to the true (parameter-independent) boundary constant
# instead.

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
- `dist`: the distribution whose log CDF is evaluated. The fallback carries
  no type bound, so a leaf implementing the `Distributions` generic without
  subtyping `UnivariateDistribution` is accepted.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

logcdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
logcdf_ad_safe(dist, u::Real) = logcdf(dist, u)

function logcdf_ad_safe(dist::Gamma, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return log(_gamma_cdf(shape(dist), scale(dist), u))
end

function logcdf_ad_safe(dist::Beta, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return log(_beta_cdf(dist.α, dist.β, u))
end

function logcdf_ad_safe(dist::TDist, u::Real)
    return _t_logcdf(dist.ν, u)
end

function logcdf_ad_safe(dist::TLocationScale, u::Real)
    z = _t_standardise(dist, u)
    primal(dist.σ) > 0 && return _t_logcdf(dist.ρ.ν, z)
    return _t_logccdf(dist.ρ.ν, z)
end

function logcdf_ad_safe(dist::LogNormal, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return logcdf(dist, u)
end

function logcdf_ad_safe(dist::Weibull, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return logcdf(dist, u)
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
- `dist`: the distribution whose CDF is evaluated. The fallback carries no
  type bound, so a leaf implementing the `Distributions` generic without
  subtyping `UnivariateDistribution` is accepted.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

cdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
cdf_ad_safe(dist, u::Real) = cdf(dist, u)

function cdf_ad_safe(dist::Gamma, u::Real)
    return _gamma_cdf(shape(dist), scale(dist), u)
end

function cdf_ad_safe(dist::Beta, u::Real)
    return _beta_cdf(dist.α, dist.β, u)
end

function cdf_ad_safe(dist::TDist, u::Real)
    return _t_cdf(dist.ν, u)
end

function cdf_ad_safe(dist::TLocationScale, u::Real)
    z = _t_standardise(dist, u)
    primal(dist.σ) > 0 && return _t_cdf(dist.ρ.ν, z)
    return _t_ccdf(dist.ρ.ν, z)
end

function cdf_ad_safe(dist::LogNormal, u::Real)
    u <= 0 && return zero(float(u))
    return cdf(dist, u)
end

@doc raw"""
AD-safe `logccdf(dist, u)`: the log survival ``\log(1 - F(u))``.

`logccdf_ad_safe` is the log-survival companion to [`logcdf_ad_safe`](@ref).
Generic dispatch falls through to `Distributions.logccdf`; the `Gamma` method
routes through [`_gamma_logccdf`](@ref), which computes the survival directly
rather than as ``1 - F``, so a survival term differentiates w.r.t. the Gamma
shape/scale (the stock `logccdf(::Gamma)` calls `_gammalogccdf`, which has no
`ForwardDiff.Dual` shape method and errors) *and* stays accurate far into the
right tail, where ``F`` itself has already rounded to `1`.

An extension point: a downstream package adds methods for its own component
types, the same pattern as [`pdf_ad_safe`](@ref).

# Arguments
- `dist`: the distribution whose log survival is evaluated. The fallback
  carries no type bound, so a leaf implementing the `Distributions` generic
  without subtyping `UnivariateDistribution` is accepted.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

logccdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
logccdf_ad_safe(dist, u::Real) = logccdf(dist, u)

function logccdf_ad_safe(dist::Gamma, u::Real)
    u <= 0 && return zero(float(u))
    return _gamma_logccdf(shape(dist), scale(dist), u)
end

function logccdf_ad_safe(dist::Beta, u::Real)
    u <= 0 && return zero(float(u))
    return log1p(-_beta_cdf(dist.α, dist.β, u))
end

function logccdf_ad_safe(dist::TDist, u::Real)
    return _t_logccdf(dist.ν, u)
end

function logccdf_ad_safe(dist::TLocationScale, u::Real)
    z = _t_standardise(dist, u)
    primal(dist.σ) > 0 && return _t_logccdf(dist.ρ.ν, z)
    return _t_logcdf(dist.ρ.ν, z)
end

function logccdf_ad_safe(dist::LogNormal, u::Real)
    u <= 0 && return zero(float(u))
    return logccdf(dist, u)
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
- `dist`: the distribution whose survival is evaluated. The fallback carries
  no type bound, so a leaf implementing the `Distributions` generic without
  subtyping `UnivariateDistribution` is accepted.
- `u`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

ccdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
ccdf_ad_safe(dist, u::Real) = ccdf(dist, u)

function ccdf_ad_safe(dist::Gamma, u::Real)
    return 1 - _gamma_cdf(shape(dist), scale(dist), u)
end

function ccdf_ad_safe(dist::Beta, u::Real)
    return 1 - _beta_cdf(dist.α, dist.β, u)
end

function ccdf_ad_safe(dist::TDist, u::Real)
    return _t_ccdf(dist.ν, u)
end

function ccdf_ad_safe(dist::TLocationScale, u::Real)
    z = _t_standardise(dist, u)
    primal(dist.σ) > 0 && return _t_ccdf(dist.ρ.ν, z)
    return _t_cdf(dist.ρ.ν, z)
end

function ccdf_ad_safe(dist::LogNormal, u::Real)
    u <= 0 && return one(float(u))
    return ccdf(dist, u)
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
- `dist`: the component distribution whose density is evaluated. The fallback
  carries no type bound, so a leaf implementing the `Distributions` generic
  without subtyping `UnivariateDistribution` is accepted.
- `t`: the evaluation point.

# Examples
```@example
using EpiAwareADTools, Distributions

pdf_ad_safe(Gamma(2.0, 1.0), 3.0)
```
"""
pdf_ad_safe(dist, t::Real) = pdf(dist, t)

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

# Stock `pdf(::LogNormal)` resets `x` to `1` and takes `log(zero(x))` at the
# `x <= 0` boundary, then still evaluates `normpdf(μ, σ, -Inf)`: the primal
# is the correct `0`, but the `-Inf` carries through the chain rule as
# `0 * (-Inf)` and the gradient comes back `NaN` (ConvolvedDistributions.jl#194).
function pdf_ad_safe(dist::LogNormal, t::Real)
    t <= 0 && return zero(float(t))
    return pdf(dist, t)
end
