# EpiAwareADTools.jl Benchmarks

Benchmarks for the AD-safe machinery, reading the analytic gamma-CDF hooks
against the bare `Distributions.jl` functions and timing the per-backend
gradients of each hook.

## Quick Start

### One-time Setup

Install the `benchpkg` CLI to your global Julia environment:

```bash
task benchmark-install
# Or: julia -e 'using Pkg; Pkg.add("AirspeedVelocity")'
```

Ensure `~/.julia/bin` is on your PATH.

### Running Benchmarks

```bash
# Benchmark current state
task benchmark

# Compare main branch vs current state
task benchmark-compare

# Filter to specific benchmarks
task benchmark -- --filter=Hooks
task benchmark-compare -- --filter="AD gradients"
```

## Benchmark Structure

```
Baseline/
  Gamma/               (cdf, logcdf, ccdf, logccdf, pdf)

Hooks/
  Gamma/               (cdf_ad_safe, logcdf_ad_safe, ccdf_ad_safe,
                        logccdf_ad_safe, pdf_ad_safe — analytic path)
  Normal (fall-through)/ (cdf_ad_safe, logcdf_ad_safe, pdf_ad_safe —
                        generic method, collapses to Distributions)
  _gamma_cdf/          (scalar, broadcast)

AD gradients/
  <scenario>/          (one leaf per AD backend)
```

The `Baseline` group is the floor: the stock `Distributions.jl` functions each
hook wraps, evaluated over the same points.
The `Hooks/Gamma` rows route through the analytic gamma-CDF path
(`_gamma_cdf`), so the gap to `Baseline/Gamma` is the cost of the AD-safe
detour on a primal call.
The `Hooks/Normal (fall-through)` rows exercise the generic method, which
should sit on top of the baseline with no measurable overhead.

The `AD gradients` group (`benchmark/src/ad_gradients.jl`) times
`DifferentiationInterface.gradient` for every (scenario, backend) pair from the
`test/ADFixtures` path package, which also drives the AD test suite
(`test/ad/runtests.jl`), keeping the two surfaces in lock-step.
Backends cover ForwardDiff, ReverseDiff (tape), Mooncake (reverse and forward)
and Enzyme (reverse and forward).
Each pair is smoke-tested for a finite gradient before registration, so
known-broken combinations are silently omitted and the suite can run
unattended.

## CI Integration

Benchmarks run automatically on PRs via `.github/workflows/benchmark.yaml`:
each of PR head and `main` is benchmarked in its own job and a single
comparison comment is posted (see `benchmark/compare.jl`, which calls the
shared `EpiAwarePackageTools.Benchmarks` harness).
Pushes to `main` and tags additionally record a performance timeline to the
repo's `benchmarks` branch via `.github/workflows/benchmark-history.yaml`,
rendered on the docs' Benchmarks page.

## Direct CLI Usage

```bash
# Run benchmarks
benchpkg --rev=dirty --script=benchmark/benchmarks.jl

# Compare specific revisions
benchpkg --rev=main,dirty --script=benchmark/benchmarks.jl

# View results
benchpkgtable EpiAwareADTools
```
