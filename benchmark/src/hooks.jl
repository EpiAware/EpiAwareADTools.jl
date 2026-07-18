# The five AD-safe evaluation hooks and the internal `_gamma_cdf` kernel.
#
# On a `Gamma` each hook routes through the analytic gamma-CDF path, so the
# `Hooks/Gamma` rows read against the bare `Baseline/Gamma` functions give the
# cost of the AD-safe detour on the primal (non-AD) call. On a `Normal` the
# generic method falls straight through to the stock Distributions function, so
# `Hooks/Normal` should sit on top of the corresponding baseline with no
# measurable overhead.

using EpiAwareADTools: _gamma_cdf

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

    # Generic fall-through: a Normal has no bespoke method, so each hook
    # collapses to the stock Distributions function.
    n = Normal(1.0, 0.5)
    SUITE["Hooks"]["Normal (fall-through)"] = BenchmarkGroup()
    SUITE["Hooks"]["Normal (fall-through)"]["cdf_ad_safe"] = @benchmarkable cdf_ad_safe.($n, $TEST_XS)
    SUITE["Hooks"]["Normal (fall-through)"]["logcdf_ad_safe"] = @benchmarkable logcdf_ad_safe.($n, $TEST_XS)
    SUITE["Hooks"]["Normal (fall-through)"]["pdf_ad_safe"] = @benchmarkable pdf_ad_safe.($n, $TEST_XS)

    # The internal kernel the Gamma hooks share, scalar and broadcast.
    SUITE["Hooks"]["_gamma_cdf"] = BenchmarkGroup()
    SUITE["Hooks"]["_gamma_cdf"]["scalar"] = @benchmarkable _gamma_cdf(
        2.0, 1.0, 3.0)
    SUITE["Hooks"]["_gamma_cdf"]["broadcast"] = @benchmarkable _gamma_cdf.(
        2.0, 1.0, $TEST_XS)
end
