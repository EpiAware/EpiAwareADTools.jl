# The five AD-safe evaluation hooks and the internal `_gamma_cdf`/`_beta_cdf`
# kernels.
#
# On a `Gamma`/`Beta` each hook routes through the analytic gamma-/beta-CDF
# path, so the `Hooks/Gamma`/`Hooks/Beta` rows read against the bare
# `Baseline/Gamma`/`Baseline/Beta` functions give the cost of the AD-safe
# detour on the primal (non-AD) call. On a `Normal` the generic method falls
# straight through to the stock Distributions function, so `Hooks/Normal`
# should sit on top of the corresponding baseline with no measurable overhead.

using EpiAwareADTools: _gamma_cdf, _beta_cdf

SUITE["Hooks"] = BenchmarkGroup()

let
    g = Gamma(2.0, 1.0)
    SUITE["Hooks"]["Gamma"] = BenchmarkGroup()
    SUITE["Hooks"]["Gamma"]["cdf_ad_safe"] = @benchmarkable cdf_ad_safe.(
        $g, $TEST_XS)
    SUITE["Hooks"]["Gamma"]["logcdf_ad_safe"] = @benchmarkable logcdf_ad_safe.(
        $g, $TEST_XS)
    SUITE["Hooks"]["Gamma"]["ccdf_ad_safe"] = @benchmarkable ccdf_ad_safe.(
        $g, $TEST_XS)
    SUITE["Hooks"]["Gamma"]["logccdf_ad_safe"] = @benchmarkable logccdf_ad_safe.(
        $g, $TEST_XS)
    SUITE["Hooks"]["Gamma"]["pdf_ad_safe"] = @benchmarkable pdf_ad_safe.(
        $g, $TEST_XS)

    b = Beta(2.0, 1.0)
    SUITE["Hooks"]["Beta"] = BenchmarkGroup()
    SUITE["Hooks"]["Beta"]["cdf_ad_safe"] = @benchmarkable cdf_ad_safe.(
        $b, $TEST_XS_BETA)
    SUITE["Hooks"]["Beta"]["logcdf_ad_safe"] = @benchmarkable logcdf_ad_safe.(
        $b, $TEST_XS_BETA)
    SUITE["Hooks"]["Beta"]["ccdf_ad_safe"] = @benchmarkable ccdf_ad_safe.(
        $b, $TEST_XS_BETA)
    SUITE["Hooks"]["Beta"]["logccdf_ad_safe"] = @benchmarkable logccdf_ad_safe.(
        $b, $TEST_XS_BETA)
    SUITE["Hooks"]["Beta"]["pdf_ad_safe"] = @benchmarkable pdf_ad_safe.(
        $b, $TEST_XS_BETA)

    # Generic fall-through: a Normal has no bespoke method, so each hook
    # collapses to the stock Distributions function.
    n = Normal(1.0, 0.5)
    SUITE["Hooks"]["Normal (fall-through)"] = BenchmarkGroup()
    SUITE["Hooks"]["Normal (fall-through)"]["cdf_ad_safe"] = @benchmarkable cdf_ad_safe.($n, $TEST_XS)
    SUITE["Hooks"]["Normal (fall-through)"]["logcdf_ad_safe"] = @benchmarkable logcdf_ad_safe.($n, $TEST_XS)
    SUITE["Hooks"]["Normal (fall-through)"]["pdf_ad_safe"] = @benchmarkable pdf_ad_safe.($n, $TEST_XS)

    # The internal kernels the Gamma/Beta hooks share, scalar and broadcast.
    SUITE["Hooks"]["_gamma_cdf"] = BenchmarkGroup()
    SUITE["Hooks"]["_gamma_cdf"]["scalar"] = @benchmarkable _gamma_cdf(
        2.0, 1.0, 3.0)
    SUITE["Hooks"]["_gamma_cdf"]["broadcast"] = @benchmarkable _gamma_cdf.(
        2.0, 1.0, $TEST_XS)

    SUITE["Hooks"]["_beta_cdf"] = BenchmarkGroup()
    SUITE["Hooks"]["_beta_cdf"]["scalar"] = @benchmarkable _beta_cdf(
        2.0, 1.0, 0.3)
    SUITE["Hooks"]["_beta_cdf"]["broadcast"] = @benchmarkable _beta_cdf.(
        2.0, 1.0, $TEST_XS_BETA)
end
