# Value-level unit tests for `logsumexp_stream` (EpiAwareADTools#39): the
# streaming log-sum-exp accumulator over an unbounded discrete support.
# Numerical agreement with `LogExpFunctions.logsumexp`, the run-based
# stopping rule, the degenerate-mass edge case, and the strict/non-strict
# non-convergence paths. Backend gradient coverage lives in the `:ad` items
# under `test/ad/` (the "logsumexp_stream" ADFixtures scenario).

@testitem "logsumexp_stream: exact agreement with LogExpFunctions.logsumexp on a fixed batch" begin
    using EpiAwareADTools: logsumexp_stream
    using LogExpFunctions: logsumexp

    fixed = [1.0, 2.0, 0.5, 3.0, -1.0, 2.2, 0.0, -3.5]
    n = length(fixed)
    # Force full consumption: `min_stable_terms` set one past `max_terms` so
    # the run-based stop can never fire before the hard cap, guaranteeing
    # every term in the batch is (and no more than that is) summed —
    # reproducing exactly what `logsumexp` computes over the same batch.
    result = logsumexp_stream(
        k -> fixed[k + 1]; max_terms = n, min_stable_terms = n + 1,
        strict = false)

    @test result.terms_used == n
    @test result.converged == false  # the hard cap, not the run rule, stopped it
    @test result.value ≈ logsumexp(fixed)
end

@testitem "logsumexp_stream: a geometric series matches its closed form" begin
    using EpiAwareADTools: logsumexp_stream

    # Σ_{k≥0} exp(-k) = 1 / (1 - exp(-1)); log of that is the closed-form
    # reference, independent of the streaming machinery under test.
    result = logsumexp_stream(k -> -Float64(k))
    @test result.converged
    @test result.value ≈ log(1 / (1 - exp(-1)))
end

@testitem "logsumexp_stream: magnitude extremes (1e+-300) match LogExpFunctions" begin
    using EpiAwareADTools: logsumexp_stream
    using LogExpFunctions: logsumexp

    # log(1e300) ~ 690.8, log(1e-300) ~ -690.8: a decreasing run of terms
    # starting near each extreme, forced to fully converge (min_stable_terms
    # comfortably inside max_terms) so the streaming value can be checked
    # exactly against a `logsumexp` of the consumed prefix.
    for offset in (690.0, -690.0)
        terms = [offset - k for k in 0:200]
        result = logsumexp_stream(
            k -> terms[k + 1]; max_terms = 300, min_stable_terms = 10)
        @test result.converged
        @test isfinite(result.value)
        @test result.value ≈ logsumexp(terms[1:result.terms_used])
    end
end

@testitem "logsumexp_stream: stops only after a run of stable terms, not the first" begin
    using EpiAwareADTools: logsumexp_stream

    # A term sequence that dips to a tiny value once, then recovers to a
    # larger one, then decays for good: a first-negligible-term rule would
    # truncate right after the dip and miss the later, larger contribution.
    seq = [0.0, -50.0, 3.0, -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0,
        -9.0, -10.0, -11.0, -12.0, -13.0, -14.0, -15.0]
    result = logsumexp_stream(
        k -> k < length(seq) ? seq[k + 1] : -100.0 - Float64(k);
        atol = 1e-9, min_stable_terms = 5, max_terms = 200)

    @test result.converged
    # The recovered term (index 2, value 3.0) must be included: the total
    # must exceed what summing only the first two terms would give.
    @test result.value > 3.0
end

@testitem "logsumexp_stream: an all-(-Inf) series (no mass) converges to -Inf" begin
    using EpiAwareADTools: logsumexp_stream

    # Every term contributes zero mass: the running total is `-Inf` from
    # the first term on and must be recognised as immediately stable
    # (guards the `-Inf - (-Inf) == NaN` trap in the stability check).
    result = logsumexp_stream(k -> -Inf; max_terms = 50, min_stable_terms = 3)
    @test result.converged
    @test result.value == -Inf
end

@testitem "logsumexp_stream: raises by default when max_terms is reached without stabilising" begin
    using EpiAwareADTools: logsumexp_stream

    # A strictly increasing series never stabilises within any finite run.
    @test_throws ErrorException logsumexp_stream(
        k -> Float64(k); max_terms = 10, min_stable_terms = 3)
end

@testitem "logsumexp_stream: strict = false returns a partial result with converged = false" begin
    using EpiAwareADTools: logsumexp_stream

    result = logsumexp_stream(
        k -> Float64(k); max_terms = 10, min_stable_terms = 3, strict = false)
    @test result.converged == false
    @test result.terms_used == 10
    @test isfinite(result.value)
end

@testitem "logsumexp_stream: min_stable_terms/max_terms are validated eagerly" begin
    using EpiAwareADTools: logsumexp_stream

    @test_throws ArgumentError logsumexp_stream(
        k -> -Float64(k); min_stable_terms = 0)
    @test_throws ArgumentError logsumexp_stream(k -> -Float64(k); max_terms = 0)
end
