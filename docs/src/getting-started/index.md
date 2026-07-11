# [Getting started](@id getting-started)

`EpiAwareADTools` hosts the EpiAware org's AD-safety machinery in one place.
Two families make up the surface: the tape-strip pair
[`primal`](@ref)/[`primal_distribution`](@ref), and the AD-safe evaluation hooks
[`cdf_ad_safe`](@ref) and companions.
The [Charter and status](@ref charter) page explains why each entry is here and
when it gets deleted; this page is the quickstart.

## Installation

The package is not yet registered.
Add it by URL:

```julia
using Pkg
Pkg.add(url = "https://github.com/EpiAware/EpiAwareADTools.jl")
```

Load it:

```julia
using EpiAwareADTools
```

## AD-safe Gamma evaluation

The hooks evaluate a distribution the way `Distributions.jl` does, but the
`Gamma` methods stay differentiable in the shape and scale.
Load a backend and the matching extension supplies the derivative.

```@example getting-started
using EpiAwareADTools, Distributions

d = Gamma(2.0, 1.0)
cdf_ad_safe(d, 3.0), logccdf_ad_safe(d, 3.0)
```

The gradient of a Gamma CDF in its parameters is available on every supported
backend:

```@example getting-started
using ForwardDiff

ForwardDiff.gradient(θ -> cdf_ad_safe(Gamma(θ[1], θ[2]), 3.0), [2.0, 1.0])
```

The stock `cdf(::Gamma)` has no shape derivative, so this gradient would
otherwise error; see [AD-safe evaluation hooks](@ref ad-safe-hooks).

## Stripping an AD wrapper

[`primal`](@ref) reduces an AD-wrapped scalar to its underlying value, and
[`primal_distribution`](@ref) rebuilds a distribution from primal parameters.
Use them to keep a non-differentiable hyperparameter off the AD path.

```@example getting-started
primal(3.0), primal_distribution(Gamma(2.0, 1.5))
```

See [Tape-strip: `primal`](@ref tape-strip) for the backend details.

## Learning more

- The [Charter and status](@ref charter) page lists every entry, its upstream
  target, and its deletion condition.
- The [Public API](@ref public-api) has the full interface.
- Open an issue or start a discussion on the
  [GitHub repository](https://github.com/EpiAware/EpiAwareADTools.jl).
