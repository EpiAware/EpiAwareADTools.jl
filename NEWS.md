## Unreleased

Added `nondifferentiable`: a deliberate, user-facing opt-out from
differentiation. `nondifferentiable(f)` returns a callable that strips every
argument to its primal via `primal`, calls `f`, and strips the result the
same way, so the call contributes exactly zero derivative on every
supported backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake,
ChainRulesCore-consuming backends), regardless of what `f` computes
internally. This generalises the discipline `primal` already applies to
itself — written once here rather than threaded by hand through downstream
code — to an arbitrary function the caller names; a struct's own
constructor is itself callable, so wrapping it the same way holds
construction out of differentiation too, given a `primal` method for that
struct (mirroring `primal_distribution`'s own pattern; there is
deliberately no generic reflection-based `primal` fallback for an arbitrary
struct, since `isstructtype` is `true` for `Dict`, `Function` and
`Module` too, and a blanket fallback over every struct type would silently
mishandle values this package was never asked to touch). Confirmed directly
across all six backend/mode permutations, including the adversarial case
of a closure that captures a live differentiated value rather than
receiving it as an argument: that captured contribution is also silently
dropped, consistently on every backend (closes #37).

`primal` now also strips an `AbstractArray` elementwise, returning a new
container of the same shape, so a vector-valued hyperparameter — issue #37's
own `QuadratureGrid(nodes::Vector{Float64})` example — works both as a
`nondifferentiable` argument and inside a user's own `primal` method. The
accepted set is now `Real`, `Tuple` and `AbstractArray`, nested to any depth;
anything else still raises a `MethodError` naming `primal`.

This file tracks notes for major releases and significant milestones; GitHub
Releases (auto-generated from merged PRs) cover every release in between.
