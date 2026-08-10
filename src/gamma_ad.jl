@doc raw"""
Partial of the regularised lower incomplete gamma with respect to the
shape parameter — the term `SpecialFunctions.gamma_inc` leaves as
`@not_implemented` in its `ChainRule`. Computed by term-by-term
differentiation of the Tricomi absolutely-convergent series for
`P(a, z) = z^a e^{-z} Σ_{n ≥ 0} z^n / Γ(a + n + 1)`:

```math
\frac{\partial P(a, z)}{\partial a}
    = \log(z)\, P(a, z) -
      z^a e^{-z} \sum_{n \geq 0}
        \frac{\psi(a + n + 1)\, z^n}{\Gamma(a + n + 1)}
```

with `ψ(a + n + 1) = ψ(a + n) + 1 / (a + n)` propagated alongside the
term recurrence `term_{n+1} = term_n · z / (a + n + 1)`. Used by the
reverse-mode rule in `EpiAwareADToolsChainRulesCoreExt` and by the
forward-mode `Dual` methods in `EpiAwareADToolsForwardDiffExt`.

This is the analytic α-partial the upstream `gamma_inc` `ChainRule`
should eventually supply: SpecialFunctions.jl issue #531 (implement the
shape-parameter partial for `gamma_inc` as a convergent series) tracks
it. The helper is deleted once that rule lands.

# References

The series + digamma-recurrence form is Moore (1982), "Algorithm AS
187: Derivatives of the Incomplete Gamma Integral", *Applied
Statistics* 31:330-335. The same construction is used by Stan
(`stan/math/prim/fun/grad_reg_inc_gamma.hpp`) and JAX
(`jax._src.scipy.special.random_gamma_grad` / `igamma_grad_a`) for the
shape derivative of the regularised lower incomplete gamma.
"""
function _grad_p_a_series(a::Real, z::Real; rtol::Real = 1e-14,
        maxiter::Int = 10_000)
    z <= 0 && return zero(a) * zero(z)
    log_term0 = a * log(z) - z - loggamma(a + 1)
    term = exp(log_term0)
    psi = digamma(a + 1)
    P = term
    S = term * psi
    for n in 1:maxiter
        term *= z / (a + n)
        psi += 1 / (a + n)
        P += term
        S += term * psi
        abs(term * psi) <= rtol * abs(S) &&
            abs(term) <= rtol * abs(P) && break
    end
    return log(z) * P - S
end

@doc """
AD-safe Gamma CDF, `P(k, x/θ)`.

Primal goes through `SpecialFunctions.gamma_inc` for every `Real`
subtype it supports (`Float64`, `Float32`, `BigFloat`) — same path the
non-AD hot path uses, full accuracy across all `z/a` regimes. AD
coverage is supplied by per-backend extensions:

- `EpiAwareADToolsChainRulesCoreExt` defines the reverse-mode `rrule`
  and forward-mode `frule` (analytical partials, primal via `gamma_inc`).
- `EpiAwareADToolsMooncakeExt` lifts both the rrule and frule into
  Mooncake (reverse and forward mode).
- `EpiAwareADToolsReverseDiffExt` lifts the rrule into ReverseDiff.
- `EpiAwareADToolsForwardDiffExt` defines `Dual` methods on `_gamma_cdf`
  directly (forward-mode dispatches on argument types, not via ChainRules).

The α-partial that `gamma_inc`'s `ChainRule` leaves as
`@not_implemented` is supplied by [`_grad_p_a_series`](@ref), following
the series form Moore (1982) introduced as Algorithm AS 187 and that
Stan (`grad_reg_inc_gamma`) and JAX (`igamma_grad_a`) both use. This
whole machinery stands in for a differentiable `gamma_inc` upstream
(SpecialFunctions.jl issue #531) and is deleted once that exists.
"""
function _gamma_cdf(k::Real, θ::Real, x::Real)
    x <= 0 && return zero(k) * zero(θ) * zero(x)
    kp, zp = promote(k, x / θ)
    return first(gamma_inc(kp, zp))
end

