@doc raw"""
The smaller Student-t tail ``P(T_ν \le -|x|)``, read straight off the
regularised incomplete beta as

```math
P(T_ν \le -|x|) = \tfrac{1}{2} I_{ν/(ν + x^2)}(ν/2, 1/2).
```

Composed over [`_beta_cdf`](@ref) rather than carrying rules of its own, so
every backend that covers `_beta_cdf` — the ChainRulesCore `rrule`/`frule`,
the ReverseDiff and Mooncake lifts of those, the ForwardDiff `Dual` methods,
and the direct Enzyme rule — differentiates straight through this
composition.

The identity is even in `x`, so the same expression serves the lower tail at
a negative `x` and the survival at a positive one. Reading the small tail
directly, rather than reconstructing it as ``1 - F``, is what keeps
[`_t_logcdf`](@ref) accurate deep into the tail: at `ν = 5` and `x = -1e8`
the direct value agrees with the incomplete beta's own small-argument
asymptote to nine significant figures, where the stock evaluator has already
lost all but the first.
"""
function _t_tail(ν::Real, x::Real)
    return _beta_cdf(ν / 2, one(ν) / 2, ν / (ν + x^2)) / 2
end

@doc raw"""
The Student-t density at the origin, ``f_ν(0) = 1 / (\sqrt{ν} B(ν/2, 1/2))``.

Kept in the same beta parameterisation as [`_t_tail`](@ref), and used only by
[`_t_cdf`](@ref)'s `x == 0` guard, which needs the finite x-partial the
incomplete-beta composition cannot supply there.
"""
_t_pdf_at_zero(ν::Real) = exp(-log(ν) / 2 - logbeta(ν / 2, one(ν) / 2))

@doc raw"""
AD-safe Student-t CDF ``F_ν(x)``, composed over [`_beta_cdf`](@ref).

The smaller of the two tails is always the one evaluated: ``I/2`` below zero
and ``1 - I/2`` above it, with `I` the regularised incomplete beta
[`_t_tail`](@ref) returns. Both the branch test and the `x == 0` guard read
[`primal`](@ref) rather than the argument itself, because ForwardDiff's `==`
and `iszero` compare a `Dual`'s partials as well and a seeded zero therefore
tests unequal to `0`.

At `x == 0` the beta argument ``ν/(ν + x^2)`` sits at 1, where `_beta_cdf`'s
x-partial diverges while the inner derivative ``-2νx/(ν + x^2)^2`` is exactly
zero, so the chain rule asks for `0 * Inf`. Since ``F_ν(0) = 1/2`` for every
`ν`, the guard returns that constant plus a term linear in `x` carrying the
true x-partial ``f_ν(0)``: `x`'s primal is zero, so the value is untouched
and the ν-partial stays the correct zero.

# Arguments
- `ν`: degrees of freedom.
- `x`: the evaluation point.
"""
function _t_cdf(ν::Real, x::Real)
    xp = primal(x)
    iszero(xp) && return one(xp) / 2 + x * _t_pdf_at_zero(ν)
    return xp < 0 ? _t_tail(ν, x) : 1 - _t_tail(ν, x)
end

@doc raw"""
AD-safe Student-t survival ``1 - F_ν(x)``, the reflection of
[`_t_cdf`](@ref): the Student-t is symmetric, so the survival at `x` is the
CDF at `-x` and inherits its small-tail accuracy unchanged.
"""
_t_ccdf(ν::Real, x::Real) = _t_cdf(ν, -x)

@doc raw"""
AD-safe Student-t log CDF ``\log F_ν(x)``.

Below zero this is the log of the directly computed small tail, so it stays
finite and accurate arbitrarily deep into the left tail. Above zero the CDF
is at least ``1/2`` and `log1p(-tail)` reads it off the same small tail, so
neither side ever reconstructs a small number as a difference of two large
ones. The `x == 0` guard defers to [`_t_cdf`](@ref) for the reason set out
there.

# Arguments
- `ν`: degrees of freedom.
- `x`: the evaluation point.
"""
function _t_logcdf(ν::Real, x::Real)
    xp = primal(x)
    iszero(xp) && return log(_t_cdf(ν, x))
    xp < 0 && return log(_t_tail(ν, x))
    return log1p(-_t_tail(ν, x))
end

@doc raw"""
AD-safe Student-t log survival ``\log(1 - F_ν(x))``, the reflection of
[`_t_logcdf`](@ref).
"""
_t_logccdf(ν::Real, x::Real) = _t_logcdf(ν, -x)

# `μ + σ * TDist(ν)`, the wrapper an affine reparameterisation of a Student-t
# builds and a truncated-t call site reaches. `LocationScale` is
# Distributions' alias for `AffineDistribution`; pinning the third parameter
# to a `TDist` keeps these hook methods off every other affine distribution,
# whose stock evaluators are left alone.
const TLocationScale = LocationScale{<:Real, Continuous, <:TDist}

# The standardised point `(u - μ)/σ`, mirroring
# `Distributions.cdf(::ContinuousAffineDistribution, ::Real)`. A negative
# scale reflects the distribution, swapping CDF for survival, which each hook
# handles by choosing which of the pair to call on the standardised point.
_t_standardise(dist::TLocationScale, u::Real) = (u - dist.μ) / dist.σ
