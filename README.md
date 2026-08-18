# EpiAwareADTools <img src="docs/src/assets/logo.svg" width="150" alt="EpiAwareADTools logo" align="right">

<!-- badges:start -->
| **Documentation** | **Build Status** | **Code Quality** | **License & DOI** | **Downloads** |
|:-----------------:|:----------------:|:----------------:|:-----------------:|:-------------:|
| [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://epiawareadtools.epiaware.org/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://epiawareadtools.epiaware.org/dev/) | [![Test](https://github.com/EpiAware/EpiAwareADTools.jl/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/EpiAware/EpiAwareADTools.jl/actions/workflows/test.yaml) [![codecov](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg)](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl) [![AD](https://github.com/EpiAware/EpiAwareADTools.jl/actions/workflows/ad.yaml/badge.svg?branch=main)](https://github.com/EpiAware/EpiAwareADTools.jl/actions/workflows/ad.yaml) | [![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl) [![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl) [![JET](https://img.shields.io/badge/%E2%9C%88%EF%B8%8F%20tested%20with%20-%20JET.jl%20-%20red)](https://github.com/aviatesk/JET.jl) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) | [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FEpiAwareADTools&query=total_requests&label=Downloads)](https://juliapkgstats.com/pkg/EpiAwareADTools) [![Downloads](https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Fmonthly_downloads%2FEpiAwareADTools&query=total_requests&suffix=%2Fmonth&label=Downloads)](https://juliapkgstats.com/pkg/EpiAwareADTools) |

| ForwardDiff | ReverseDiff (tape) | ReverseDiff (compiled) | Enzyme forward | Enzyme reverse | Mooncake reverse | Mooncake forward |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| [![cov ForwardDiff](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-forwarddiff)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-forwarddiff) | [![cov ReverseDiff](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-reversediff)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-reversediff) | [![cov ReverseDiff compiled](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-reversediff-compiled)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-reversediff-compiled) | [![cov Enzyme forward](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-enzyme-forward)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-enzyme-forward) | [![cov Enzyme reverse](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-enzyme-reverse)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-enzyme-reverse) | [![cov Mooncake reverse](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-mooncake-reverse)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-mooncake-reverse) | [![cov Mooncake forward](https://codecov.io/gh/EpiAware/EpiAwareADTools.jl/graph/badge.svg?flag=ad-mooncake-forward)](https://app.codecov.io/gh/EpiAware/EpiAwareADTools.jl?flags%5B0%5D=ad-mooncake-forward) |
<!-- badges:end -->

Automatic-differentiation safety machinery for the EpiAware modelling stack.

## Why EpiAwareADTools?

EpiAwareADTools is the EpiAware org's shared home for AD-safety machinery and AD
workarounds.
It is deliberately framed as fixes we host while we try to fix things upstream:
every entry is documented with the upstream package or issue where it ideally
belongs, and each is deleted once that upstream fix lands.

Three families make up the current surface.

- The tape-strip pair `primal` and `primal_distribution` reduce an AD-wrapped
  scalar or distribution to its underlying primal, keeping a non-differentiable
  hyperparameter (an integration window, a clamp location) off the AD path on
  every backend.
- The AD-safe evaluation hooks (`cdf_ad_safe`, `logcdf_ad_safe`,
  `ccdf_ad_safe`, `logccdf_ad_safe`, and `pdf_ad_safe`) let a wrapper package
  overload CDF evaluation for its own component types, backed by analytic
  `Gamma`, `Beta` and Student-t CDF derivatives that `SpecialFunctions` leaves
  unimplemented.
- Correct upstream `ChainRulesCore` rules lifted into a backend that lacks
  them, currently `LogExpFunctions.xlogy`/`xlog1py` under Mooncake, which
  otherwise returns a wrong shape-gradient for any Gamma log-density
  differentiated at `shape == 1`.

Per-backend behaviour for ForwardDiff, ReverseDiff, Enzyme, Mooncake, and
ChainRulesCore is supplied by package extensions loaded when each backend is
present.

## Getting started

See the [documentation](https://epiawareadtools.epiaware.org/stable/) for a
full walkthrough.

```julia
using EpiAwareADTools, Distributions

# AD-safe Gamma CDF, differentiable in shape/scale on every supported backend.
cdf_ad_safe(Gamma(2.0, 1.0), 3.0)

# Strip an AD wrapper back to its primal value.
primal(3.0)
```

## Related packages

- [ConvolvedDistributions.jl](https://convolveddistributions.epiaware.org/dev/), [ComposedDistributions.jl](https://composeddistributions.epiaware.org/dev/), [ModifiedDistributions.jl](https://modifieddistributions.epiaware.org/dev/), [LoweredDistributions.jl](https://lowereddistributions.epiaware.org/dev/) and [CensoredDistributions.jl](https://censoreddistributions.epiaware.org/stable/) import these AD-safe hooks in their own source and overload them for their component types, so their densities differentiate on every supported backend.
- [DistributionsInference.jl](https://github.com/EpiAware/DistributionsInference.jl) is the emerging fit-protocol layer across those packages, where the AD-safety this package provides is what makes gradient-based fitting work.

## Where to learn more

- Want to get started running code? Check out the [Getting started documentation](https://epiawareadtools.epiaware.org/stable/getting-started/).
- Want to understand the API? Check out our [API reference](https://epiawareadtools.epiaware.org/stable/lib/public).
- Want to contribute to `EpiAwareADTools`? Check the [open issues](https://github.com/EpiAware/EpiAwareADTools.jl/issues) and the Contributing section below.
- Want to see our code? Check out our [GitHub Repository](https://github.com/EpiAware/EpiAwareADTools.jl).

## Getting help

For usage questions, ask on the [Julia Discourse](https://discourse.julialang.org)
(the SciML or usage categories) or the [epinowcast community forum](https://community.epinowcast.org),
our home for epidemiological modelling questions.
Please use [GitHub issues](https://github.com/EpiAware/EpiAwareADTools.jl/issues)
for bug reports and feature requests only.

<!-- standard-sections:start -->
<!-- MANAGED by EpiAwarePackageTools.scaffold — do not edit between the
     markers. These standard sections are re-rendered on every update;
     edit the package-owned sections outside them, or CITATION.cff. -->

## Part of the EpiAware ecosystem

EpiAwareADTools is part of [EpiAware](https://epiaware.org), a set of composable tools for infectious disease modelling. See the [other packages](https://github.com/EpiAware) in the ecosystem.

## Contributing

We welcome contributions and new contributors! Please open an issue or pull request on [GitHub](https://github.com/EpiAware/EpiAwareADTools.jl). This package follows [ColPrac](https://github.com/SciML/ColPrac) and is formatted with [Runic](https://github.com/fredrikekre/Runic.jl).

## How to cite

If you use EpiAwareADTools in your work, please cite it. Citation metadata lives in [`CITATION.cff`](https://github.com/EpiAware/EpiAwareADTools.jl/blob/main/CITATION.cff), which GitHub renders as a "Cite this repository" button on the repository page.

## Code of conduct

Please note that the EpiAwareADTools project is released with a [Contributor Code of Conduct](https://github.com/EpiAware/.github/blob/main/CODE_OF_CONDUCT.md). By contributing, you agree to abide by its terms.
<!-- standard-sections:end -->
