# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Benchmark suite definition. Build a BenchmarkTools `BenchmarkGroup` named
# `SUITE`; the managed `run.jl` / `compare.jl` consume it.
#
# The suite benchmarks the package's real hot paths: the five AD-safe
# evaluation hooks (`cdf_ad_safe`, `logcdf_ad_safe`, `ccdf_ad_safe`,
# `logccdf_ad_safe`, `pdf_ad_safe`) on a `Gamma` (the analytic gamma-CDF
# path) and on a `Normal` (the generic fall-through), the internal
# `_gamma_cdf` kernel, and the per-backend gradients of each hook from the
# `test/ADFixtures` registry. Groups follow the CensoredDistributions.jl
# convention: `SUITE[<group>][<variant>][<operation>]`.

using BenchmarkTools
using EpiAwareADTools
using Distributions

const SUITE = BenchmarkGroup()

# Shared evaluation points spanning the bulk of a positive-support Gamma.
const TEST_XS = collect(range(0.5, 12.0, length = 100))

# Include benchmark definitions.
include("src/baseline.jl")
include("src/hooks.jl")
include("src/ad_gradients.jl")
