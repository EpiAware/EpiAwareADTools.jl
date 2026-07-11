# Unit coverage for the tape-strip pair. `primal` must (a) reduce each backend's
# AD wrapper to its underlying value and (b) carry no gradient, so a quantity
# routed through it is a non-differentiated constant on every backend. These
# pin the per-backend strip methods and non-differentiability marks the
# extensions install.

@testitem "primal strips a ForwardDiff Dual" tags=[:ad, :forwarddiff] begin
    using ForwardDiff: ForwardDiff, Dual
    using EpiAwareADTools: primal

    d = Dual{:tag}(3.0, 1.0)
    @test primal(d) === 3.0
    # Nested Dual reduces all the way to the scalar value.
    d2 = Dual{:outer}(Dual{:inner}(2.5, 1.0), Dual{:inner}(0.0, 0.0))
    @test primal(d2) === 2.5
end

@testitem "primal strips a ReverseDiff TrackedReal" tags=[
    :ad, :reversediff] begin
    using ReverseDiff: ReverseDiff, TrackedReal
    using EpiAwareADTools: primal

    tape = ReverseDiff.InstructionTape()
    t = TrackedReal(4.2, 0.0, tape)
    @test primal(t) === 4.2
end

@testitem "primal_distribution strips Dual params" tags=[
    :ad, :forwarddiff] begin
    using ForwardDiff: Dual
    using Distributions: Gamma, params
    using EpiAwareADTools: primal_distribution

    d = Gamma(Dual{:t}(2.0, 1.0), Dual{:t}(1.5, 0.0))
    p = primal_distribution(d)
    @test p isa Gamma{Float64}
    @test params(p) === (2.0, 1.5)
end

@testitem "primal carries no gradient (ForwardDiff)" tags=[
    :ad, :forwarddiff] begin
    using ADTypes: AutoForwardDiff
    using DifferentiationInterface: gradient
    using EpiAwareADTools: primal

    g(v) = 2 * v[1] + 3 * primal(v[1])
    @test gradient(g, AutoForwardDiff(), [1.5]) ≈ [2.0]
end

@testitem "primal carries no gradient (ReverseDiff)" tags=[
    :ad, :reversediff] begin
    using ADTypes: AutoReverseDiff
    using DifferentiationInterface: gradient
    using EpiAwareADTools: primal

    g(v) = 2 * v[1] + 3 * primal(v[1])
    @test gradient(g, AutoReverseDiff(compile = false), [1.5]) ≈ [2.0]
end

@testitem "primal carries no gradient (Mooncake)" tags=[
    :ad, :mooncake, :mooncake_reverse] begin
    using ADTypes: AutoMooncake
    using DifferentiationInterface: gradient
    using EpiAwareADTools: primal

    g(v) = 2 * v[1] + 3 * primal(v[1])
    @test gradient(g, AutoMooncake(config = nothing), [1.5]) ≈ [2.0]
end

@testitem "primal carries no gradient (Enzyme)" tags=[
    :ad, :enzyme, :enzyme_reverse] begin
    using ADTypes: AutoEnzyme
    using DifferentiationInterface: gradient
    using Enzyme: Enzyme
    using EpiAwareADTools: primal

    g(v) = 2 * v[1] + 3 * primal(v[1])
    @test gradient(
        g, AutoEnzyme(mode = Enzyme.set_runtime_activity(Enzyme.Reverse)),
        [1.5]) ≈ [2.0]
end
