# [SurvivalDistributions extension](@id ext-survival-distributions)

`EpiAwareADToolsSurvivalDistributionsExt` loads when `SurvivalDistributions` is loaded alongside `EpiAwareADTools`.
It is the only extension that adds distribution methods rather than AD rules, so it needs no backend loaded to take effect.
The backends reach it through the [gamma-CDF derivative](@ref gamma-cdf) rules the other extensions register.

## What it registers

Four [AD-safe hook](@ref survival-hooks) methods for `SurvivalDistributions.GeneralizedGamma`:

- [`cdf_ad_safe`](@ref) and [`ccdf_ad_safe`](@ref).
- [`logcdf_ad_safe`](@ref) and [`logccdf_ad_safe`](@ref).

All four go through a small internal helper, `_gg_cdf(d, u) = cdf_ad_safe(d.G, u^d.gamma)`, except `logccdf_ad_safe`, which calls `logccdf_ad_safe(d.G, u^d.gamma)` directly.
A `GeneralizedGamma(σ, ν, γ)` carries an inner `Gamma(ν/γ, σ^γ)`, so routing through the inner Gamma at the transformed point `u^γ` reuses the `Gamma` methods of the hooks, which already differentiate the regularised lower incomplete gamma through `_gamma_cdf`.
The `u^γ` transform and the inner shape and scale are elementary functions of `ν`, `γ` and `σ`, so the gradient flows through all three parameters.
The constructor promotes its parameters into the inner `Gamma{T}`, so a `Dual` or tracked parameter survives into `d.G` and the per-backend rules do the rest.
Each method handles `u <= 0` before touching the inner distribution.

One public `Distributions` method:

```julia
logcdf(d::SD.GeneralizedGamma, t::Real) = logcdf_ad_safe(d, t)
```

`SurvivalDistributions.LogLogistic` gets nothing.
Its `logccdf` is built from `log1p` and `exp`, so it differentiates through the generic elementary fallback on every backend.

## What fails without it

`SurvivalDistributions` defines `logccdf(d, t) = logccdf(d.G, t^γ)`, and the stock `logccdf(::Gamma)` routes through `StatsFuns._gammalogccdf`.
That has no `ForwardDiff.Dual`, no `ReverseDiff.TrackedReal` and no Mooncake method, so any numeric kernel that queries the CDF or survival of a GeneralizedGamma leaf errors under every AD backend.

The `logcdf` method is a separate gap.
`SurvivalDistributions` defines `logccdf` but no `logcdf`, so a bare `logcdf(GeneralizedGamma(θ...), t)` falls through to the generic `logcdf(d, x) = log(cdf(d, x))`, reaches `SurvivalDistributions`' own `cdf(GG, t) = 1 - exp(logccdf(d.G, t^γ))`, and lands back on `_gammalogccdf`.
It is the survival branch, not `_gammalogcdf`, because the whole GeneralizedGamma CDF family is defined from the survival.
Under any backend it strips the `Dual` and throws.
Only `logcdf` is claimed here.
`cdf`, `ccdf` and `logccdf` are owned by `SurvivalDistributions`, and redefining them would be method-overwriting piracy that breaks precompilation, so they are left to the hooks.

!!! warning "The `logcdf` method is additive only while upstream claims no method of its own"
    `SurvivalDistributions = "0.1"` permits an upstream `logcdf(::GeneralizedGamma, ::Real)`, and adding one would be non-breaking for them.
    If that happens, this definition becomes an overwrite, and precompiling the extension fails with "Method overwriting is not permitted during Module precompilation", naming both definitions.
    No test can guard ahead of it: the method table keeps one entry per signature, and the failure lands while the extension precompiles, before any test body runs.
    The precompile error is the signal, and the fix is to delete the method.

## Upstream target

`SurvivalDistributions.jl` itself, which would carry these methods once the Gamma CDF is differentiable in its parameters upstream ([SpecialFunctions.jl issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)).
That is the same deletion condition as the rest of the hook family.
