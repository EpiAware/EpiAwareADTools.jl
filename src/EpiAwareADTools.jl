"""
    EpiAwareADTools

The EpiAware org's shared home for automatic-differentiation safety machinery
and AD workarounds. Every entry is a fix hosted here while the real fix is
pursued upstream, so each is documented with the upstream package or issue it
stands in for and deleted once that lands.

Two families make up the current surface. The tape-strip pair [`primal`](@ref)
and [`primal_distribution`](@ref) reduce an AD-wrapped scalar or distribution to
its underlying primal, keeping a non-differentiable hyperparameter (an
integration window, a clamp location) off the AD path. The AD-safe evaluation
hooks [`cdf_ad_safe`](@ref), [`logcdf_ad_safe`](@ref), [`ccdf_ad_safe`](@ref),
[`logccdf_ad_safe`](@ref), and [`pdf_ad_safe`](@ref) are extension points a
wrapper package overloads for its own component types; their `Gamma` methods
route through an analytic gamma-CDF derivative that stands in for the
differentiability `SpecialFunctions.gamma_inc` leaves unimplemented, and their
`Beta` methods do the same for `SpecialFunctions.beta_inc`'s missing
shape-parameter derivatives.

Per-backend behaviour (ForwardDiff, ReverseDiff, Enzyme, Mooncake,
ChainRulesCore) is supplied by package extensions loaded when each backend is
present.

# Examples
```@example
using EpiAwareADTools, Distributions

# AD-safe Gamma CDF, differentiable in shape/scale on every backend.
cdf_ad_safe(Gamma(2.0, 1.0), 3.0)

# Strip an AD wrapper back to its primal value.
primal(3.0)
```
"""
module EpiAwareADTools

# Functions whose AD-safe companions wrap them, and the distribution
# introspection the tape-strip and gamma methods need. All module-scope
# using/import live in this file (kit #105); the extensions import the
# package's own internals from here.
using Distributions: Distributions, UnivariateDistribution, Gamma, Beta,
                     params, shape, scale, pdf, cdf, logcdf, ccdf, logccdf

using SpecialFunctions: gamma_inc, loggamma, digamma, beta_inc, logbeta

# DocStringExtensions symbols for the @template conventions registered by
# src/docstrings.jl.
using DocStringExtensions: @template, DOCSTRING, EXPORTS, IMPORTS, TYPEDEF,
                           TYPEDFIELDS, TYPEDSIGNATURES

# Register the standard EpiAware docstring conventions before any docstrings
# are defined (see src/docstrings.jl).
include("docstrings.jl")

# The tape-strip pair and the AD-safe evaluation hooks are the sanctioned
# public surface downstream packages build on.
export primal, primal_distribution
export cdf_ad_safe, logcdf_ad_safe, ccdf_ad_safe, logccdf_ad_safe, pdf_ad_safe

# Tape-strip helpers: reduce an AD-wrapped scalar/distribution to its primal.
include("primal.jl")
# Gamma-CDF analytic derivative machinery (internal): the series shape
# partial, the AD-safe `_gamma_cdf`, and the shared value-and-partials helper
# the per-backend extensions consume.
include("gamma_ad.jl")
# Beta-CDF analytic derivative machinery (internal): the continued-fraction
# shape partials, the AD-safe `_beta_cdf`, and the shared value-and-partials
# helper the per-backend extensions consume.
include("beta_ad.jl")
# The AD-safe evaluation hooks wrapping cdf/logcdf/ccdf/logccdf/pdf.
include("ad_safe.jl")

end # module EpiAwareADTools
