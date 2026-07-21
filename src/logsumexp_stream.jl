# A shared, differentiable streaming log-sum-exp accumulator over an
# unbounded discrete support (EpiAwareADTools#39, part of the AD/numerics
# epic #35). Every consumer summing a series in log space over k = 0, 1, 2,
# ... currently writes its own stopping rule; a first-negligible-term rule
# silently truncates a heavy tail that dips low for a term or two and then
# recovers. This accumulates with the classic running-max/rescale
# log-sum-exp identity, updated incrementally per term (so the full
# sequence is never materialised), and stops only after a configurable RUN
# of consecutive terms has left the running total unchanged within
# tolerance.
#
# Plain generic Julia control flow (comparisons, `exp`, `log`, `+`, `*`) —
# no non-differentiable primitive is called anywhere, so every supported AD
# backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake, ChainRulesCore)
# differentiates straight through it with no bespoke per-backend rule
# needed, the same way a plain `sum(logpdf.(...))` loop does. No `@warn`/
# `@info` anywhere in the body: those macros lower to try/catch, which
# breaks Mooncake's whole-function IR transform even on an unreached branch
# (see the org's AD pitfalls notes) — non-convergence is signalled by
# `error` (a plain `throw`, safe on every backend) or, opted into via
# `strict = false`, by a `converged = false` field the caller inspects
# after the call returns.

# The three-way branch below (`t == m`, `t > m`, else) exists to sidestep
# one numerical trap: when the running max `m` and the incoming term `t`
# are BOTH `-Inf` (every term seen so far contributes zero mass), the
# general rescale formula computes `exp(m - t) == exp(-Inf - (-Inf))`,
# which is `exp(NaN)`, not `exp(0)`. Catching `t == m` first (true for
# `-Inf == -Inf`, and for any two equal finite terms) always contributes
# `one(s)` directly and never evaluates that subtraction.
function _logsumexp_step(m, s, t)
    if t == m
        return m, s + one(s)
    elseif t > m
        return t, s * exp(m - t) + one(s)
    else
        return m, s + exp(t - m)
    end
end

@doc """
A differentiable streaming log-sum-exp accumulator over an unbounded
discrete support.

`logsumexp_stream(log_term)` computes `log(Σ_{k≥0} exp(log_term(k)))`
without materialising the full term sequence: it accumulates with the
classic running-maximum/rescale log-sum-exp identity, updated
incrementally as each `log_term(k)` arrives for `k = 0, 1, 2, …`. It stops
only once the running total has been unchanged within `atol` for
`min_stable_terms` CONSECUTIVE further terms — not at the first negligible
term, which would silently truncate a heavy tail that dips low for a term
or two and then recovers.

Returns a `NamedTuple` `(value, terms_used, converged)`: `value` is the
accumulated log-sum (differentiable in whatever `log_term` closes over),
`terms_used` is how many terms were consumed, and `converged` is `true`
unless `max_terms` was reached first. When `max_terms` is reached without
stabilising, the default (`strict = true`) raises a descriptive `error`
rather than silently returning a partial sum; pass `strict = false` to
receive the partial result with `converged = false` instead (the function
itself never logs — a `@warn`/`@info` anywhere in this body would break
Mooncake's whole-function transform even on an unreached branch, so a
caller that wants a warning checks `result.converged` after the call
returns and logs it there).

Every supported AD backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake,
ChainRulesCore) differentiates straight through `value`: the accumulator is
plain generic Julia control flow over whatever real (or AD-wrapped) values
`log_term` returns, calling no non-differentiable primitive, so it needs no
bespoke per-backend rule — the same as a plain `sum(logpdf.(...))` loop.

# Arguments
- `log_term`: a function `k::Int -> Real` returning the log of the `k`-th
  term (`k = 0, 1, 2, …`), possibly carrying a live AD wrapper.

# Keyword Arguments
- `atol`: the per-term change below which a term counts as "stable"
  (default `1e-12`).
- `min_stable_terms`: how many CONSECUTIVE further terms must each leave
  the running total unchanged within `atol` before stopping (default `8`).
- `max_terms`: the hard cap on terms consumed (default `10_000`).
- `strict`: when `true` (default), raise an `error` if `max_terms` is
  reached without stabilising; when `false`, return the partial result
  with `converged = false` instead.

# Examples
```@example
using EpiAwareADTools

# Σ_{k≥0} exp(-k), i.e. a geometric series with ratio exp(-1): the exact
# closed form is 1 / (1 - exp(-1)), so log of that is the reference value.
result = logsumexp_stream(k -> -Float64(k))
result.value ≈ log(1 / (1 - exp(-1)))
result.converged
```
"""
function logsumexp_stream(log_term; atol::Real = 1e-12,
        min_stable_terms::Integer = 8, max_terms::Integer = 10_000,
        strict::Bool = true)
    min_stable_terms >= 1 || throw(ArgumentError(
        "min_stable_terms must be >= 1, got $min_stable_terms"))
    max_terms >= 1 || throw(ArgumentError(
        "max_terms must be >= 1, got $max_terms"))

    m = log_term(0)
    s = one(m)
    value = m + log(s)
    terms_used = 1
    stable_run = 0
    converged = false

    k = 1
    while true
        if stable_run >= min_stable_terms
            converged = true
            break
        end
        if terms_used >= max_terms
            converged = false
            break
        end
        t = log_term(k)
        m, s = _logsumexp_step(m, s, t)
        new_value = m + log(s)
        # `new_value == value` first: every term seen so far contributing
        # zero mass leaves both sides at `-Inf`, and `-Inf - (-Inf)` is
        # `NaN`, not `0` — exact equality (true for that case, and for any
        # two identical finite values) sidesteps the subtraction entirely.
        stable = new_value == value || abs(new_value - value) <= atol
        stable_run = stable ? stable_run + 1 : 0
        value = new_value
        terms_used += 1
        k += 1
    end

    if !converged && strict
        error("logsumexp_stream did not stabilise within $max_terms " *
              "term(s): the running total never left $min_stable_terms " *
              "consecutive term(s) unchanged within atol = $atol. The " *
              "partial log-sum-exp at that point was $value. Increase " *
              "max_terms, loosen atol/min_stable_terms, or pass " *
              "strict = false to receive this partial result with " *
              "converged = false instead of an error.")
    end

    return (value = value, terms_used = terms_used, converged = converged)
end
