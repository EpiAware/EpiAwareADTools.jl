# [Adding a workaround](@id adding-a-tool)

EpiAwareADTools hosts AD-safety fixes while the underlying problem is pursued upstream.
Every entry is temporary by design: it carries a documented upstream target and a deletion condition, and it is removed once that upstream fix lands rather than left to rot.
This page documents the contract a new entry follows and the conventions the existing entries share, using them as worked examples.

## The charter contract

Before adding anything, check it belongs here.
An entry qualifies when all of the following hold:

- **It is a workaround, not a feature.** It stands in for a fix that ideally lives upstream (in `Distributions.jl`, `SpecialFunctions.jl`, an AD backend, or a shared primitive), not new modelling behaviour. The Gauss-Legendre quadrature layer, for example, is a feature and stays in ConvolvedDistributions.jl; see [Charter and status](@ref charter).
- **It has a named upstream target.** Link the package or issue where the fix ideally belongs.
- **It has a deletion condition.** State the observable condition under which the entry is removed (an upstream release, a merged `ChainRule`).
- **More than one package needs it, or will.** The point of a shared home is to stop the same fix being duplicated across ConvolvedDistributions.jl, CensoredDistributions.jl, and others.

Record the entry in the [Charter and status](@ref charter) table with its upstream target and deletion condition when you add it.

## Conventions the entries share

**Extension-point hooks.**
The AD-safe evaluation hooks (`cdf_ad_safe` and companions) are extension points: the generic method falls through to the stock `Distributions` function, and a bespoke method is added only for a type whose stock evaluation is not AD-safe.
A new hook follows the same shape — a generic passthrough plus the narrow method that fixes the problem — so a downstream package can overload it for its own component types without inheriting a hard dependency.

**Per-backend rules live in extensions.**
Backend-specific derivative rules (ForwardDiff `Dual` methods, `ChainRulesCore.rrule`/`frule`, Enzyme and Mooncake glue) live in `ext/`, loaded only when the backend package is present.
The core package stays dependency-light: the backends are `weakdeps`, and `src/` carries only the analytic machinery the rules consume (as `gamma_ad.jl` does for the shared value-and-partials helper).

**Centralised imports.**
Every module-scope `using`/`import` lives in the module file (`src/EpiAwareADTools.jl`); the extensions import the package's own internals from there.
The kit's import-centralisation quality gate enforces this.

**AD-safe by construction.**
Keep non-differentiable hyperparameters off the tape with [`primal`](@ref)/[`primal_distribution`](@ref) rather than `try`/`catch` (Mooncake reverse cannot differentiate through `try`/`catch`), and select methods by dispatch.

## Verifying the new entry

Every entry is proven differentiable across the backend matrix.
Register a gradient scenario in `test/ADFixtures/src/ADFixtures.jl` alongside the existing hooks:

```julia
_push!("my_new_hook Gamma",
    (θ, obs) -> sum(x -> my_new_hook(Gamma(θ[1], θ[2]), x), obs),
    [2.0, 1.0], (Constant(obs),))
```

The AD harness in `test/ad/` then sweeps it across ForwardDiff, ReverseDiff, Enzyme (reverse and forward), and Mooncake (reverse and forward), each checked against a ForwardDiff reference gradient.
Add a unit test under `test/unit/` for the primal (non-AD) behaviour, and a benchmark row under `benchmark/src/` if the entry has a hot path worth tracking.

## Checklist

- [ ] Confirm it is a workaround with a named upstream target and a deletion condition
- [ ] Generic passthrough plus the narrow fixing method, dispatched not branched
- [ ] Per-backend rules in `ext/`, backends kept as `weakdeps`; analytic machinery in `src/`
- [ ] All module-scope imports in the module file (import-centralisation gate)
- [ ] Export the public surface; document it in the house style (`@doc` blocks, `# Examples`)
- [ ] A row in the [Charter and status](@ref charter) table
- [ ] A gradient scenario in `test/ADFixtures/` and a unit test under `test/unit/`
- [ ] A benchmark row under `benchmark/src/` if it has a hot path
- [ ] A tool page under `docs/src/tools/` if it is a new family
