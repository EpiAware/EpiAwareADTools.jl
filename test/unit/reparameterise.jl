# Value-level unit tests for the reparameterisation-trick helper pair:
# `fixed_draw` pins a draw as a constant realisation, `ad_eltype` resolves the
# type a parameter-dependent accumulator should be seeded at. `fixed_draw`
# delegates to `primal`, so its container contract is already pinned by
# `test/unit/primal.jl`; these tests cover the delegation itself plus the
# buffer footgun `ad_eltype` exists to avoid. Backend gradient coverage lives
# in the `:ad` scenarios under `test/ad/` (the "fixed_draw pinned realisation"
# / "ad_eltype seeds a differentiable buffer" ADFixtures scenarios).

@testitem "fixed_draw is the identity on a real and keeps its type" begin
    using EpiAwareADTools: fixed_draw

    @test fixed_draw(3.0) === 3.0
    @test fixed_draw(3.0f0) === 3.0f0
    @test fixed_draw(3) === 3
end

@testitem "fixed_draw strips a Dual draw to its primal value" begin
    using EpiAwareADTools: fixed_draw
    using ForwardDiff: Dual, value

    d = Dual(2.5, 1.0)
    z = fixed_draw(d)
    @test z === value(d)
    @test z isa Float64
end

@testitem "fixed_draw pins a container of draws elementwise" begin
    using EpiAwareADTools: fixed_draw

    @test fixed_draw([0.1, 0.4, 0.9]) == [0.1, 0.4, 0.9]
    @test fixed_draw((0.1, 0.4)) === (0.1, 0.4)
end

@testitem "ad_eltype resolves a plain real's own type" begin
    using EpiAwareADTools: ad_eltype

    @test ad_eltype(3.0) === Float64
    @test ad_eltype(3.0f0) === Float32
    @test ad_eltype(3) === Int
    @test zero(ad_eltype(3.0)) === 0.0
end

@testitem "ad_eltype promotes across a Tuple's element types" begin
    using EpiAwareADTools: ad_eltype

    @test ad_eltype((1.0, 2)) === Float64
    @test ad_eltype((1.0f0, 2.0)) === Float64
end

@testitem "ad_eltype resolves an AbstractArray's promoted element type" begin
    using EpiAwareADTools: ad_eltype

    @test ad_eltype([1.0, 2.0]) === Float64
    # A heterogeneous `Any`-eltype array still promotes via its elements.
    @test ad_eltype(Any[1.0, 2]) === Float64
    # An empty array has no elements to inspect, so falls back to its own
    # declared eltype.
    @test ad_eltype(Float64[]) === Float64
end

@testitem "ad_eltype resolves a Dual's own wrapper type" begin
    using EpiAwareADTools: ad_eltype
    using ForwardDiff: Dual

    d = Dual(2.0, 1.0)
    @test ad_eltype(d) === typeof(d)
    @test ad_eltype([d, Dual(1.0, 0.0)]) === typeof(d)
end

@testitem "ad_eltype seeds a buffer a plain Float64 zero cannot hold" begin
    using EpiAwareADTools: ad_eltype
    using ForwardDiff: Dual

    θ = [Dual(2.0, 1.0), 1.5]

    # The footgun `ad_eltype` exists to avoid: a `Vector{Float64}` cannot
    # hold a `Dual` written into it, so seeding a buffer at the wrong type
    # errors as soon as a differentiated term is combined with it.
    bad_buf = Vector{Float64}(undef, 1)
    @test_throws MethodError bad_buf[1] = θ[1] * 0.5 + θ[2]

    # Seeded at `ad_eltype(θ)`, the same write succeeds and carries the
    # derivative through.
    good_buf = Vector{ad_eltype(θ)}(undef, 1)
    good_buf[1] = θ[1] * 0.5 + θ[2]
    @test good_buf[1] == θ[1] * 0.5 + θ[2]
end
