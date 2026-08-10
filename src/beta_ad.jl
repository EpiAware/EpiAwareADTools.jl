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
ported here to Julia with a 1000-term default ceiling this package's own
test suite validates against the paper's published table and against
`SpecialFunctions.beta_inc` for widely disparate `p`/`q` near the `x`
boundary, where fewer terms converge too slowly for full precision
(issue #42; the upstream 100-term default left both the primal and the
partials under-converged there).
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
# for the complementary regime. `maxiter` caps the term count needed for
# the hardest cases this package's tests validate against `beta_inc` at
# widely disparate `p`/`q` near the `x` boundary (issue #42): the original
# 100-term default left ~1e-5 relative error in the primal there (and,
# combined with the overflow below, NaN shape partials). The loop below
# exits as soon as the ratios the final formulas depend on stop moving
# (see `rtol`), so well-behaved, balanced-shape calls — the common case —
# converge in far fewer terms and do not pay for the 1000-term ceiling only
# the disparate regime needs.
#
# For widely disparate `p`/`q` near the `x` boundary, the raw A_n/B_n
# accumulators (and their derivative counterparts) can grow past the float
# type's ceiling before the fraction converges, turning the final
# `A * dB_p / B^2` combination into `Inf/Inf` or `Inf - Inf` (NaN). Each
# iteration rescales the current accumulators (and the previous iterate
# about to feed the next one) by their shared magnitude once it crosses
# `sqrt(floatmax(T))` — type-dependent, so Float32 (whose `floatmax` of
# ~3.4e38 sits ~62 orders below the fixed `1e100` trigger this replaces,
# which therefore could never fire before Float32 overflow) is guarded
# too, with half the exponent range left as headroom against the few
# orders of per-iteration growth. The two-term recurrence is linear and
# homogeneous in each of the A- and B-histories, so dividing every tracked
# quantity — A, B and both derivative pairs — by the same factor leaves
# every ratio the final formulas use (`A / B`, `dA_p / B`, `A * dB_p / B^2`)
# exactly unchanged; only the (irrelevant) common scale is discarded. This
# is the standard renormalisation modified-Lentz-style continued-fraction
# evaluators use to stay within floating-point range.
function _rib_value_and_partials(x::Real, p::Real, q::Real;
        rtol::Real = 1e-13, atol::Real = 1e-13, maxiter::Int = 1000)
    T = float(promote_type(typeof(x), typeof(p), typeof(q)))
    rescale_threshold = sqrt(floatmax(T))
    # Exit tolerances floor at 100·eps(T): the Float64 defaults pass
    # through unchanged (100·eps ≈ 2.2e-14 < 1e-13), while a
    # reduced-precision T, whose iterates never stabilise to a Float64
    # tolerance, still gets a reachable exit instead of always running to
    # `maxiter`.
    rtolT = max(T(rtol), 100 * eps(T))
    atolT = max(T(atol), 100 * eps(T))
    Am2, Am1 = one(T), one(T)
    Bm2, Bm1 = zero(T), one(T)
    dAm2_p, dAm1_p = zero(T), zero(T)
    dBm2_p, dBm1_p = zero(T), zero(T)
    dAm2_q, dAm1_q = zero(T), zero(T)
    dBm2_q, dBm1_q = zero(T), zero(T)
    A, B = Am1, Bm1
    dA_p, dB_p, dA_q, dB_q = dAm1_p, dBm1_p, dAm1_q, dBm1_q

    # Scale- and reparametrisation-invariant quantities the closed-form
    # F1_p/F1_q formulas below actually reduce to: `A * dB_p / B^2 ==
    # (A / B) * (dB_p / B)`, so `F1_p == r_A * (...) + G_p` with
    # `G_p = dA_p / B - r_A * dB_p / B` (and the `q` analogue for `G_q`).
    # `dA_p / B` and `dB_p / B` individually keep drifting for hundreds of
    # iterations even in the well-behaved cases below (a redundant degree
    # of freedom in how the recurrence splits between the two), but that
    # drift cancels in `G_p`/`G_q`, which converge in a handful of terms;
    # tracking the raw ratios instead of this combination was tried and
    # measured to never trigger the exit before `maxiter`, defeating the
    # point. `r_A` (and thus `G_p`/`G_q`) survives the rescaling below
    # unaffected, since numerator and denominator share the same factor
    # `s`.
    r_A = A / B
    G_p = dA_p / B - r_A * dB_p / B
    G_q = dA_q / B - r_A * dB_q / B

    converged = false
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

        s = max(abs(A), abs(B), abs(dA_p), abs(dB_p), abs(dA_q), abs(dB_q))
        if s > rescale_threshold
            A, B = A / s, B / s
            dA_p, dB_p = dA_p / s, dB_p / s
            dA_q, dB_q = dA_q / s, dB_q / s
            Am1, Bm1 = Am1 / s, Bm1 / s
            dAm1_p, dBm1_p = dAm1_p / s, dBm1_p / s
            dAm1_q, dBm1_q = dAm1_q / s, dBm1_q / s
        end

        Am2, Am1 = Am1, A
        Bm2, Bm1 = Bm1, B
        dAm2_p, dAm1_p = dAm1_p, dA_p
        dBm2_p, dBm1_p = dBm1_p, dB_p
        dAm2_q, dAm1_q = dAm1_q, dA_q
        dBm2_q, dBm1_q = dBm1_q, dB_q

        # The `atol` floor deliberately matches `rtol`: where `G_p`/`G_q`
        # are naturally below it the derivative contribution is negligible
        # and a first-iteration exit is the right answer. Both exit
        # tolerances sit an order below the tightest downstream test
        # tolerance (the direct-vs-reflected branch comparison in
        # `test/ad/beta_ad.jl` at 1e-12), which notes the coupling at its
        # end.
        r_A_new = A / B
        G_p_new = dA_p / B - r_A_new * dB_p / B
        G_q_new = dA_q / B - r_A_new * dB_q / B
        converged = isapprox(r_A_new, r_A; rtol = rtolT, atol = atolT) &&
                    isapprox(G_p_new, G_p; rtol = rtolT, atol = atolT) &&
                    isapprox(G_q_new, G_q; rtol = rtolT, atol = atolT)
        r_A, G_p, G_q = r_A_new, G_p_new, G_q_new
        converged && break
    end
    # An under-converged return is quieter than the NaN it replaced (#42),
    # so leave a trace; the disparate-shape tests assert a wide margin
    # against this ceiling.
    converged ||
        @debug "_rib_value_and_partials hit maxiter without converging" x p q maxiter

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
supplied by `_rib_value_and_partials`, following the continued
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
