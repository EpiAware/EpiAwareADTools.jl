# [User-facing opt-out: `nondifferentiable`](@id nondifferentiable)

## The problem

Part of a computation is sometimes structural rather than estimated — a grid
of integration nodes, a clamp location, any fixed hyperparameter that is
*where* to compute rather than *what* to estimate. [`primal`](@ref) and
[`primal_distribution`](@ref) already give this discipline to the package's
own internals: strip an AD wrapper to its underlying value so the quantity
built from it stays off the tape. What is missing is a deliberate,
user-facing entry point that applies the same discipline to a function or
constructor the caller names, so intent is expressed at the call site instead
of threading `primal` through downstream code by hand.

## The fix

`nondifferentiable(f)` returns a callable that strips every argument to its
primal via [`primal`](@ref), calls `f` on the stripped arguments, and strips
the RESULT the same way, so the call contributes exactly zero derivative on
every supported backend regardless of what `f` computes internally:

```@example nondifferentiable
using EpiAwareADTools

window_midpoint(lo, hi) = (lo + hi) / 2
frozen_midpoint = nondifferentiable(window_midpoint)

frozen_midpoint(0.0, 1.0)
```

A struct's own constructor is itself callable, so wrapping it the same way —
`nondifferentiable(QuadratureGrid)` — holds construction out of
differentiation too, once the struct's own type has a `primal` method (the
same pattern `primal_distribution` follows for `UnivariateDistribution`).
There is deliberately no generic reflection-based `primal` fallback for an
arbitrary struct: `isstructtype` is `true` for `Dict`, `Module` and every
concrete function type — a closure, or `typeof(sin)` — as well as a user's
own type, so a blanket fallback over every struct type would silently
mishandle values this package was never asked to touch.

CAUTION — a captured value, not just an explicit argument, is also held
constant: if `f` is a closure over a live differentiated value, that captured
contribution is silently dropped too, consistently across every backend. This
is the correct, deliberate consequence of "everything in this call is a
constant" — never close over a value you still want differentiated.

This machinery is thin. `NonDifferentiable` and its per-backend rules are
documented in full on the [Internal API](@ref "Internal Documentation") page;
`nondifferentiable` itself is the public entry point.

## Upstream target

`nondifferentiable` generalises [`primal`](@ref)'s discipline to an arbitrary
function, so it shares `primal`'s target: no single owner exists for a
cross-backend "hold this constant" primitive. This entry is deleted alongside
`primal`/`primal_distribution` once a shared stop-gradient primitive exists
that marks a value or a function call non-differentiable uniformly across
ForwardDiff, ReverseDiff, Enzyme, and Mooncake.
