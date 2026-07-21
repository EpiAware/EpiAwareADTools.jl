@doc raw"""
Continued-fraction coefficients and their `p`/`q`-partials for the
regularised incomplete beta function `I_x(p, q)` — the shape-parameter
derivatives `SpecialFunctions.beta_inc` leaves unimplemented, the `beta_inc`
analogue of [`_grad_p_a_series`](@ref) for `gamma_inc`.

Follows the continued-fraction form Boik & Robinson-Cox (1998) derive for
`I_x(p, q)` and its `p`/`q` partials (their equations for `a_n`, `b_n` and
the corresponding `∂a_n/∂p`, `∂a_n/∂q`, `∂b_n/∂p`, `∂b_n/∂q`), evaluated via
the standard modified Lentz-style two-term recurrence

```math
A_n = A_{n-2} a_n + A_{n-1} b_n, \qquad B_n = B_{n-2} a_n + B_{n-1} b_n,
\qquad I_x(p,q) = K \cdot \lim_{n\to\infty} A_n / B_n
```

with `K = x^p (1-x)^{q-1} / (p B(p,q))`, differentiated term-by-term so
`dA_n`, `dB_n` accumulate alongside `A_n`, `B_n` in the same pass. Valid for
`x ≤ p/(p+q)`; the complementary regime uses the symmetry
`I_x(p,q) = 1 - I_{1-x}(q,p)` (and correspondingly for the partials), applied
in [`_beta_cdf_value_and_partials`](@ref).

# References

Boik, R. J., & Robinson-Cox, J. F. (1998). "Derivatives of the Incomplete
Beta Function." *Journal of Statistical Software*, 3(1), 1-20. The
recurrence structure (coefficients `a_n`/`b_n` and their partials) follows
the reference C implementation in Caner Türkmen's
[betaincder](https://github.com/canerturkmen/betaincder) (MIT licensed),
ported here to Julia with the fixed 100-term default this package's own
test suite validates against the paper's published table.
"""
@inline function _rib_f(x::Real, p::Real, q::Real)
    return q * x / (p * (1 - x))
end

