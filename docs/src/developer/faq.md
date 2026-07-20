# [Developer FAQ](@id developer-faq)

This page answers common questions for developers and contributors to EpiAwareADTools.jl.

## Development environment

### Q: My code changes aren't reflecting when developing

**A:** Install and use Revise.jl for automatic code reloading:

```julia
using Pkg
Pkg.add("Revise")           # Install once
using Revise                # Load before your package
using EpiAwareADTools        # Now changes reload automatically
```

Better yet, add Revise to your `startup.jl` file as described in
[Using Julia](https://epiaware.org/using-julia) on the EpiAware site.

### Q: I get "Package not found" errors during development

**A:** Ensure you are in the correct environment, and add the local package in dev mode:

```julia
using Pkg
Pkg.activate(".")
Pkg.develop(PackageSpec(path = "."))  # Add local package in dev mode
```

## Testing

### Q: Tests are failing or taking too long

**A:** For development you can skip the quality gates:

```bash
julia --project=test test/runtests.jl skip_quality
```

This runs the core functionality tests without the slower formatting, linting, and Aqua checks.

### Q: How do I run a single test file or a subset of tests?

**A:** Tests are `@testitem`s discovered with [TestItemRunner](https://github.com/julia-vscode/TestItemRunner.jl), so filter by tag or name rather than by path.
The main entry accepts the `skip_quality` and `quality_only` arguments:

```bash
julia --project=test test/runtests.jl quality_only  # only the quality gates
```

For finer control, drive TestItemRunner directly and filter on the item name or tags:

```julia
using TestItemRunner
run_tests("test"; filter = ti -> occursin("hook", ti.name))
run_tests("test"; filter = ti -> :quality in ti.tags)
```

The VS Code Test Explorer lists each `@testitem` individually, so you can run one from the sidebar.

### Q: How do I run the AD gradient tests?

**A:** They live in their own environment under `test/ad/` and are excluded from the main suite:

```bash
task test-ad                             # all six backends
task test-ad-backend TAG=enzyme_reverse  # a single backend
```

Each scenario is checked against a ForwardDiff reference gradient across ForwardDiff, ReverseDiff, Enzyme (reverse and forward), and Mooncake (reverse and forward).
The scenarios differentiate every hook and the internal `_gamma_cdf` with respect to a Gamma's shape and scale.

## Documentation

### Q: How do I build the documentation locally?

**A:** Use the documentation environment:

```bash
# Full build
julia --project=docs docs/make.jl

# Fast build for development (skips notebook processing)
julia --project=docs docs/make.jl --skip-notebooks
```

### Q: How do I update docstrings?

**A:** We use the DocStringExtensions.jl `@template` conventions registered in `src/docstrings.jl`.
Use `@doc "` (not `@doc """`) so the macros expand:

```julia
@doc "
$(TYPEDSIGNATURES)

AD-safe companion to `cdf(dist, u)`.

# See also
- [`logcdf_ad_safe`](@ref): the log-CDF member
"
function cdf_ad_safe(dist, u)
    # implementation
end
```

Reach for `@doc raw"""` only when the docstring carries LaTeX math and no macros.
**Never use `@doc raw"` with DocStringExtensions macros**, as it prevents macro expansion.
Note that the imports live in the module file, not in `docstrings.jl`, to satisfy the kit's import-centralisation gate.

## Code quality

### Q: How do I run code quality checks?

**A:** The quality gates run as part of the test suite, or on their own:

```bash
task test-quality  # Aqua, ExplicitImports, docstring format, doctest, ...
```

### Q: My code doesn't pass formatting checks

**A:** Format the tree, then re-run the check:

```bash
task format           # apply JuliaFormatter to src/test/docs/benchmark
task test-formatting  # verify without modifying files
```

The formatter runs from the isolated `test/formatter` environment, which pins `JuliaFormatter` to an exact version so the check is reproducible across the CI Julia matrix.
Keep that pin in step with the `.pre-commit-config.yaml` JuliaFormatter `rev`, or `test` and `pre-commit` will disagree about formatting.

### Q: How do I check for type stability?

**A:** JET runs from its own isolated environment (its JuliaSyntax pin would otherwise clash with the main test deps):

```bash
task test-jet
```

You can also run JET interactively:

```julia
using JET
@report_package EpiAwareADTools
```

## Performance

### Q: How do I benchmark my changes?

**A:** Install the `benchpkg` CLI once, then run the suite:

```bash
task benchmark-install         # one-time: adds AirspeedVelocity to ~/.julia/bin
task benchmark                 # benchmark the current state
task benchmark-compare         # compare main vs current
task benchmark -- --filter=Hooks   # filter to specific benchmarks
```

For a quick one-off measurement in the REPL:

```julia
using BenchmarkTools, EpiAwareADTools, Distributions
d = Gamma(2.0, 1.0)
@benchmark cdf_ad_safe($d, 3.0)
```

The `AD gradients` group is the interesting one: it times each hook's gradient on every backend, which is where the analytic derivative rules earn their keep.

## Contributing

### Q: How can I contribute to the package?

**A:** See the [Contributing guide](@ref contributing) for setting up the environment, running tests, code style, and submitting pull requests.
To host a new workaround, follow [Adding a workaround](@ref adding-a-tool).

### Q: I found a bug or have a feature request

**A:**
- **Bugs**: File a GitHub issue with a minimal reproducible example
- **Feature requests**: Open a GitHub issue with rationale and use case
- **Questions**: Ask on the [Julia Discourse](https://discourse.julialang.org/)
  or the [epinowcast community forum](https://community.epinowcast.org)

## Troubleshooting

### Q: The documentation build is failing

**A:** Common causes:
- An unresolved cross-reference (`@ref`) or a page missing from `docs/pages.jl`
- An `@example` block that fails to execute
- A missing dependency in `docs/Project.toml`

### Q: I'm getting precompilation errors

**A:**
- Clear the compiled cache: `julia -e 'using Pkg; Pkg.precompile()'`
- Reset an environment: remove its `Manifest.toml` and run `] instantiate`
- Check for version conflicts: `] resolve`

## Getting help

For development-specific questions:

- **Code issues and usage questions**: the
  [Julia Discourse](https://discourse.julialang.org/) or the
  [epinowcast community forum](https://community.epinowcast.org)
- **Bug reports**: [GitHub Issues](https://github.com/EpiAware/EpiAwareADTools.jl/issues)
