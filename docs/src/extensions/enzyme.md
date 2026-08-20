# [Enzyme extension](@id ext-enzyme)

`EpiAwareADToolsEnzymeExt` loads when `Enzyme` is loaded alongside `EpiAwareADTools`.
It is the only extension that writes its rules directly against a backend's own rule interface rather than lifting ChainRules, because Enzyme does not read ChainRules rules.

## What it registers

Two inactivity marks:

```julia
EnzymeRules.inactive(::typeof(primal), args...) = nothing
EnzymeRules.inactive(::NonDifferentiable, args...) = nothing
```

The first keeps the [tape-strip](@ref tape-strip) constant: Enzyme runs the primal call unchanged and contributes no tangent and no cotangent.
`inactive` covers every activity, batch-width and mode permutation at once.
The second gives the same treatment to any instance of the [`nondifferentiable`](@ref nondifferentiable) wrapper.
Dispatch matches on the wrapper's own unparametrised type, so one registration covers every wrapped function, closures included.

Three `EnzymeRules.@easy_rule` registrations, one per internal CDF primitive:

- `_gamma_cdf(k, θ, x)`, with `(dk, dθ, dx)` from `_gamma_cdf_value_and_partials`.
- `_gamma_logccdf(k, θ, x)`, from `_gamma_logccdf_value_and_partials`.
- `_beta_cdf(α, β, x)`, from `_beta_cdf_value_and_partials`.

Each macro expands into the reverse-mode `augmented_primal`/`reverse` pair and the forward-mode `forward` rule together.
The partials come from the same helpers the [ChainRulesCore extension](@ref ext-chain-rules-core) uses, so the formulas are shared rather than restated.

One rule for a function this package does not own:

```julia
EnzymeRules.@easy_rule(gamma(x::Real), (Ω * digamma(x),))
```

## What fails without it

Routing the CDF primitives through explicit rules is what stops Enzyme differentiating `SpecialFunctions.gamma_inc` and `beta_inc` directly.
Those have no shape derivative to find, so an unloaded extension turns a Gamma or Beta CDF differentiated in its parameters into a failed or wrong gradient.

The `gamma` rule fixes a separate, quieter problem.
Enzyme's own `EnzymeSpecialFunctionsExt` ships no `gamma` rule and mis-lowers `gamma(x)` to the `loggamma` known operation, returning `ψ(x)` where the derivative is `Γ(x) ψ(x)`.
That is wrong by a factor of `Γ(x)` in both modes, and it is an upstream Enzyme bug.
It reaches this package because `_gamma_cdf_value_and_partials` calls `pdf(Gamma(...))`, which uses `gamma` outside the `_gamma_cdf` rule.
The `_beta_cdf` path is not exposed to it, since Enzyme never traces into that helper.

Without the two `inactive` marks, Enzyme differentiates through `primal` and through a wrapped `nondifferentiable` call, which is exactly what both exist to prevent.
As on the other backends, an inactive call also zeroes the contribution of a value a wrapped closure captured rather than received as an argument.

## Upstream target

The three CDF rules are deleted once `SpecialFunctions.jl` carries complete `ChainRule`s for `gamma_inc` ([issue #531](https://github.com/JuliaMath/SpecialFunctions.jl/issues/531)) and `beta_inc` and Enzyme picks up correct derivatives for them.
The `gamma` rule is deleted once Enzyme stops lowering `gamma` through `loggamma`.
The two `inactive` marks go once a shared cross-backend stop-gradient primitive exists.
