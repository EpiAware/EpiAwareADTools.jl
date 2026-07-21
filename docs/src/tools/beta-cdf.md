# [Beta-CDF derivative](@id beta-cdf)

## The problem

The regularised incomplete beta `I_x(α, β)` is the Beta CDF, and
`SpecialFunctions.beta_inc` computes it accurately across every regime.
Its `ChainRule`, though, leaves the partials with respect to the shape
parameters `α` and `β` unimplemented.
A Beta CDF differentiated in its shape therefore has no derivative on any
ChainRules-based backend, and the forward-mode `Dual` and Enzyme paths hit the
same wall — the `beta_inc` analogue of the [Gamma-CDF derivative](@ref
gamma-cdf) gap.

This also blocks any distribution whose CDF routes through `beta_inc`, not
just `Beta` itself — Student-t and LogLogistic among them.

## The fix

`_beta_cdf(α, β, x)` evaluates `I_x(α, β)` on the primal path through
`beta_inc`, and the extensions supply the derivative analytically:

- `_rib_value_and_partials` computes the missing shape partials by term-by-term
  differentiation of the continued-fraction form Boik & Robinson-Cox (1998)
  derive for `I_x(p, q)`, evaluated with the standard modified Lentz-style
  recurrence, and ported from the reference C implementation in Caner
  Türkmen's [betaincder](https://github.com/canerturkmen/betaincder).
- `_beta_cdf_value_and_partials` returns the primal and the `(dα, dβ, dx)`
  partials from one helper, applying the reflection symmetry
  `I_x(α,β) = 1 - I_{1-x}(β,α)` when `x > α/(α+β)` (the continued fraction is
  only valid on the other side), so the ChainRules rule, the ForwardDiff
  `Dual` methods, and the Enzyme rule share the same formulas.
- `EpiAwareADToolsChainRulesCoreExt` defines the reverse-mode `rrule` and
  forward-mode `frule`; `EpiAwareADToolsReverseDiffExt` and
  `EpiAwareADToolsMooncakeExt` lift these into their backends;
  `EpiAwareADToolsForwardDiffExt` adds `Dual` methods directly; and
  `EpiAwareADToolsEnzymeExt` adds a direct Enzyme rule.

`ad_safe.jl`'s `pdf_ad_safe(::Beta)` override is a separate, narrower fix in
the same family: it routes around a confirmed-wrong Enzyme rule for
`LogExpFunctions.xlog1py`'s first argument (the stock `pdf(::Beta)` path) by
computing the density directly from `log`/`log1p`, rather than reaching for
`_beta_cdf`.

This machinery is internal.
Consumers reach it through the [AD-safe hooks](@ref ad-safe-hooks); the
[Internal API](@ref "Internal Documentation") page carries the full
docstrings.

## Upstream target

The whole family stands in for a differentiable `beta_inc`.
There is no tracking issue open against `SpecialFunctions.jl` for the
shape-parameter partials at the time of writing (unlike `gamma_inc`'s
[issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)).
Once `beta_inc` carries a complete `ChainRule`, `_beta_cdf` and its rules are
deleted and the hooks route through the stock CDF.
