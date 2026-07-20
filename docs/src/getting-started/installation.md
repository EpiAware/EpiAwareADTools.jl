# [Installation](@id installation)

`EpiAwareADTools` is registered in the Julia General Registry:

```julia
using Pkg
Pkg.add("EpiAwareADTools")
```

Load it alongside Distributions.jl:

```julia
using EpiAwareADTools, Distributions
```

The tape-strip helpers (`primal`, `primal_distribution`) and the AD-safe hooks (`cdf_ad_safe` and companions) work on primal values with no extra dependency.
The per-backend derivative rules live in package extensions, loaded automatically when you load a backend:

```julia
using ForwardDiff  # or ReverseDiff, Enzyme, Mooncake
```

Each backend package activates the matching extension (`EpiAwareADToolsForwardDiffExt` and so on), which supplies the derivative that keeps a `Gamma` CDF differentiable in its shape and scale.

The [Getting started](@ref getting-started) overview tours the hooks with worked examples, and the [Charter and status](@ref charter) page explains why each entry is here and when it gets deleted.
