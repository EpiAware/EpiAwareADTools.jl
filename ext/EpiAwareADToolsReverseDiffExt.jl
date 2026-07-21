module EpiAwareADToolsReverseDiffExt

import EpiAwareADTools: primal, _gamma_cdf, _beta_cdf
using ReverseDiff: ReverseDiff, @grad_from_chainrules, TrackedReal

# Strip a ReverseDiff `TrackedReal` to its primal value. Reading `.value` off
# the tape entry does not record an operation, so a value stripped this way
# stays a constant — exactly the intended behaviour for a non-differentiable
# hyperparameter.
primal(x::TrackedReal) = primal(ReverseDiff.value(x))

# Lift the `ChainRulesCore.rrule` defined in
# `EpiAwareADToolsChainRulesCoreExt` into ReverseDiff's gradient table. Without
# this, ReverseDiff falls back to forward-mode through `gamma_inc` (no
# `TrackedReal` method, errors) or, depending on the call site, traces through
# the function body — slower than calling our analytical rrule directly even
# when it works. Seven overloads cover every non-trivial Tracked/untracked
# subset of the three arguments — required because `@grad_from_chainrules` is
# signature-specific, not abstract.
@grad_from_chainrules _gamma_cdf(
    k::TrackedReal, θ::TrackedReal, x::TrackedReal)
@grad_from_chainrules _gamma_cdf(k::TrackedReal, θ::TrackedReal, x::Real)
@grad_from_chainrules _gamma_cdf(k::TrackedReal, θ::Real, x::TrackedReal)
@grad_from_chainrules _gamma_cdf(k::Real, θ::TrackedReal, x::TrackedReal)
@grad_from_chainrules _gamma_cdf(k::TrackedReal, θ::Real, x::Real)
@grad_from_chainrules _gamma_cdf(k::Real, θ::TrackedReal, x::Real)
@grad_from_chainrules _gamma_cdf(k::Real, θ::Real, x::TrackedReal)

# Same lift for `_beta_cdf(α, β, x) = I_x(α, β)`, defined in
# `EpiAwareADToolsChainRulesCoreExt`. Without this, ReverseDiff falls back to
# tracing `beta_inc` directly (no `TrackedReal` method, errors).
@grad_from_chainrules _beta_cdf(
    α::TrackedReal, β::TrackedReal, x::TrackedReal)
@grad_from_chainrules _beta_cdf(α::TrackedReal, β::TrackedReal, x::Real)
@grad_from_chainrules _beta_cdf(α::TrackedReal, β::Real, x::TrackedReal)
@grad_from_chainrules _beta_cdf(α::Real, β::TrackedReal, x::TrackedReal)
@grad_from_chainrules _beta_cdf(α::TrackedReal, β::Real, x::Real)
@grad_from_chainrules _beta_cdf(α::Real, β::TrackedReal, x::Real)
@grad_from_chainrules _beta_cdf(α::Real, β::Real, x::TrackedReal)

end