@inline function _rib_a(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    n == 1 && return p * f * (q - 1) / (q * (p + 1))
    F1 = p^2 * f^2 * (n - 1) / q^2
    F2 = (p + q + n - 2) * (p + n - 1) * (q - n) /
         ((p + 2n - 3) * (p + 2n - 2)^2 * (p + 2n - 1))
    return F1 * F2
end

@inline function _rib_b(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    N1 = 2 * (p * f + 2q) * n * (n + p - 1) + p * q * (p - 2 - p * f)
    D1 = q * (p + 2n - 2) * (p + 2n)
    return N1 / D1
end

@inline function _rib_da_dp(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    if n == 1
        return -p * f * (q - 1) / (q * (p + 1)^2)
    end
    p2n3 = p + 2n - 3
    N1 = -(n - 1) * f^2 * p^2 * (q - n) / (q^2 * p2n3^2)
    N2a = (-8 + 8p + 8q) * n^3
    N2b = (16p^2 + (-44 + 20q) * p + 26 - 24q) * n^2
    N2c = (10p^3 + (14q - 46) * p^2 + (-40q + 66) * p - 28 + 24q) * n
    N2d = 2p^4 + (-13 + 3q) * p^3 + (-14q + 30) * p^2
    N2e = (-29 + 19q) * p + 10 - 8q
    D = (p2n3 + 1)^3 * (p2n3 + 2)^2
    return (N2a + N2b + N2c + N2d + N2e) / D * N1
end

@inline function _rib_da_dq(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    n == 1 && return p * f / (q * (p + 1))
    N1 = (p^2 * f^2 / q^2) * (n - 1) * (p + n - 1) * (2q + p - 2)
    D = (p + 2n - 3) * (p + 2n - 2)^2 * (p + 2n - 1)
    return N1 / D
end

@inline function _rib_db_dp(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    N1 = (p * f / q) *
         ((-4p - 4q + 4) * n^2 + (4p - 4 + 4q - 2p^2) * n + p^2 * q)
    D = (p + 2n - 2)^2 * (p + 2n)^2
    return N1 / D
end

@inline function _rib_db_dq(x::Real, p::Real, q::Real, n::Integer)
    f = _rib_f(x, p, q)
    return -(p^2 * f) / (q * (p + 2n - 2) * (p + 2n))
end

# One continued-fraction pass computing I_x(p,q) and (∂I/∂p, ∂I/∂q)
# simultaneously (sharing the a_n/b_n primal terms across both partials).
# Only valid for `x <= p/(p+q)`; the caller applies the reflection symmetry
# for the complementary regime. 100 terms matches the upstream reference
# implementation's default and is what this package's tests validate
# against the published Boik & Robinson-Cox table.
function _rib_value_and_partials(x::Real, p::Real, q::Real; maxiter::Int = 100)
    T = float(promote_type(typeof(x), typeof(p), typeof(q)))
    Am2, Am1 = one(T), one(T)
    Bm2, Bm1 = zero(T), one(T)
    dAm2_p, dAm1_p = zero(T), zero(T)
    dBm2_p, dBm1_p = zero(T), zero(T)
    dAm2_q, dAm1_q = zero(T), zero(T)
    dBm2_q, dBm1_q = zero(T), zero(T)
    A, B = Am1, Bm1
    dA_p, dB_p, dA_q, dB_q = dAm1_p, dBm1_p, dAm1_q, dBm1_q

    for n in 1:maxiter
        a_n = _rib_a(x, p, q, n)
        b_n = _rib_b(x, p, q, n)
        da_p = _rib_da_dp(x, p, q, n)
        db_p = _rib_db_dp(x, p, q, n)
        da_q = _rib_da_dq(x, p, q, n)
        db_q = _rib_db_dq(x, p, q, n)

        A = Am2 * a_n + Am1 * b_n
        dA_p = da_p * Am2 + a_n * dAm2_p + db_p * Am1 + b_n * dAm1_p
        dA_q = da_q * Am2 + a_n * dAm2_q + db_q * Am1 + b_n * dAm1_q

        B = Bm2 * a_n + Bm1 * b_n
        dB_p = da_p * Bm2 + a_n * dBm2_p + db_p * Bm1 + b_n * dBm1_p
        dB_q = da_q * Bm2 + a_n * dBm2_q + db_q * Bm1 + b_n * dBm1_q

        Am2, Am1 = Am1, A
        Bm2, Bm1 = Bm1, B
        dAm2_p, dAm1_p = dAm1_p, dA_p
        dBm2_p, dBm1_p = dBm1_p, dB_p
        dAm2_q, dAm1_q = dAm1_q, dA_q
        dBm2_q, dBm1_q = dBm1_q, dB_q
    end

    logK = p * log(x) + (q - 1) * log1p(-x) - log(p) - logbeta(p, q)
    K = exp(logK)
    F1_p = A / B * (log(x) - 1 / p + digamma(p + q) - digamma(p)) +
           dA_p / B - A * dB_p / B^2
    F1_q = A / B * (log1p(-x) + digamma(p + q) - digamma(q)) +
           dA_q / B - A * dB_q / B^2
    return K * A / B, K * F1_p, K * F1_q
end

@doc """
AD-safe regularised incomplete beta `I_x(α, β)` — the Beta(α, β) CDF at `x`.

Primal goes through `SpecialFunctions.beta_inc` (same path the non-AD hot
path uses). AD coverage is supplied by per-backend extensions:

- `EpiAwareADToolsChainRulesCoreExt` defines the reverse-mode `rrule` and
  forward-mode `frule` (analytical partials, primal via `beta_inc`).
- `EpiAwareADToolsMooncakeExt` lifts both the rrule and frule into Mooncake
  (reverse and forward mode).
- `EpiAwareADToolsReverseDiffExt` lifts the rrule into ReverseDiff.
- `EpiAwareADToolsForwardDiffExt` defines `Dual` methods on `_beta_cdf`
  directly (forward-mode dispatches on argument types, not via ChainRules).
- `EpiAwareADToolsEnzymeExt` supplies the direct Enzyme rule.

The `α`/`β`-partials that `beta_inc`'s `ChainRule` leaves unimplemented are
supplied by [`_rib_value_and_partials`](@ref), following the continued
fraction Boik & Robinson-Cox (1998) derive for the regularised incomplete
beta's shape-parameter derivatives. This mirrors [`_gamma_cdf`](@ref)'s
role for `gamma_inc` (SpecialFunctions.jl issue #531) — there is no
equivalent tracking issue open against `beta_inc` at the time of writing;
this machinery is deleted if/when SpecialFunctions.jl grows one.
"""
function _beta_cdf(α::Real, β::Real, x::Real)
    x <= 0 && return zero(α) * zero(β) * zero(x)
    x >= 1 && return one(α) * one(β) * one(x) - zero(α) * zero(β) * zero(x)
    αp, βp, xp = promote(α, β, x)
    return first(beta_inc(αp, βp, xp))
end

@doc """
Primal value and analytical partials `(Ω, dα, dβ, dx)` for
[`_beta_cdf`](@ref). Shared by every per-backend AD extension so the
formulas live in one place:

- `dx = pdf(Beta(α, β), x)`
- `(dα, dβ) = _rib_value_and_partials(x, α, β)[2:3]` directly when
  `x <= α/(α+β)`; otherwise obtained via the reflection symmetry
  `I_x(α,β) = 1 - I_{1-x}(β,α)`, so
  `dα = -(∂I_{1-x}(β,α)/∂(3rd arg))`,
  `dβ = -(∂I_{1-x}(β,α)/∂(2nd arg))`
  (the derivation Boik & Robinson-Cox's own reflected-argument identity
  gives; see the module docstring above [`_rib_f`](@ref)).

The `x <= 0`/`x >= 1` branches return the same constant `(Ω, 0, 0, 0)` /
`(Ω, 0, 0, 0)` pair `_beta_cdf` uses for its primal-only path (`Ω = 0` or
`1`), matching its early-return behaviour.
"""
function _beta_cdf_value_and_partials(α::Real, β::Real, x::Real)
    T = float(promote_type(typeof(α), typeof(β), typeof(x)))
    if x <= 0
        z = zero(T)
        return z, z, z, z
    elseif x >= 1
        z = zero(T)
        return one(T), z, z, z
    end
    f = pdf(Beta(α, β), x)
    if x > α / (α + β)
        Ih, d_at_β_slot, d_at_α_slot = _rib_value_and_partials(1 - x, β, α)
        return 1 - Ih, -d_at_α_slot, -d_at_β_slot, f
    end
    Ω, dα, dβ = _rib_value_and_partials(x, α, β)
    return Ω, dα, dβ, f
end