@doc """
Primal value and analytical partials `(Ω, dk, dθ, dx)` for
[`_gamma_cdf`](@ref). Shared by every per-backend AD extension so the
formulas live in one place:

- `dx = pdf(Gamma(k, θ), x)`
- `dθ = -(x/θ) · dx`
- `dk = _grad_p_a_series(k, x/θ)`

The non-positive-`x` branch returns zeros for the primal and all three
partials, matching `_gamma_cdf`'s early-return behaviour.
"""
function _gamma_cdf_value_and_partials(k::Real, θ::Real, x::Real)
    if x <= 0
        T = float(promote_type(typeof(k), typeof(θ), typeof(x)))
        z = zero(T)
        return (z, z, z, z)
    end
    z = x / θ
    Ω = first(gamma_inc(promote(k, z)...))
    f = pdf(Gamma(k, θ), x)
    dk = _grad_p_a_series(k, z)
    dθ = -(x / θ) * f
    dx = f
    return (Ω, dk, dθ, dx)
end

@doc raw"""
Accurate `log(Q(a, z))`, the log of the regularised UPPER incomplete gamma
`Q(a, z) = 1 - P(a, z)`, for [`_gamma_logccdf`](@ref) and its
value-and-partials companion.

`SpecialFunctions.gamma_inc` returns `(P, Q)` from independent
series/continued-fraction evaluations rather than by subtracting `P` from
`1`, so its own `Q` output stays a representable, accurate value far beyond
where `log1p(-P)` underflows — `P` rounds to exactly `1` in the working
float type well before `Q` itself underflows to `0`. `log(Q)` is read
directly from that output while it stays representable; once `Q` itself
underflows, the log-space form `loggamma(a, z) - loggamma(a)` (the log of
the *unnormalised* upper incomplete gamma over `log Γ(a)`, itself finite far
beyond that point) takes over. This mirrors the branch structure
`StatsFuns._gammalogccdf` uses for the stock (non-differentiable) evaluator,
so the two agree at implementation tolerance across the whole domain rather
than only where `log1p(-P)` happens to hold up.

Returns `(log(Q), Q)`, with `Q` taken straight from `gamma_inc` rather than
recovered as `exp(log(Q))` — exponentiating costs `|log Q| * eps` relative
error and lands in the subnormals well before `gamma_inc`'s own `Q` does —
so [`_gamma_logccdf_value_and_partials`](@ref) can divide by the accurate
survival.
"""
function _gamma_logQ(a::Real, z::Real)
    l, u = gamma_inc(a, z)
    if u < floatmin(typeof(u))
        return loggamma(a, z) - loggamma(a), u
    elseif u < 0.7
        return log(u), u
    else
        return log1p(-l), u
    end
end

@doc """
AD-safe Gamma log survival, `log(Q(k, x/θ))` — the analogue of
[`_gamma_cdf`](@ref) for the log-space survival rather than the CDF.

Unlike the naive `log1p(-_gamma_cdf(k, θ, x))`, this never forms the CDF as a
literal float and subtracts it from `1`: [`_gamma_logQ`](@ref) reads the
survival from `SpecialFunctions.gamma_inc`'s own second output, computed
independently of the CDF, so precision survives far into the right tail
where the CDF itself has already rounded to exactly `1`
(EpiAwareADTools#47). AD coverage follows the same per-backend pattern as
`_gamma_cdf`: [`_gamma_logccdf_value_and_partials`](@ref) supplies the
shared primal and partials the ChainRules rule, the ForwardDiff `Dual`
methods, and the Enzyme rule all consume.
"""
function _gamma_logccdf(k::Real, θ::Real, x::Real)
    x <= 0 && return zero(k) * zero(θ) * zero(x)
    kp, zp = promote(k, x / θ)
    return first(_gamma_logQ(kp, zp))
end

