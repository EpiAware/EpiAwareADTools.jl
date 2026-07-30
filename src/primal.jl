@doc """
Strip any AD wrapper (ForwardDiff `Dual`, ReverseDiff `TrackedReal`,
Enzyme/Mooncake duals) from a scalar, returning its underlying primal value.

The generic method is the identity on a plain real, so a non-AD call keeps the
value's own float type (e.g. `Float32`). The per-backend extensions add the
unwrapping methods: `EpiAwareADToolsForwardDiffExt` and
`EpiAwareADToolsReverseDiffExt` supply value-reading methods, while
`EpiAwareADToolsChainRulesCoreExt` marks `primal` `@non_differentiable`,
`EpiAwareADToolsEnzymeExt` marks it `EnzymeRules.inactive`, and
`EpiAwareADToolsMooncakeExt` gives it a `@zero_derivative` rule. Together these
keep a non-differentiable hyperparameter — for example a quadrature window
endpoint, which is just *where* to integrate — off the AD path on every
backend.

Containers strip elementwise and recursively, so a nesting of them bottoms out
at a scalar method. `Tuple` covers the nested per-component parameter tuples a
composite distribution returns from `params`, which is what lets
[`primal_distribution`](@ref), and any caller mapping `primal` over `params(d)`,
handle a component whose parameter is itself a tuple. `AbstractArray` covers a
vector-valued hyperparameter such as a grid of integration nodes, and returns a
new container rather than stripping in place.

This is the sanctioned replacement for the underscore-prefixed `_primal` that
ConvolvedDistributions.jl and CensoredDistributions.jl each carry internally;
it stays hosted here until those packages depend on it directly.

# Arguments
- `x`: the value to strip; a plain real is returned unchanged, a tuple or array
  is stripped elementwise into a new container of the same shape.

# Examples
```@example
using EpiAwareADTools

primal(3.0), primal(((1.0, 2.0), 3.0)), primal([1.0, 2.0])
```
"""
primal(x::Real) = x

primal(t::Tuple) = map(primal, t)

primal(a::AbstractArray) = map(primal, a)

@doc """
Rebuild a distribution with its parameters stripped to their primal values via
the type's positional constructor.

`params(d)` round-trips through the constructor for the Distributions.jl
families used here, so mapping [`primal`](@ref) over the parameters and calling
the wrapper constructor reconstructs the distribution with plain (AD-stripped)
parameters. The `check_args = false` keyword is intentionally not passed: the
original distribution already validated its parameters and the primal copy uses
the identical values. Reconstructing from primal parameters is what lets a
downstream package evaluate a non-differentiable quantity (such as a
quadrature-window quantile) on an integration component without live `Dual` or
`TrackedReal` parameters flowing into it.

# Arguments
- `d`: the univariate distribution to rebuild from primal parameters.

# Examples
```@example
using EpiAwareADTools, Distributions

primal_distribution(Gamma(2.0, 1.0))
```
"""
function primal_distribution(d::UnivariateDistribution)
    D = Base.typename(typeof(d)).wrapper
    return D(map(primal, params(d))...)
end
