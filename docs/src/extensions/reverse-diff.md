# [ReverseDiff extension](@id ext-reverse-diff)

`EpiAwareADToolsReverseDiffExt` loads when `ReverseDiff` is loaded alongside `EpiAwareADTools`.
ReverseDiff depends on `ChainRulesCore`, so loading it also loads the [ChainRulesCore extension](@ref ext-chain-rules-core), whose `rrule`s this extension lifts onto the tape.

## What it registers

A tape-strip method:

```julia
primal(x::TrackedReal) = primal(ReverseDiff.value(x))
```

Reading `.value` off a tape entry records no operation, so a value stripped this way stays a constant.
That is the behaviour a non-differentiable hyperparameter wants.
[`fixed_draw`](@ref) delegates to [`primal`](@ref) and so inherits it.

Twenty-one `@grad_from_chainrules` registrations: seven each for `_gamma_cdf`, `_gamma_logccdf` and `_beta_cdf`, one for every non-trivial subset of tracked and untracked arguments, for example

```julia
@grad_from_chainrules _gamma_cdf(k::TrackedReal, θ::Real, x::Real)
```

The full seven per primitive are needed because `@grad_from_chainrules` is signature-specific rather than abstract, so a mixed call that no registration matches falls through.

## What fails without it

The lifted rules are what put the analytic partials on the tape.
Without them ReverseDiff either falls back to forward mode through `gamma_inc` or `beta_inc`, which have no `TrackedReal` method and so error, or, depending on the call site, traces the function body instead.
Tracing is slower than calling the analytic `rrule` directly even in the cases where it does produce a number, and it still cannot supply the shape partial `SpecialFunctions` leaves `@not_implemented`.

Without the `primal(::TrackedReal)` method, `primal` is the identity on a tracked value.
The value stays on the tape, and a quantity the caller intended as a constant keeps contributing a gradient.

## Upstream target

`SpecialFunctions.jl` carrying complete `ChainRule`s for `gamma_inc` ([issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) and `beta_inc`, at which point the primitives and their lifts are all deleted.
The `primal(::TrackedReal)` method goes with the rest of the tape-strip once a shared cross-backend stop-gradient primitive exists.
