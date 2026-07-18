<!-- PACKAGE-OWNED — your benchmark narrative. scaffold writes this once and
never overwrites it. The managed build splices this file verbatim into the
generated `docs/src/benchmarks.md`, between the page heading and the rendered
`## Performance history` section. ALL benchmark narrative lives here (the
managed skeleton carries none): describe what the suite covers, how to run it,
and how to read the history below. Add your own `## ...` subsections freely. -->

Benchmarks for the AD-safe machinery, reading the analytic gamma-CDF hooks
against the bare `Distributions.jl` functions and timing the per-backend
gradients of each hook.

## Quick start

Install the `benchpkg` CLI once:

```bash
task benchmark-install
# Or: julia -e 'using Pkg; Pkg.add("AirspeedVelocity")'
```

then run the suite:

```bash
# Benchmark current state
task benchmark

# Compare main branch vs current state
task benchmark-compare

# Filter to specific benchmarks
task benchmark -- --filter=Hooks
task benchmark-compare -- --filter="AD gradients"
```

## Benchmark structure

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
  <every test/ADFixtures scenario>/
    ForwardDiff, ReverseDiff (tape), Enzyme forward, Enzyme reverse,
    Mooncake forward, Mooncake reverse
```

## Primal cost and gradient cost

The `Baseline` group times the stock `Distributions.jl` functions each hook
wraps.
On a `Gamma` the hooks route through the analytic gamma-CDF path (`_gamma_cdf`)
rather than `SpecialFunctions.gamma_inc`, so the gap between `Hooks/Gamma` and
`Baseline/Gamma` is the cost of the AD-safe detour on a plain (non-AD) call.
On a `Normal` the generic method falls straight through to Distributions, so
`Hooks/Normal (fall-through)` should sit on top of the baseline with no
measurable overhead.

The `AD gradients` group is the point of the package: it times
`DifferentiationInterface.gradient` for every scenario in `test/ADFixtures`
across the ForwardDiff, ReverseDiff, Enzyme, and Mooncake backends, which is
where the analytic derivative rules earn their keep.

## CI integration

Pull requests benchmark head and base in separate jobs via the [benchmark workflow](https://github.com/EpiAware/EpiAwareADTools.jl/blob/main/.github/workflows/benchmark.yaml) and post a single comparison comment.
Pushes to `main` and tagged releases append to the performance history below.
