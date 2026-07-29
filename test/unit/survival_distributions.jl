# Value-level unit tests for the `SurvivalDistributions` extension. These need
# no AD backend — they pin that the GeneralizedGamma hook methods agree with
# the stock `SurvivalDistributions` evaluators on the primal path, that the
# boundary guards hold, and that the extension's public `logcdf` method matches
# the hook. Backend gradient coverage lives in the `:ad` items under
# `test/ad/`.

@testitem "GeneralizedGamma hooks agree with SurvivalDistributions" begin
    using EpiAwareADTools
    using Distributions: cdf, ccdf, logccdf
    import SurvivalDistributions as SD

    # `(sigma, nu, gamma)`; gamma = 1 reduces to the inner Gamma, the others
    # exercise the `t^gamma` transform in both directions.
    for d in (SD.GeneralizedGamma(1.5, 2.0, 1.3),
        SD.GeneralizedGamma(0.8, 1.2, 0.7),
        SD.GeneralizedGamma(2.0, 3.0, 1.0))
        for x in (0.4, 1.0, 3.2, 8.0)
            @test cdf_ad_safe(d, x) ≈ cdf(d, x)
            @test ccdf_ad_safe(d, x) ≈ ccdf(d, x)
            @test logcdf_ad_safe(d, x) ≈ log(cdf(d, x))
            @test logccdf_ad_safe(d, x) ≈ logccdf(d, x)
        end
    end
end

@testitem "GeneralizedGamma hook boundary guards" begin
    using EpiAwareADTools
    import SurvivalDistributions as SD

    d = SD.GeneralizedGamma(1.5, 2.0, 1.3)
    # Support is the positive reals: CDF/survival limits below it.
    @test cdf_ad_safe(d, 0.0) == 0.0
    @test cdf_ad_safe(d, -1.0) == 0.0
    @test ccdf_ad_safe(d, 0.0) == 1.0
    @test ccdf_ad_safe(d, -1.0) == 1.0
    @test logcdf_ad_safe(d, 0.0) == -Inf
    @test logcdf_ad_safe(d, -1.0) == -Inf
    @test logccdf_ad_safe(d, 0.0) == 0.0
    @test logccdf_ad_safe(d, -1.0) == 0.0
end

@testitem "GeneralizedGamma logcdf routes through the hook" begin
    using EpiAwareADTools
    using Distributions: logcdf, cdf
    import SurvivalDistributions as SD

    # `SurvivalDistributions` leaves `logcdf` unclaimed, so the extension owns
    # this method; it must agree with both the hook and the stock `cdf`.
    d = SD.GeneralizedGamma(1.5, 2.0, 1.3)
    for x in (0.4, 1.0, 3.2, 8.0)
        @test logcdf(d, x) == logcdf_ad_safe(d, x)
        @test logcdf(d, x) ≈ log(cdf(d, x))
    end
    @test logcdf(d, 0.0) == -Inf
end

@testitem "GeneralizedGamma logcdf is still unclaimed upstream" begin
    using Distributions: Distributions, logcdf
    import SurvivalDistributions as SD

    # The extension's `logcdf` method is additive only while
    # `SurvivalDistributions` defines none of its own. If upstream adds one —
    # non-breaking for them, `SurvivalDistributions = "0.1"` here — ours
    # becomes a method-overwriting redefinition that breaks precompilation.
    # Fail loudly here instead, so the signal is a red test rather than a
    # package that will not load.
    owners = Set(
        parentmodule(m) for m in methods(logcdf, Tuple{SD.GeneralizedGamma, Real})
    )
    @test !(SD in owners)
end

@testitem "GeneralizedGamma pdf needs no bespoke method" begin
    using EpiAwareADTools
    using Distributions: pdf
    import SurvivalDistributions as SD

    # `logpdf(GG)` is elementary bar `loggamma`, so `pdf_ad_safe` stays a
    # passthrough. Pinned because it is the half of a survival likelihood the
    # CDF hooks do not supply; the AD items sweep its gradient.
    d = SD.GeneralizedGamma(1.5, 2.0, 1.3)
    for x in (0.4, 1.0, 3.2, 8.0)
        @test pdf_ad_safe(d, x) == pdf(d, x)
    end
end

@testitem "GeneralizedGamma logccdf tail agreement and its limit" begin
    using EpiAwareADTools
    using Distributions: logccdf
    import SurvivalDistributions as SD

    # `logccdf_ad_safe` reconstructs the survival as `log1p(-F)`, so it tracks
    # the stock evaluator only while `F` stays away from 1. Pin where that
    # holds, and pin the underflow itself so a future log-space survival
    # implementation shows up here as a deliberate change rather than silently.
    d = SD.GeneralizedGamma(1.5, 2.0, 1.3)
    for x in (0.4, 1.0, 3.2, 8.0, 15.0, 20.0)
        @test logccdf_ad_safe(d, x)≈logccdf(d, x) rtol=1e-6
    end
    @test logccdf_ad_safe(d, 30.0) == -Inf
    @test isfinite(logccdf(d, 30.0))
end

@testitem "LogLogistic needs no hook method" begin
    using EpiAwareADTools
    using Distributions: cdf, ccdf, logcdf, logccdf, pdf
    import SurvivalDistributions as SD

    # `LogLogistic` is built from elementary operations, so it differentiates
    # through the generic fallback and gets no bespoke method. Pin that the
    # hooks stay pure passthroughs for it.
    d = SD.LogLogistic(1.5, 2.0)
    for x in (0.3, 1.5, 4.0)
        @test cdf_ad_safe(d, x) == cdf(d, x)
        @test logcdf_ad_safe(d, x) == logcdf(d, x)
        @test ccdf_ad_safe(d, x) == ccdf(d, x)
        @test logccdf_ad_safe(d, x) == logccdf(d, x)
        @test pdf_ad_safe(d, x) == pdf(d, x)
    end
end
