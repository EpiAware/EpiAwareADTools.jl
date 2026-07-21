# Bare Distributions evaluation: the floor the AD-safe hooks are read
# against. The `Gamma`/`Beta` hooks route through the analytic gamma-/beta-CDF
# machinery instead of these, so the gap to `Hooks/Gamma`/`Hooks/Beta` is the
# cost of the AD-safe path; the generic hooks fall straight through to these
# functions.

SUITE["Baseline"] = BenchmarkGroup()

let
    g = Gamma(2.0, 1.0)
    SUITE["Baseline"]["Gamma"] = BenchmarkGroup()
    SUITE["Baseline"]["Gamma"]["cdf"] = @benchmarkable cdf.($g, $TEST_XS)
    SUITE["Baseline"]["Gamma"]["logcdf"] = @benchmarkable logcdf.(
        $g, $TEST_XS)
    SUITE["Baseline"]["Gamma"]["ccdf"] = @benchmarkable ccdf.($g, $TEST_XS)
    SUITE["Baseline"]["Gamma"]["logccdf"] = @benchmarkable logccdf.(
        $g, $TEST_XS)
    SUITE["Baseline"]["Gamma"]["pdf"] = @benchmarkable pdf.($g, $TEST_XS)

    b = Beta(2.0, 1.0)
    SUITE["Baseline"]["Beta"] = BenchmarkGroup()
    SUITE["Baseline"]["Beta"]["cdf"] = @benchmarkable cdf.($b, $TEST_XS_BETA)
    SUITE["Baseline"]["Beta"]["logcdf"] = @benchmarkable logcdf.(
        $b, $TEST_XS_BETA)
    SUITE["Baseline"]["Beta"]["ccdf"] = @benchmarkable ccdf.($b, $TEST_XS_BETA)
    SUITE["Baseline"]["Beta"]["logccdf"] = @benchmarkable logccdf.(
        $b, $TEST_XS_BETA)
    SUITE["Baseline"]["Beta"]["pdf"] = @benchmarkable pdf.($b, $TEST_XS_BETA)
end
