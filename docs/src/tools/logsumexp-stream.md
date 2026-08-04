# [Streaming log-sum-exp: `logsumexp_stream`](@id logsumexp-stream)

## The problem

The package's other shared primitives (the tape-strip pair and the AD-safe
evaluation hooks) all target continuous quadrature over a distribution's
CDF/PDF. There is no shared primitive for the other recurring shape: an
infinite sum in log space over an unbounded discrete support. Every consumer
that needs one currently writes its own stopping rule, and the easy mistake is
stopping at the first negligible term — which silently truncates a heavy tail
that dips low for a term or two and then recovers, biasing the result with no
visible signal.

## The fix

`logsumexp_stream(log_term)` computes `log(Σ_{k≥0} exp(log_term(k)))` without
materialising the full term sequence. It accumulates with the classic running
maximum/rescale log-sum-exp identity, updated incrementally as each
`log_term(k)` arrives, and stops only once the running total has been
unchanged within `atol` for `min_stable_terms` CONSECUTIVE further terms — not
at the first negligible one:

```@example logsumexp-stream
using EpiAwareADTools

# Σ_{k≥0} exp(-k), a geometric series with ratio exp(-1); the exact closed
# form is 1 / (1 - exp(-1)), so log of that is the reference value.
result = logsumexp_stream(k -> -Float64(k))
result.value ≈ log(1 / (1 - exp(-1))), result.converged
```

It returns `(value, terms_used, converged)`. When `max_terms` is reached
without stabilising, the default (`strict = true`) raises a descriptive error
rather than silently returning a partial sum; `strict = false` instead returns
the partial result with `converged = false`.

The accumulator is plain generic Julia control flow — comparisons, `exp`,
`log`, `+`, `*` — over whatever real (or AD-wrapped) values `log_term`
returns, calling no non-differentiable primitive anywhere in the body. Every
supported AD backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake,
ChainRulesCore) differentiates straight through `value` with no bespoke
per-backend rule needed, the same way a plain `sum(logpdf.(...))` loop does.
The full docstring, including the numerical trap the three-way step branch
guards against, lives on the [Public API](@ref public-api) page.

## Upstream target

There is no single upstream owner for a differentiable, convergence-checked
streaming log-sum-exp over an unbounded support. `LogExpFunctions.jl` hosts
the ecosystem's `logsumexp`, but only over an already-materialised, finite
collection — not a term generator with a run-based stopping rule. This entry
is deleted once `LogExpFunctions.jl` (or an equivalent shared numerics
package) gains a differentiable streaming accumulator with the same
convergence guarantee.
