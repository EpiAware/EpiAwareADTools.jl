# The reparameterisation-trick / common-random-numbers complement to the
# tape-strip pair (EpiAwareADTools#38, part of the AD/numerics epic #35).
# Differentiating a quantity built from a random draw only makes sense when
# the draw is held fixed while the parameters vary against it; otherwise the
# derivative is meaningless rather than merely noisy. `primal` already
# strips a genuinely non-differentiable hyperparameter off the tape; this
# file gives the matching pair for the OTHER direction: pin a draw as a
# fixed realisation (`fixed_draw`), and resolve the element type a
# parameter-dependent accumulator should be seeded at so a derivative
# threaded through it is not silently severed (`ad_eltype`).

@doc """
Pin a draw as a fixed, non-differentiated realisation for the
reparameterisation trick.

Differentiating a quantity built from a random draw only makes sense when
the draw is held fixed while the parameters vary against it — the
common-random-numbers discipline. `fixed_draw(x)` strips any AD wrapper
from `x` via [`primal`](@ref): the identical mechanism `primal` already
applies to a non-differentiable hyperparameter, given a distinct name here
because the value being frozen is a REALISED DRAW, not a structural
hyperparameter. It accepts exactly what `primal` does — a plain `Real`
(returned unchanged, keeping its own float type), or a `Tuple`/
`AbstractArray` of such, stripped elementwise and recursively — so a
single draw or a whole batch of them pins the same way.

CAUTION — `fixed_draw` only guards against an AD wrapper that survives the
sampling step itself (for example a distribution whose sampler reads its
`Dual`-valued bounds and returns a `Dual`). It does NOT by itself
implement the common-random-numbers discipline: the draw must already be
independent of the differentiated parameters — generated from their
`primal` values, or before the parameters vary at all — or the resulting
gradient is wrong rather than merely imprecise. See [`ad_eltype`](@ref)
for the matching half: the type a parameter-dependent accumulator
combined with a fixed draw should be seeded at.

# Arguments
- `x`: the draw, or a container of draws, to pin as a constant.

# Examples
```@example
using EpiAwareADTools

z = fixed_draw(rand(3))
length(z)
```

# See also
- [`primal`](@ref): the mirror-image tape-strip this delegates to
- [`ad_eltype`](@ref): the matching accumulator element-type resolver
"""
fixed_draw(x) = primal(x)

@doc """
Resolve the element type a parameter-dependent accumulator should be
seeded at, so a derivative threaded through it is not silently severed.

Accumulating a quantity that depends on differentiated parameters — for
example summing per-draw contributions against a set of
[`fixed_draw`](@ref) realisations — needs its running total, or any
buffer it is written into, to carry the parameters' own AD-wrapped type
from the FIRST term onward. Seeding it with a plain `Float64` `zero`, or
preallocating a buffer at `Float64`, works only until a differentiated
term is combined with it: ForwardDiff and ReverseDiff (tape mode) each
thread their own wrapper type (a `Dual`, a `TrackedReal`) through the live
computation, and writing that wrapper into a concretely-`Float64`-typed
slot raises a `MethodError` rather than quietly losing the derivative.

`ad_eltype(x)` returns the type to seed with: `typeof(x)` for a plain
`Real` (so `zero(ad_eltype(3.0)) === 0.0` when nothing is differentiated),
and the `promote_type` across a `Tuple`'s or `AbstractArray`'s elements
otherwise, so a caller mixing a differentiated parameter alongside a
`fixed_draw` constant in the same container still resolves to the wider,
differentiated type. Enzyme and Mooncake trace plain `Float64` code by
source transformation rather than threading a wrapper type through the
primal computation, so `ad_eltype` is a harmless no-op — always
`Float64` — on those two backends; it does the real work on ForwardDiff
and ReverseDiff, where the parameter genuinely carries a different
runtime type.

# Arguments
- `x`: the differentiated parameter(s): a `Real`, or a `Tuple`/
  `AbstractArray` of such (mixed types promoted to their common type).

# Examples
```@example
using EpiAwareADTools

T = ad_eltype(3.0)
total = zero(T)
for zi in fixed_draw.([0.1, 0.4, 0.9])
    total += zi
end
total
```

# See also
- [`fixed_draw`](@ref): the matching realisation-pinning half
- [`primal`](@ref): the tape-strip discipline `fixed_draw` reuses
"""
ad_eltype(x::Real) = typeof(x)

ad_eltype(t::Tuple) = promote_type(map(ad_eltype, t)...)

function ad_eltype(a::AbstractArray)
    isempty(a) && return eltype(a)
    return mapreduce(ad_eltype, promote_type, a)
end
