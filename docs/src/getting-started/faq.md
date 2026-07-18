# [Frequently asked questions](@id faq)

This page answers common questions about EpiAwareADTools.jl.
If your question is not answered here, open a discussion on the [GitHub repository](https://github.com/EpiAware/EpiAwareADTools.jl).

## What is this package for?

It is the EpiAware org's shared home for automatic-differentiation safety machinery.
Rather than each modelling package carrying its own copy of the same AD workaround, the workarounds live here once, each with a documented upstream target and a deletion condition.
See [Charter and status](@ref charter) for the full list and the plan to retire each entry.

## When should I use `cdf_ad_safe` rather than `cdf`?

Use it whenever you evaluate a `Gamma` CDF (or a log-CDF, survival, or density) inside a differentiable computation.
The stock `cdf(::Gamma)` routes through `SpecialFunctions.gamma_inc`, which has no derivative in the shape parameter, so a gradient in the shape errors.
`cdf_ad_safe` routes `Gamma` through an analytic derivative instead:

```@example faq
using EpiAwareADTools, Distributions, ForwardDiff

ForwardDiff.gradient(θ -> cdf_ad_safe(Gamma(θ[1], θ[2]), 3.0), [2.0, 1.0])
```

For any other distribution the hook falls straight through to the stock `Distributions` function, so it is always safe to reach for.

## Which backends are supported?

ForwardDiff, ReverseDiff, Enzyme (forward and reverse), and Mooncake (forward and reverse), plus ChainRulesCore for rule-consuming frameworks.
Each backend's derivative rule ships as a package extension loaded when the backend is present.
The per-backend badges in the [README](https://github.com/EpiAware/EpiAwareADTools.jl#readme) track their status on every CI run.

## What do `primal` and `primal_distribution` do?

They strip an AD wrapper back to its underlying value, so a hyperparameter that should not be differentiated stays off the tape.
`primal` reduces a wrapped scalar; `primal_distribution` rebuilds a distribution from primal parameters:

```@example faq
using EpiAwareADTools, Distributions

primal(3.0), primal_distribution(Gamma(2.0, 1.5))
```

A numeric integration window or a clamp location is a typical use: compute it on primal values so the bound is a non-differentiated constant on every backend.
See [Tape-strip: `primal`](@ref tape-strip) for the backend details.

## Can I add a hook for my own distribution type?

Yes.
The hooks are extension points: add a method of `cdf_ad_safe` (and companions) for your component type in your own package.
The generic fall-through means you only add methods for the types whose stock evaluation is not AD-safe.
See [Adding a workaround](@ref adding-a-tool) for the contract.

## Why does the package exist as a separate package?

So the same fix is not duplicated across ConvolvedDistributions.jl, CensoredDistributions.jl, and other consumers, and so each fix has one documented owner.
When an upstream fix lands, the matching entry is removed here rather than left to rot in several places.

## How do I cite EpiAwareADTools?

See the citation section of the [README](https://github.com/EpiAware/EpiAwareADTools.jl#supporting-and-citing).

## I want to contribute to development

See the [Contributing guide](@ref contributing) and [Developer FAQ](@ref developer-faq) for development-specific questions and guidelines.

## Getting help

Still have questions?

- **Package-specific**: Open a [GitHub Discussion](https://github.com/EpiAware/EpiAwareADTools.jl/discussions)
- **Bug reports**: [GitHub Issues](https://github.com/EpiAware/EpiAwareADTools.jl/issues)
- **General Julia help**: [Julia Discourse](https://discourse.julialang.org/) or [Julia Slack](https://julialang.org/slack/)
