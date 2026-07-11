# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# QA configuration values the managed `quality.jl` testset reads. Fill in the
# package-specific inputs the shared helpers need; the standard testset logic
# stays in `quality.jl` (managed). Edit freely.

using EpiAwareADTools

const QA_CONFIG = (
    # The module under test.
    mod = EpiAwareADTools,

    # Path to the isolated JET environment (see test/jet/Project.toml).
    jet_env = joinpath(@__DIR__, "..", "jet"),

    # Per-check Aqua relaxations, e.g. (; ambiguities = false). Empty = all on.
    aqua = (;),

    # ExplicitImports `ignore`: symbols an extension legitimately imports
    # non-publicly. When the extension-ambiguity item has already loaded
    # ForwardDiffExt into the session, the public-imports walk inspects the
    # extension too, which imports its parent's gamma internals plus
    # ForwardDiff's Dual plumbing — the standard extension pattern.
    ei_ignore = (:Dual, :value, :partials, :_gamma_cdf,
        :_gamma_cdf_value_and_partials),

    # Docstring `crossref_ignore`: upstream names docstrings link to via
    # `[`name`](@ref)`, e.g. (:pdf, :cdf, :logpdf).
    crossref_ignore = (),

    # Extra docstring-format options, e.g.
    # (; exported_only_examples = true, require_field_docs = true).
    docstring = (;),

    # README section-structure check. `path` is the package root (its
    # README.md). Override `required`/`order` to extend or relax the standard
    # section set, e.g.
    #   (; required = vcat(STANDARD_README_SECTIONS, [("Benchmarks",)]))
    # Empty `(;)` uses the standard structure in standard order.
    readme = (; path = joinpath(@__DIR__, "..", "..")),

    # Package extensions to ambiguity-check. Each entry:
    #   (; name = :MyPkgSomeTriggerExt,
    #      triggers = ("SomeTrigger",),       # packages to load first
    #      prefixes = ("MyPkg", "SomeTrigger"),
    #      expect_phantoms = false,    # true if a third party adds phantoms
    #      broken = false)             # true to quarantine a known ambiguity
    # Only extensions whose triggers are main-test-env deps are listed; the
    # ChainRulesCore / Enzyme / Mooncake / ReverseDiff extensions are exercised
    # by the dedicated AD harness (test/ad), which proves gradient correctness
    # directly.
    extensions = (
    # The partial-Dual `_gamma_cdf` overload set: the unparametrised `Dual`
    # slots keep the "at least one Dual" space unambiguous (a shared-tag
    # parametrisation leaves the mixed-tag intersections uncovered and flags
    # all six partial pairs).
        (; name = :EpiAwareADToolsForwardDiffExt,
        triggers = ("ForwardDiff",),
        prefixes = ("EpiAwareADTools", "ForwardDiff", "Distributions")),
    )
)
