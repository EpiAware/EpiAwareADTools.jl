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

@testitem "hooks fall through for a non-Gamma distribution" begin
    using EpiAwareADTools
    using Distributions: Normal, LogNormal, cdf, logcdf, ccdf, logccdf, pdf

    for d in (Normal(1.0, 2.0), LogNormal(0.5, 0.4))
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

    for d in (Gamma(2.0, 1.5), Beta(2.0, 1.5), Normal(-0.5, 0.8),
        LogNormal(0.2, 0.3))
        p = primal_distribution(d)
        @test p == d
        @test params(p) == params(d)
    end
end
