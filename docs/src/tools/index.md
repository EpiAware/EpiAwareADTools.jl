# [Charter and status](@id charter)

EpiAwareADTools is the EpiAware org's shared home for AD-safety machinery and AD
workarounds.
It exists so the same fix is not duplicated across packages, and so each fix has
one documented owner.

Every entry here is a fix we host while we try to fix the underlying problem
upstream.
Each is documented with the upstream package or issue where it ideally belongs
and the condition under which it is deleted.
When an upstream fix lands, the matching entry is removed rather than left to
rot.

## What lives here

| Tool | What it does | Upstream target | Deletion condition |
|---|---|---|---|
| [`primal`](@ref) / [`primal_distribution`](@ref) | Strip an AD wrapper from a scalar or a distribution's parameters, so a non-differentiable hyperparameter stays off the AD path | No single owner; a per-backend "stop gradient" primitive | A shared stop-gradient primitive covering ForwardDiff, ReverseDiff, Enzyme, and Mooncake |
| [`cdf_ad_safe`](@ref), [`logcdf_ad_safe`](@ref), [`ccdf_ad_safe`](@ref), [`logccdf_ad_safe`](@ref), [`pdf_ad_safe`](@ref) | Extension-point wrappers whose `Gamma` methods stay differentiable in shape/scale | `Distributions.jl` Gamma CDF/log-CDF differentiable in its parameters | `cdf(::Gamma)` and `logcdf(::Gamma)` differentiable upstream on the supported backends |
| Gamma-CDF derivative (`_gamma_cdf` and its rules) | Analytic shape/scale/point partials for `P(k, x/θ)` | Differentiable `gamma_inc` in `SpecialFunctions.jl` ([issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) | `SpecialFunctions.gamma_inc` carries a complete `ChainRule` (the shape partial included) |

## What does not live here

The Gauss-Legendre quadrature layer that ConvolvedDistributions.jl uses is out
of scope for now.
It is a candidate future resident if a second package needs it, but it is not an
AD workaround, so it stays where it is used until then.

## How to read each page

Each tool family has its own page under this section.
A page states the problem the tool works around, shows the public surface, and
points at the upstream target so a reader can check whether the workaround is
still needed.
The [Public API](@ref public-api) and
[Internal API](@ref "Internal Documentation") reference pages carry
the full docstrings.
