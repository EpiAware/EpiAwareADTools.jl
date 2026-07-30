# Value-level unit tests for `primal`'s container contract. The per-backend
# strip methods and non-differentiability marks are pinned by the `:ad` items
# in `test/ad/primal.jl`; these pin what `primal` accepts and returns with no
# AD backend loaded.

@testitem "primal is the identity on a real and keeps its type" begin
    using EpiAwareADTools: primal

    @test primal(3.0) === 3.0
    @test primal(3.0f0) === 3.0f0
    @test primal(3) === 3
end

@testitem "primal strips containers elementwise and recursively" begin
    using EpiAwareADTools: primal

    @test primal((1.0, 2.0)) === (1.0, 2.0)
    @test primal(((1.0, 2.0), 3.0)) === ((1.0, 2.0), 3.0)
    # Arrays strip into a new container of the same shape, so a
    # vector-valued hyperparameter (a grid of integration nodes) is covered.
    @test primal([1.0, 2.0]) == [1.0, 2.0]
    @test primal([1.0 2.0; 3.0 4.0]) == [1.0 2.0; 3.0 4.0]
    @test size(primal([1.0 2.0; 3.0 4.0])) == (2, 2)
    @test primal(0.0:0.5:1.0) == [0.0, 0.5, 1.0]
    # Containers nest in either order.
    @test primal([(1.0, 2.0), (3.0, 4.0)]) == [(1.0, 2.0), (3.0, 4.0)]
    @test primal(([1.0, 2.0], 3.0)) == ([1.0, 2.0], 3.0)
end
