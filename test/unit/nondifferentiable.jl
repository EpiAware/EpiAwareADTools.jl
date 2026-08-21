# Value-level unit tests for `nondifferentiable`, the user-facing
# differentiation opt-out. Non-AD value-level behaviour here (the wrapper
# returns the plain, primal-stripped result of calling `f`, and raises a clear
# error for a non-`primal`-strippable return type); backend gradient coverage —
# including the documented consequence for a closure that captures a live
# differentiated value — lives in the `:ad` items under `test/ad/` (the
# "nondifferentiable wrapped term" / "nondifferentiable array argument" /
# "nondifferentiable captured value" ADFixtures scenarios).

@testitem "nondifferentiable: calls f and returns its (already primal) value" begin
    using EpiAwareADTools: nondifferentiable

    f = nondifferentiable((x, y) -> x^2 + y)
    @test f(3.0, 1.0) == 3.0^2 + 1.0
end

@testitem "nondifferentiable: strips a Dual argument via primal before calling f" begin
    using EpiAwareADTools: nondifferentiable
    using ForwardDiff: Dual, value

    # `f` never sees a `Dual`: if it did, `x isa Real` (true for `Dual` too)
    # would not distinguish this, but `x == value(d)` (a plain `Float64`)
    # would only hold if the wrapper actually stripped it first.
    d = Dual(2.5, 1.0)
    captured = Ref{Any}(nothing)
    f = nondifferentiable(x -> (captured[] = typeof(x); x))
    result = f(d)
    @test captured[] == Float64
    @test result == value(d)
end

@testitem "nondifferentiable: a struct's own constructor is itself callable" begin
    using EpiAwareADTools: nondifferentiable
    import EpiAwareADTools: primal

    struct ADT37Grid
        lo::Float64
        hi::Float64
    end
    # A user-supplied `primal` method for their own struct (the same pattern
    # `primal_distribution` follows for `UnivariateDistribution`) is what
    # makes wrapping the constructor itself work end to end.
    primal(g::ADT37Grid) = ADT37Grid(primal(g.lo), primal(g.hi))

    frozen_ctor = nondifferentiable(ADT37Grid)
    grid = frozen_ctor(0.0, 1.0)
    @test grid isa ADT37Grid
    @test grid.lo == 0.0 && grid.hi == 1.0
end

@testitem "nondifferentiable: an array-bearing struct argument" begin
    using EpiAwareADTools: nondifferentiable
    import EpiAwareADTools: primal

    # The motivating example: the struct field is a `Vector`, so both the
    # argument and its own `primal` method need `primal(::AbstractArray)`.
    struct QuadratureGrid
        nodes::Vector{Float64}
    end
    primal(g::QuadratureGrid) = QuadratureGrid(primal(g.nodes))

    grid = QuadratureGrid(collect(0.0:0.5:5.0))
    weighted = nondifferentiable((g, w) -> sum(g.nodes) * w)
    @test weighted(grid, 2.0) == sum(grid.nodes) * 2.0

    # A bare array argument works the same way, no user `primal` method needed.
    @test nondifferentiable(sum)([1.0, 2.0, 3.0]) == 6.0
end

@testitem "nondifferentiable: a non-primal-strippable result raises a clear MethodError" begin
    using EpiAwareADTools: nondifferentiable, primal

    # `Real`, `Tuple` and `AbstractArray` are covered; a struct with no
    # `primal` method of its own is not.
    struct ADT37Opaque
        v::Float64
    end

    f = nondifferentiable(x -> ADT37Opaque(x))
    err = try
        f(1.0)
        nothing
    catch caught
        caught
    end
    @test err isa MethodError
    @test err.f === primal
end
