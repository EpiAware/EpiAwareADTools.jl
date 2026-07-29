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
