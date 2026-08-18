@doc raw"""
AD-safe Student-t CDF ``F_\nu(x)``, evaluated through [`_beta_cdf`](@ref).

The t CDF is the regularised incomplete beta at a transformed argument,

```math
F_\nu(x) = \tfrac{1}{2} I_{\nu/(\nu + x^2)}(\tfrac{\nu}{2}, \tfrac{1}{2})
```

for ``x \le 0``, and ``1 - F_\nu(-x)`` for ``x > 0``. Composing over `_beta_cdf`
gives the t that function's per-backend AD coverage, including the
``\nu``-partial `SpecialFunctions.beta_inc` leaves unimplemented. Whichever tail
is the small one is computed directly, so both keep full relative accuracy down
to the point where the value itself underflows.

At ``x = 0`` the argument ``\nu/(\nu + x^2)`` reaches 1, where the incomplete
beta's x-partial diverges and the chain rule forms `0 * Inf`. The value there is
``1/2`` for every ``\nu``, so that case returns the closed form plus the density
at zero times `x`, which carries the x-derivative through a dual.
"""
function _t_cdf(ν::Real, x::Real)
    # `primal`, because ForwardDiff's `iszero` on a `Dual` compares the partials
    # as well as the value, so a seeded zero tests unequal to `0`.
    if iszero(primal(x))
        return one(float(ν * x)) / 2 + x * _t_pdf_at_zero(ν)
    end
    half = _beta_cdf(ν / 2, one(ν) / 2, ν / (ν + x^2)) / 2
    return x < 0 ? half : one(half) - half
end

# Γ((ν+1)/2) / (√(νπ) Γ(ν/2)), through `loggamma` so it differentiates in ν.
function _t_pdf_at_zero(ν::Real)
    return exp(loggamma((ν + 1) / 2) - loggamma(ν / 2)) / sqrt(ν * π)
end

# `Distributions` gives `μ + σ * TDist(ν)` no named type, so the hooks dispatch
# on this alias.
const _LocationScaleT = Distributions.LocationScale{<:Real, Continuous, <:TDist}
