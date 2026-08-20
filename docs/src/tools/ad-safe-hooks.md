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

## [Student-t](@id t-hooks)

A Student-t CDF is the regularised incomplete beta at `ν / (ν + x^2)`, so
`logcdf(::TDist)` reaches `beta_inc` through `StatsFuns.tdistlogcdf` and
inherits the `Beta` problem above.
It bites earlier than the `Gamma` and `Beta` cases, because `truncated`
normalises eagerly: `truncated(TDist(ν), l, u)` calls `logcdf` at construction,
before any density is evaluated, so a truncated t could not be built at all
under AD (EpiAwareADTools#80).
`tdistlogcdf` is typed `(ν::T, x::T)`, so it promotes an untouched degrees of
freedom to the AD type and the break lands even when only a location and scale
are being differentiated.

The `TDist` methods route through the internal `_t_cdf` family, which composes
over the [beta-CDF derivative](@ref beta-cdf) rather than carrying rules of its
own, and there are matching methods for the location-scale wrapper
`μ + σ * TDist(ν)`.

```@example ad-safe-hooks
dt = 0.3 + 1.4 * TDist(5.0)
cdf_ad_safe(dt, 1.0), logccdf_ad_safe(dt, 1.0)
```

Loading `ForwardDiff` additionally claims `Distributions.logcdf`/`logccdf` on
`Dual` arguments for `TDist`, the same way the extension already does for
`Gamma` and `Beta`, so `truncated` builds and a gradient flows straight through
the stock call.
The wrapper needs no methods of its own there: the stock affine `logcdf`
standardises the evaluation point and delegates to the inner t, so a `Dual`
location or scale arrives as a `Dual` point and a `Dual` degrees of freedom as
a `TDist{<:Dual}`.
The other backends never surface a wrapper type to the primal computation, so
they reach the same machinery through the hooks instead.

!!! note "Far tail"
    `logcdf_ad_safe` and `logccdf_ad_safe` on a Student-t always evaluate the smaller of the two tails and never reconstruct it as `1 - F`.
    At `ν = 5` and `x = -1e8` the value agrees with the incomplete beta's own small-argument asymptote to nine significant figures, where the stock evaluator has already lost all but the first.

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
call otherwise falls through to the generic
`logcdf(d, x) = log(cdf(d, x))`, and from there to
`SurvivalDistributions`' own `cdf(GG, t) = 1 - exp(logccdf(d.G, t^γ))` — so it
lands back on the non-differentiable `_gammalogccdf` too.
`cdf`, `ccdf`, and `logccdf` are owned by `SurvivalDistributions` and are left
alone; redefining them would be method-overwriting piracy.

`SurvivalDistributions.LogLogistic` needs no methods: its evaluators are built
from elementary operations and differentiate through the generic fallback.

!!! note "Far right tail"
    `logccdf_ad_safe` on a `Gamma` (and so, transitively, on a `GeneralizedGamma`) routes through `_gamma_logccdf` (see the [Gamma-CDF derivative](@ref gamma-cdf) page), which reads the survival directly from `SpecialFunctions.gamma_inc` rather than reconstructing it as `1 - F`.
    Its *value* therefore tracks the stock `logccdf` at implementation tolerance across the whole domain, including deep into the right tail where `F` itself has already rounded to `1` (EpiAwareADTools#47).
    The *gradient* stays finite and accurate to arbitrary tail depth as well.
    The `x` and `θ` partials reduce to the hazard-type ratio `f/Q` and are formed in log space as `exp(logpdf - logccdf)`, which never underflows.
    The shape partial divides the exact series by `gamma_inc`'s accurately-computed survival while that is at least `√eps` of the working float type, and switches to a corrected asymptotic series beyond, holding a relative error of about `1e-6` or better at every depth in Float64.

## Upstream target

The family exists because the Gamma and Beta CDFs are not differentiable in
their parameters upstream — the same gaps the [gamma-CDF
derivative](@ref gamma-cdf) ([SpecialFunctions.jl issue
#531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) and the
[beta-CDF derivative](@ref beta-cdf) (no tracking issue yet) fill.
The hooks are deleted once a Gamma CDF and a Beta CDF differentiable in their
parameters ship upstream and wrapper packages can call `cdf`/`logcdf`
directly.
