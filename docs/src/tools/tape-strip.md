# [Tape-strip: `primal`](@id tape-strip)

## The problem

A numeric routine sometimes needs a value that is a function of the model
parameters but must not carry a gradient.
The usual example is a quadrature window: the endpoint at which an infinite
integration limit is clamped is a function of the component parameters, but it
is a hyperparameter of the quadrature — just *where* to integrate — and it
should not be differentiated.
If live `Dual` or `TrackedReal` parameters flow into the code that picks the
endpoint, the AD backend traces functions it cannot handle (for example
`gamma_inc_inv` for a `Gamma` component under Enzyme) and the differentiation
fails or returns `NaN`.

## The fix

[`primal`](@ref) reduces an AD-wrapped scalar to its underlying value, and
[`primal_distribution`](@ref) rebuilds a distribution from primal parameters.
A quantity computed from primal parameters is a constant as far as AD is
concerned, so it stays off the tape.

```@example tape-strip
using EpiAwareADTools, Distributions

primal(3.0), primal_distribution(Gamma(2.0, 1.5))
```

## Per-backend behaviour

The generic `primal` is the identity on a plain real, so a non-AD call keeps the
value's own type.
The extensions make it a genuine stop-gradient on each backend:

- `EpiAwareADToolsForwardDiffExt` and `EpiAwareADToolsReverseDiffExt` add methods
  that read the underlying value out of a `Dual` or `TrackedReal`.
- `EpiAwareADToolsChainRulesCoreExt` marks `primal` `@non_differentiable`.
- `EpiAwareADToolsEnzymeExt` marks it `EnzymeRules.inactive`.
- `EpiAwareADToolsMooncakeExt` gives it a `@zero_derivative` rule.

## Upstream target

There is no single upstream owner for a cross-backend stop-gradient.
This pair is deleted once a shared primitive exists that marks a value
non-differentiable uniformly across ForwardDiff, ReverseDiff, Enzyme, and
Mooncake.
Until then hosting one sanctioned `primal` here is better than each consumer
package carrying its own underscore-prefixed copy.
