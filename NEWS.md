## Unreleased

Added `logsumexp_stream`: a shared, differentiable streaming log-sum-exp
accumulator over an unbounded discrete support (`k = 0, 1, 2, …`). It
accumulates with the classic running-maximum/rescale identity, incrementally
per term, and stops only once the running total has left `min_stable_terms`
CONSECUTIVE further terms unchanged within `atol` — not at the first
negligible term, which would silently truncate a heavy tail that dips low
and then recovers. By default it raises a descriptive `error` (never a
`@warn`/`@info`, which would break Mooncake's whole-function transform even
on an unreached branch) if `max_terms` is reached without stabilising;
`strict = false` returns the partial result with `converged = false`
instead. Plain generic Julia control flow with no non-differentiable
primitive, so it needs no bespoke per-backend rule: every supported AD
backend (ForwardDiff, ReverseDiff, Enzyme, Mooncake, ChainRulesCore)
differentiates straight through it (closes #39).

This file tracks notes for major releases and significant milestones;
GitHub Releases (auto-generated from merged PRs) cover every release in
between.