@doc """
Primal value and analytical partials `(Ω, dk, dθ, dx)` for
[`_gamma_logccdf`](@ref).

The partials of a *log* survival are relative derivatives, and for a Gamma
they converge to finite, non-zero limits in the deep tail — `-dx` is the
hazard rate, which tends to `1/θ` — so they must stay accurate past the
point where `Q` itself underflows. `dx` and `dθ` both reduce to the ratio
`f/Q` and are formed fully in log space as `exp(logpdf - Ω)`, well
conditioned to arbitrary tail depth. `dk` divides
[`_grad_p_a_series`](@ref)'s `∂P/∂a` by `gamma_inc`'s own
accurately-computed `Q` (returned alongside `Ω` by [`_gamma_logQ`](@ref),
never recovered as `exp(Ω)`) while `Q ≥ √eps(T)` — the scaling at which
the series' absolute rounding error stays negligible against `∂Q/∂a` —
and hands over to [`_dlogQ_da_tail_series`](@ref) below that: the naive
quotient loses relative accuracy long before `Q` underflows, flipping
sign entirely by `Q ≈ 1e-16` in Float64. The type-relative threshold
keeps a BigFloat caller on the exact quotient to the depth its precision
genuinely supports. At reduced precision (Float32) the two paths cross at
a higher error floor, so `dk` carries `~1e-5` relative error in the
transition band — a documented limit rather than a tunable. Every backend
receives finite, accurate gradients across the whole tail
(EpiAwareADTools#47).

The `x <= 0` branch returns the same constant `(0, 0, 0, 0)`
[`_gamma_cdf_value_and_partials`](@ref) uses for its primal-only path, since
`log(Q(k, 0)) = log(1) = 0`.
"""
function _gamma_logccdf_value_and_partials(k::Real, θ::Real, x::Real)
    if x <= 0
        T = float(promote_type(typeof(k), typeof(θ), typeof(x)))
        z = zero(T)
        return (z, z, z, z)
    end
    z = x / θ
    Ω, Q = _gamma_logQ(promote(k, z)...)
    r = exp(logpdf(Gamma(k, θ), x) - Ω)
    dx = -r
    dθ = (x / θ) * r
    if Q >= sqrt(eps(typeof(Q)))
        dk = -_grad_p_a_series(k, z) / Q
    else
        dk = _dlogQ_da_tail_series(promote(k, z)...)
    end
    return (Ω, dk, dθ, dx)
end

@doc raw"""
`∂ log Q(a, z) / ∂a` deep in the right tail, from the large-`z` asymptotic
expansion of the unnormalised upper incomplete gamma,
`Γ(a, z) = z^{a-1} e^{-z} S` with `S = Σₙ ∏ⱼ₌₁ⁿ (a - j) / zⁿ`, giving

```math
\frac{∂ \log Q}{∂a} = \log z - ψ(a) + \frac{S'}{S}
```

`S` and its `a`-derivative `S'` are accumulated by the joint recurrence
`tₙ = tₙ₋₁ (a - n) / z`, `sₙ = (sₙ₋₁ (a - n) + tₙ₋₁) / z`, which never
divides by `(a - j)` and so is exact when `a` is an integer and the product
terminates. The expansion is asymptotic, not convergent: its terms shrink
until `n ≈ z - a` and then grow without bound, so the loop stops at that
optimal-truncation point, leaving an error of roughly the last included
term, `~e^{-(z-a)}`. Both exits watch the combined magnitude
`|tₙ| + |sₙ|`, not `tₙ` alone: at integer `a` the value series terminates
(`tₙ` hits an exact `0`) while the derivative series `sₙ` keeps
contributing, and stopping on `tₙ` there silently truncates `S'`. Used by
[`_gamma_logccdf_value_and_partials`](@ref) once
`Q < √eps(T)` (`~1.5e-8` in Float64): there `z - a ≳ 16` for any shape,
so the truncation error is at worst `~1e-7` and falls exponentially with
depth, while the exact `∂P/∂a / Q` quotient it replaces is *losing* a
digit for every decade `Q` drops (measured against finite differences of
the stock `logccdf`, both paths hold `~1e-6` relative error or better at
the crossover, the series reaching `~1e-12` once `Q < 1e-10`). The
iteration count to the `eps` exit grows like `z - a ~ 5.6√a` in the slow
geometric regime (`a` large, `z/a` near `1`), so the cap binds only above
shape `~2e5`, where accuracy degrades gradually rather than failing.
"""
function _dlogQ_da_tail_series(a::T, z::T) where {T <: Real}
    t = one(T)
    s = zero(T)
    S = one(T)
    Sp = zero(T)
    prev = one(T)
    for n in 1:2500
        snew = (s * (a - n) + t) / z
        tnew = t * (a - n) / z
        mag = abs(tnew) + abs(snew)
        mag > prev && break
        S += tnew
        Sp += snew
        s, t = snew, tnew
        prev = mag
        mag < eps(T) * (abs(S) + abs(Sp)) && break
    end
    return log(z) - digamma(a) + Sp / S
end
