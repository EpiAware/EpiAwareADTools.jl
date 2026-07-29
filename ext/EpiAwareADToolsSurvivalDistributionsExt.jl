module EpiAwareADToolsSurvivalDistributionsExt

import EpiAwareADTools: cdf_ad_safe, ccdf_ad_safe,
                        logcdf_ad_safe, logccdf_ad_safe
import Distributions: logcdf
import SurvivalDistributions as SD

# AD-safe CDF family for `SurvivalDistributions.GeneralizedGamma`.
#
# GeneralizedGamma carries an inner `Gamma(nu/gamma, sigma^gamma)` and defines
# `logccdf(d, t) = logccdf(d.G, t^gamma)`. The stock `logccdf(::Gamma)` routes
# through `StatsFuns._gammalogccdf`, which has no `ForwardDiff.Dual` /
# `ReverseDiff.TrackedReal` / Mooncake method, so any numeric kernel that
# queries the `cdf` / `logccdf` of a GeneralizedGamma leaf errors under every
# AD backend.
#
# The `Gamma` methods of the hooks already differentiate the regularised lower
# incomplete gamma via `_gamma_cdf`, whose per-backend rules live in this
# package's AD extensions. Routing the inner Gamma through `cdf_ad_safe` at the
# transformed point `t^gamma` makes the GeneralizedGamma CDF family
# differentiate everywhere the plain `Gamma` path does, mirroring the
# `*_ad_safe(::Gamma)` methods. The `t^gamma` transform and the inner
# `shape`/`scale` (functions of `nu`, `gamma`, `sigma`) are elementary, so the
# gradient flows through all three parameters. GeneralizedGamma's constructor
# promotes its parameters into the inner `Gamma{T}`, so a `Dual` / `Tracked`
# parameter survives into `d.G` and the `_gamma_cdf` rules do the rest.
#
# `SurvivalDistributions.LogLogistic` needs no special AD routing: its
# `logccdf` is built from elementary operations (`log1p`/`exp`), so it
# differentiates through the generic elementary fallback under every backend
# without a `*_ad_safe` method.
#
# Upstream target: `SurvivalDistributions.jl`, which would carry these once the
# Gamma CDF is differentiable in its parameters upstream
# (`SpecialFunctions.jl` issue #531) — the same deletion condition as the rest
# of the hook family.

function _gg_cdf(d::SD.GeneralizedGamma, u::Real)
    return cdf_ad_safe(d.G, u^d.gamma)
end

function cdf_ad_safe(d::SD.GeneralizedGamma, u::Real)
    u <= 0 && return zero(float(u))
    return _gg_cdf(d, u)
end

function ccdf_ad_safe(d::SD.GeneralizedGamma, u::Real)
    u <= 0 && return one(float(u))
    return 1 - _gg_cdf(d, u)
end

function logcdf_ad_safe(d::SD.GeneralizedGamma, u::Real)
    u <= 0 && return oftype(float(u), -Inf)
    return log(_gg_cdf(d, u))
end

function logccdf_ad_safe(d::SD.GeneralizedGamma, u::Real)
    u <= 0 && return zero(float(u))
    return log1p(-_gg_cdf(d, u))
end

# The public `logcdf(::GeneralizedGamma, t)` must be AD-safe too, not just the
# `*_ad_safe` hook methods above. `SurvivalDistributions` defines
# `logccdf(GG, t) = logccdf(d.G, t^gamma)` but no `logcdf`, so a direct
# `logcdf(GeneralizedGamma(θ...), t)` falls through to the generic
# `Distributions.logcdf(::UnivariateDistribution, ::Real) = log(cdf(d, x))`.
# That reaches `SurvivalDistributions`' own
# `cdf(GG, t) = 1 - exp(logccdf(d.G, t^gamma))` and so lands on
# `StatsFuns._gammalogccdf` — the survival branch, not `_gammalogcdf`, because
# the whole GeneralizedGamma CDF family is defined from the survival. That has
# no `ForwardDiff.Dual` / `ReverseDiff.TrackedReal` / Mooncake method, so under
# any AD backend it strips the `Dual` and throws. Routing `logcdf` through the
# AD-safe helper makes a bare `logcdf` differentiate everywhere, closing the
# gap a user hits scoring a GeneralizedGamma leaf directly.
# `cdf`/`ccdf`/`logccdf` are owned by
# `SurvivalDistributions` (redefining them here is method-overwriting piracy
# and breaks precompilation), so they are left to the `cdf_ad_safe` /
# `ccdf_ad_safe` / `logccdf_ad_safe` hooks. Only `logcdf` is unclaimed and so
# safely AD-routed at the public method.
logcdf(d::SD.GeneralizedGamma, t::Real) = logcdf_ad_safe(d, t)

end # module
