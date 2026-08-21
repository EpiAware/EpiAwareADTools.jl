# Value-level unit tests for the AD-safe hooks and the tape-strip pair. These
# need no AD backend — they pin that the hooks agree with the stock
# Distributions functions on the primal (non-AD) path and that the strip
# helpers behave as identities on plain values. Backend gradient coverage lives
# in the `:ad` items under `test/ad/`.

@testitem "hooks agree with Distributions on Gamma" begin
    using EpiAwareADTools
    using Distributions: Gamma, cdf, logcdf, ccdf, logccdf, pdf

    d = Gamma(2.3, 1.7)
    for x in (0.4, 1.0, 3.2, 8.0)
        @test cdf_ad_safe(d, x) ≈ cdf(d, x)
        @test logcdf_ad_safe(d, x) ≈ logcdf(d, x)
        @test ccdf_ad_safe(d, x) ≈ ccdf(d, x)
        @test logccdf_ad_safe(d, x) ≈ logccdf(d, x)
        @test pdf_ad_safe(d, x) ≈ pdf(d, x)
    end
end

@testitem "logccdf_ad_safe preserves the Gamma far right tail" begin
    using EpiAwareADTools
    using Distributions: Gamma, logccdf

    # EpiAwareADTools#47: `log1p(-F)` underflows to `-Inf` once `F` rounds to
    # `1` in Float64, far short of where the stock evaluator (which computes
    # the survival directly rather than as `1 - F`) stays finite. Values
    # mirror the issue's own measurements on `main`, where `x = 45` had
    # already gone to `-Inf` and `x = 40` was 0.7% out.
    d = Gamma(2.0, 1.0)
    for x in (0.4, 1.0, 3.2, 8.0, 20.0, 30.0, 40.0, 45.0, 100.0, 1000.0)
        @test logccdf_ad_safe(d, x) ≈ logccdf(d, x) rtol = 1.0e-9
    end
end

@testitem "hooks agree with Distributions on Beta" begin
    using EpiAwareADTools
    using Distributions: Beta, cdf, logcdf, ccdf, logccdf, pdf

    d = Beta(2.3, 1.7)
    for x in (0.05, 0.3, 0.6, 0.95)
        @test cdf_ad_safe(d, x) ≈ cdf(d, x)
        @test logcdf_ad_safe(d, x) ≈ logcdf(d, x)
        @test ccdf_ad_safe(d, x) ≈ ccdf(d, x)
        @test logccdf_ad_safe(d, x) ≈ logccdf(d, x)
        @test pdf_ad_safe(d, x) ≈ pdf(d, x)
    end
end

@testitem "hooks fall through for a distribution with no dedicated method" begin
    using EpiAwareADTools
    using Distributions: Normal, Exponential, cdf, logcdf, ccdf, logccdf, pdf

    for d in (Normal(1.0, 2.0), Exponential(1.5))
        for x in (0.3, 1.5, 4.0)
            @test cdf_ad_safe(d, x) == cdf(d, x)
            @test logcdf_ad_safe(d, x) == logcdf(d, x)
            @test ccdf_ad_safe(d, x) == ccdf(d, x)
            @test logccdf_ad_safe(d, x) == logccdf(d, x)
            @test pdf_ad_safe(d, x) == pdf(d, x)
        end
    end
end

@testitem "hook Gamma boundary guards" begin
    using EpiAwareADTools
    using Distributions: Gamma

    d = Gamma(2.0, 1.5)
    # Non-positive evaluation points: CDF/survival limits.
    @test cdf_ad_safe(d, 0.0) == 0.0
    @test logcdf_ad_safe(d, 0.0) == -Inf
    @test logcdf_ad_safe(d, -1.0) == -Inf
    @test ccdf_ad_safe(d, 0.0) == 1.0
    @test logccdf_ad_safe(d, 0.0) == 0.0
    @test logccdf_ad_safe(d, -1.0) == 0.0
end

@testitem "hook Beta boundary guards" begin
    using EpiAwareADTools
    using Distributions: Beta

    d = Beta(2.0, 1.5)
    # Non-positive evaluation points: CDF/survival limits.
    @test cdf_ad_safe(d, 0.0) == 0.0
    @test logcdf_ad_safe(d, 0.0) == -Inf
    @test logcdf_ad_safe(d, -1.0) == -Inf
    @test ccdf_ad_safe(d, 0.0) == 1.0
    @test logccdf_ad_safe(d, 0.0) == 0.0
    @test logccdf_ad_safe(d, -1.0) == 0.0
    # At-or-above-one evaluation points: CDF saturates to 1.
    @test cdf_ad_safe(d, 1.0) == 1.0
    @test ccdf_ad_safe(d, 1.0) == 0.0
end

@testitem "hooks agree with Distributions on LogNormal" begin
    using EpiAwareADTools
    using Distributions: LogNormal, cdf, logcdf, ccdf, logccdf, pdf

    d = LogNormal(1.0, 0.75)
    for x in (0.3, 1.2, 2.5, 5.1)
        @test cdf_ad_safe(d, x) ≈ cdf(d, x)
        @test logcdf_ad_safe(d, x) ≈ logcdf(d, x)
        @test ccdf_ad_safe(d, x) ≈ ccdf(d, x)
        @test logccdf_ad_safe(d, x) ≈ logccdf(d, x)
        @test pdf_ad_safe(d, x) ≈ pdf(d, x)
    end
end

