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
| [`nondifferentiable`](@ref nondifferentiable) | User-facing opt-out that holds an arbitrary function (or a struct's constructor) out of differentiation, generalising `primal`'s discipline to code the caller names | Same as `primal`/`primal_distribution`: no single owner for a cross-backend "hold this constant" primitive | Deleted alongside `primal`/`primal_distribution` once a shared stop-gradient primitive exists |
| [`cdf_ad_safe`](@ref), [`logcdf_ad_safe`](@ref), [`ccdf_ad_safe`](@ref), [`logccdf_ad_safe`](@ref), [`pdf_ad_safe`](@ref) | Extension-point wrappers whose `Gamma` and `Beta` methods stay differentiable in shape/scale | `Distributions.jl` Gamma/Beta CDF/log-CDF differentiable in their parameters | `cdf(::Gamma)`/`cdf(::Beta)` and `logcdf(::Gamma)`/`logcdf(::Beta)` differentiable upstream on the supported backends |
| Gamma-CDF derivative (`_gamma_cdf` and its rules) | Analytic shape/scale/point partials for `P(k, x/θ)` | Differentiable `gamma_inc` in `SpecialFunctions.jl` ([issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) | `SpecialFunctions.gamma_inc` carries a complete `ChainRule` (the shape partial included) |
| [Beta-CDF derivative](@ref beta-cdf) (`_beta_cdf` and its rules) | Analytic shape/point partials for `I_x(α, β)`, the `beta_inc` analogue of the Gamma-CDF derivative | Differentiable `beta_inc` in `SpecialFunctions.jl` (no tracking issue yet) | `SpecialFunctions.beta_inc` carries a complete `ChainRule` (the shape partials included) |
| [GeneralizedGamma hook methods](@ref survival-hooks) (`SurvivalDistributions` extension) | Route a `SurvivalDistributions.GeneralizedGamma` through the AD-safe Gamma path, and claim the `logcdf` method the upstream package leaves undefined | `SurvivalDistributions.jl`, once the Gamma CDF is differentiable in its parameters | The hook family is deleted, i.e. `cdf(::Gamma)`/`logcdf(::Gamma)` differentiable upstream |
| [`xlogy`/`xlog1py` Mooncake rules](@ref xlogy) (`LogExpFunctions` + `Mooncake` extension) | Lift the `LogExpFunctions` `rrule`/`frule` into Mooncake, so a Gamma log-density differentiated at `shape == 1` gets `log(x / scale)` rather than the zero Mooncake derives from the primal's `iszero(x)` branch | A rule for `xlogy`/`xlog1py` in `Mooncake.jl`; the report ([issue #1241](https://github.com/chalk-lab/Mooncake.jl/issues/1241)) was withdrawn as bot-filed rather than fixed and awaits a re-file | `Mooncake` registers its own `xlogy`/`xlog1py` primitives |
| [`logsumexp_stream`](@ref logsumexp-stream) | Differentiable, convergence-checked streaming log-sum-exp over an unbounded discrete support, so a heavy tail is never truncated at the first negligible term | No single owner; `LogExpFunctions.jl`'s `logsumexp` sums an already-materialised, finite collection rather than streaming an unbounded series with a convergence guarantee | `LogExpFunctions.jl` (or an equivalent shared numerics package) gains a differentiable streaming accumulator with the same convergence guarantee |
| [`fixed_draw`](@ref) / [`ad_eltype`](@ref reparameterisation) | The reparameterisation-trick complement of the tape-strip pair: pin a draw as a constant realisation the parameters vary against, and resolve the type a parameter-dependent accumulator combined with such a draw should be seeded at | Same as `primal`/`primal_distribution` for `fixed_draw` (it delegates to `primal` directly); no single owner for a cross-backend "differentiated element type" query for `ad_eltype` | Deleted alongside `primal`/`primal_distribution` once a shared stop-gradient primitive exists (`fixed_draw`); once an AD-abstraction layer such as `DifferentiationInterface.jl` exposes a backend-agnostic differentiated-eltype query (`ad_eltype`) |

## How to read each page

Each tool family has its own page under this section.
A page states the problem the tool works around, shows the public surface, and
points at the upstream target so a reader can check whether the workaround is
still needed.
The [Public API](@ref public-api) and
[Internal API](@ref "Internal Documentation") reference pages carry
the full docstrings.
