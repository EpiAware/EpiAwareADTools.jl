# A user-facing, deliberate opt-out from differentiation (EpiAwareADTools#37,
# part of the AD/numerics epic #35). The internal tape-strip pair
# `primal`/`primal_distribution` and the per-backend
# `@non_differentiable`/`inactive`/`@zero_derivative` rules already give
# `primal` itself this discipline; `nondifferentiable` generalises the SAME
# recipe to an arbitrary user-supplied function, written ONCE here rather
# than per user function, so a caller reaches for it deliberately instead of
# threading `primal` through their own code by hand.

@doc """
A callable wrapper holding a function out of differentiation.

`NonDifferentiable(f)` (built via [`nondifferentiable`](@ref); use that, not
this type, as the public entry point) strips every argument to its primal
via [`primal`](@ref) before calling `f`, and also strips `f`'s RESULT the
same way, so the call contributes no derivative on any supported backend
regardless of what `f` itself does internally — see [`nondifferentiable`](@ref)
for the full contract.
"""
struct NonDifferentiable{F}
    f::F
end

function (nd::NonDifferentiable)(args...)
    return primal(nd.f(map(primal, args)...))
end

@doc """
Hold a function out of differentiation: a deliberate, user-facing opt-out.

`nondifferentiable(f)` returns a callable that strips every argument to its
primal via [`primal`](@ref), calls `f` on the stripped arguments, and strips
the RESULT the same way — so the call contributes exactly zero derivative on
every supported backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake,
ChainRulesCore-consuming backends), regardless of what `f` computes
internally. This generalises the discipline [`primal`](@ref) already applies
to itself (the per-backend `@non_differentiable`/`inactive`/`@zero_derivative`
rules) to an arbitrary function the caller names, written once here rather
than threaded by hand through downstream code.

Because differentiation stays the norm and this is an explicit opt-out, `f`'s
result must be something [`primal`](@ref) can strip — a `Real`, a `Tuple` of
such, or a type a `primal` method already covers. Wrapping a function whose
result is not `primal`-strippable raises a `MethodError` naming the missing
`primal` method, a loud failure rather than a silently wrong derivative; add
a `primal` method for that result type (the same pattern
[`primal_distribution`](@ref) follows for `UnivariateDistribution`) to cover
it. A STRUCT's constructor is itself callable, so wrapping it the same way —
`nondifferentiable(QuadratureGrid)` — holds construction out of
differentiation too, once the struct's own type has a `primal` method (there
is deliberately no generic reflection-based `primal` fallback for an
arbitrary struct: `isstructtype` is `true` for `Vector`, `Dict`, `Function`
and `Module` as well as a user's own type, so a blanket fallback over every
struct type would silently mishandle values this package was never asked to
touch).

CAUTION — a captured value, not just an explicit argument, is also held
constant: if `f` is a closure over a live differentiated value (rather than
receiving it as an argument), that captured contribution is silently
dropped too, consistently across every backend (confirmed directly: a
closure capturing a component of the vector being differentiated reports
the SAME reduced gradient under ForwardDiff, ReverseDiff, Enzyme, and
Mooncake alike). This is the correct, deliberate consequence of "everything
in this call is a constant" — never close over a value you still want
differentiated.

# Arguments
- `f`: the function (or callable, including a struct's own constructor) to
  hold out of differentiation.

# Examples
```@example
using EpiAwareADTools

# A structural quantity that should stay fixed while parameters vary during
# optimisation or sampling: the midpoint of a quadrature window is *where*
# to evaluate, not something to estimate, even when `lo`/`hi` themselves
# carry a live AD wrapper elsewhere in the same computation.
window_midpoint(lo, hi) = (lo + hi) / 2
frozen_midpoint = nondifferentiable(window_midpoint)

frozen_midpoint(0.0, 1.0)
```
"""
nondifferentiable(f) = NonDifferentiable(f)