@testitem "hooks agree with Distributions on Weibull" begin
    using EpiAwareADTools
    using Distributions: Weibull, cdf, logcdf, ccdf, logccdf, pdf

    d = Weibull(2.0, 1.5)
    for x in (0.3, 1.2, 2.5, 5.1)
        @test cdf_ad_safe(d, x) ≈ cdf(d, x)
        @test logcdf_ad_safe(d, x) ≈ logcdf(d, x)
        @test ccdf_ad_safe(d, x) ≈ ccdf(d, x)
        @test logccdf_ad_safe(d, x) ≈ logccdf(d, x)
        @test pdf_ad_safe(d, x) ≈ pdf(d, x)
    end
end

@testitem "hook LogNormal boundary guards" begin
    using EpiAwareADTools
    using Distributions: LogNormal

    d = LogNormal(1.0, 0.75)
    # Non-positive evaluation points: CDF/survival limits.
    @test cdf_ad_safe(d, 0.0) == 0.0
    @test cdf_ad_safe(d, -1.0) == 0.0
    @test logcdf_ad_safe(d, 0.0) == -Inf
    @test logcdf_ad_safe(d, -1.0) == -Inf
    @test ccdf_ad_safe(d, 0.0) == 1.0
    @test ccdf_ad_safe(d, -1.0) == 1.0
    @test logccdf_ad_safe(d, 0.0) == 0.0
    @test logccdf_ad_safe(d, -1.0) == 0.0
    @test pdf_ad_safe(d, 0.0) == 0.0
    @test pdf_ad_safe(d, -1.0) == 0.0
end

@testitem "hook Weibull boundary guards" begin
    using EpiAwareADTools
    using Distributions: Weibull

    d = Weibull(2.0, 1.5)
    # Non-positive evaluation points: only `logcdf_ad_safe` needs a
    # dedicated guard here (the stock `cdf`/`ccdf`/`logccdf`/`pdf` already
    # have a finite gradient at the boundary), but all five values are
    # pinned so a future change cannot silently reintroduce the NaN on one
    # of them.
    @test cdf_ad_safe(d, 0.0) == 0.0
    @test cdf_ad_safe(d, -1.0) == 0.0
    @test logcdf_ad_safe(d, 0.0) == -Inf
    @test logcdf_ad_safe(d, -1.0) == -Inf
    @test ccdf_ad_safe(d, 0.0) == 1.0
    @test ccdf_ad_safe(d, -1.0) == 1.0
    @test logccdf_ad_safe(d, 0.0) == 0.0
    @test logccdf_ad_safe(d, -1.0) == 0.0
    @test pdf_ad_safe(d, 0.0) == 0.0
    @test pdf_ad_safe(d, -1.0) == 0.0
end

@testitem "primal is the identity on plain reals" begin
    using EpiAwareADTools: primal

    @test primal(3.0) === 3.0
    @test primal(2.0f0) === 2.0f0
    @test primal(4) === 4
end

@testitem "primal strips (nested) tuples elementwise" begin
    using EpiAwareADTools: primal

    # A composite distribution's `params` returns nested per-component
    # tuples, so the Tuple method must recurse.
    @test primal(((1.0, 2.0), 3.0)) === ((1.0, 2.0), 3.0)
    @test primal(()) === ()
end

@testitem "primal strips a Dual inside a tuple" begin
    using ForwardDiff: Dual
    using EpiAwareADTools: primal

    stripped = primal((Dual{:t}(2.0, 1.0), 3.0))
    @test stripped === (2.0, 3.0)
end

@testitem "primal_distribution rebuilds from primal params" begin
    using EpiAwareADTools: primal_distribution
    using Distributions: Gamma, Beta, Normal, LogNormal, params

    for d in (
            Gamma(2.0, 1.5), Beta(2.0, 1.5), Normal(-0.5, 0.8),
            LogNormal(0.2, 0.3),
        )
        p = primal_distribution(d)
        @test p == d
        @test params(p) == params(d)
    end
end

@testitem "hooks accept a leaf that is not a UnivariateDistribution" begin
    using EpiAwareADTools
    using Distributions

    # A leaf that implements the univariate interface through the
    # Distributions.jl generic functions without subtyping
    # `UnivariateDistribution`.
    struct DuckExponential{T <: Real}
        θ::T
    end
    Distributions.cdf(d::DuckExponential, x::Real) = cdf(Exponential(d.θ), x)
    Distributions.ccdf(d::DuckExponential, x::Real) = ccdf(Exponential(d.θ), x)
    Distributions.pdf(d::DuckExponential, x::Real) = pdf(Exponential(d.θ), x)
    function Distributions.logcdf(d::DuckExponential, x::Real)
        return logcdf(Exponential(d.θ), x)
    end
    function Distributions.logccdf(d::DuckExponential, x::Real)
        return logccdf(Exponential(d.θ), x)
    end

    d = DuckExponential(1.5)
    ref = Exponential(1.5)
    @test !(d isa UnivariateDistribution)
    for x in (0.3, 1.5, 4.0)
        @test cdf_ad_safe(d, x) == cdf(ref, x)
        @test logcdf_ad_safe(d, x) == logcdf(ref, x)
        @test ccdf_ad_safe(d, x) == ccdf(ref, x)
        @test logccdf_ad_safe(d, x) == logccdf(ref, x)
        @test pdf_ad_safe(d, x) == pdf(ref, x)
    end
end
