# [Reparameterisation trick: `fixed_draw` / `ad_eltype`](@id reparameterisation)

## The problem

Taking a gradient of a quantity computed from random draws only makes sense if the draws are held fixed and only the parameters vary; otherwise the derivative is meaningless rather than merely noisy — the reparameterisation-trick, or common-random-numbers, discipline.
The package already owns the mirror-image half of it: [`primal`](@ref) and [`primal_distribution`](@ref) strip genuinely non-differentiable values off the tape while real parameters flow through.
The complementary half — deliberately pinning a set of draws as fixed realisations while promoting every parameter-dependent accumulator to the differentiated element type — was previously folk knowledge, re-implemented ad hoc wherever the pattern appears.
See [EpiAware/CensoredDistributions.jl#824](https://github.com/EpiAware/CensoredDistributions.jl/pull/824) for the motivating context this pair grew out of.

Both moves are easy to get subtly wrong by hand.
A draw that silently moves with the parameters, rather than staying fixed, makes the gradient simply wrong.
And an accumulator seeded at a plain `Float64` `zero`, or a buffer preallocated at `Float64`, works only until a differentiated term (a ForwardDiff `Dual`, a ReverseDiff `TrackedReal`) is combined with it.
At that point writing the wrapper into a concretely-`Float64`-typed slot raises a `MethodError`.

## The fix

[`fixed_draw`](@ref) pins a draw as a fixed, non-differentiated realisation by delegating to [`primal`](@ref): the identical strip mechanism, given a distinct name because the value frozen here is a REALISED DRAW rather than a structural hyperparameter.
Because it delegates directly, the existing per-backend `primal` marks (`@non_differentiable`, `EnzymeRules.inactive`, `@zero_derivative`) already cover it, so no new per-backend extension code is needed.

```@example reparameterisation
using EpiAwareADTools

z = fixed_draw(rand(3))
length(z)
```

`fixed_draw` only guards against an AD wrapper that survives the sampling step itself; it does NOT by itself implement the common-random-numbers discipline.
The draw must already be independent of the differentiated parameters — generated from their `primal` values, or before the parameters vary at all — or the resulting gradient is wrong rather than merely imprecise.

[`ad_eltype`](@ref) resolves the type a parameter-dependent accumulator should be seeded at, mirroring `primal`'s own `Real`/`Tuple`/`AbstractArray` dispatch: `typeof(x)` for a plain real, and the `promote_type` across a container's elements otherwise.
Mixing a differentiated parameter alongside a `fixed_draw` constant in the same container still resolves to the wider type:

```@example reparameterisation
T = ad_eltype(3.0)
total = sum(fixed_draw.([0.1, 0.4, 0.9]); init = zero(T))
```

Enzyme and Mooncake trace plain `Float64` code by source transformation rather than threading a wrapper type through the primal computation, so `ad_eltype` is a harmless no-op — always `Float64` — on those two backends.
It does the real work on ForwardDiff and ReverseDiff, where the differentiated parameter genuinely carries a different runtime type.
The full docstrings, including the buffer-seeding worked example, live on the [Public API](@ref public-api) page.

## Upstream target

`fixed_draw` shares [`primal`](@ref)'s target exactly, since it delegates to it directly: no single owner exists for a cross-backend "hold this constant" primitive.
`ad_eltype` has no upstream owner either: no shared AD-abstraction layer currently exposes a backend-agnostic "what type should a differentiated accumulator be" query.
Both entries are deleted once such primitives exist: `fixed_draw` alongside `primal`/`primal_distribution`, and `ad_eltype` once, for example, `DifferentiationInterface.jl` (or an equivalent shared abstraction) gains a backend-agnostic differentiated-eltype query.
