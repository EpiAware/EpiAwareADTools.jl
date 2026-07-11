# [Gamma-CDF derivative](@id gamma-cdf)

## The problem

The regularised lower incomplete gamma `P(a, z)` is the Gamma CDF, and
`SpecialFunctions.gamma_inc` computes it accurately across every regime.
Its `ChainRule`, though, leaves the partial with respect to the shape parameter
`a` as `@not_implemented`.
A Gamma CDF differentiated in its shape therefore has no derivative on any
ChainRules-based backend, and the forward-mode `Dual` and Enzyme paths hit the
same wall.

## The fix

`_gamma_cdf(k, θ, x)` evaluates `P(k, x/θ)` on the primal path through
`gamma_inc`, and the extensions supply the derivative analytically:

- `_grad_p_a_series` computes the missing shape partial by term-by-term
  differentiation of the Tricomi series, following Moore (1982), Algorithm AS
  187 — the same construction Stan (`grad_reg_inc_gamma`) and JAX
  (`igamma_grad_a`) use.
- `_gamma_cdf_value_and_partials` returns the primal and the `(dk, dθ, dx)`
  partials from one helper, so the ChainRules rule, the ForwardDiff `Dual`
  methods, and the Enzyme rule share the same formulas.
- `EpiAwareADToolsChainRulesCoreExt` defines the reverse-mode `rrule` and
  forward-mode `frule`; `EpiAwareADToolsReverseDiffExt` and
  `EpiAwareADToolsMooncakeExt` lift these into their backends;
  `EpiAwareADToolsForwardDiffExt` adds `Dual` methods directly; and
  `EpiAwareADToolsEnzymeExt` adds a direct Enzyme rule.

The Enzyme extension also carries a rule for `SpecialFunctions.gamma`, whose own
Enzyme lowering is wrong by a factor of `Γ(x)` (an upstream Enzyme bug); the
gamma density in `_gamma_cdf_value_and_partials` needs it.

This machinery is internal.
Consumers reach it through the [AD-safe hooks](@ref ad-safe-hooks); the
[Internal API](@ref "Internal Documentation") page carries the full docstrings.

## Upstream target

The whole family stands in for a differentiable `gamma_inc`.
[SpecialFunctions.jl issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)
tracks the missing shape derivative.
Once `gamma_inc` carries a complete `ChainRule`, `_gamma_cdf` and its rules are
deleted and the hooks route through the stock CDF.
