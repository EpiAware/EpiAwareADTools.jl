# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Package-specific configuration read by the managed `make.jl`. It drives the
# Literate.jl tutorial pipeline and the README/index link rewrites, and lists
# the linkcheck URLs to ignore. The defaults below build a site with no
# tutorials, so a fresh package needs no edits here; fill these in as the docs
# grow. CensoredDistributions.jl's `docs/make.jl` is a worked example of the
# values these consts take.

# Tutorial source `.jl` files (Literate scripts) under `TUTORIALS_SUBDIR`.
#
# Light tutorials emit `@example` blocks that Documenter runs in-process; keep
# cheap tutorials here.
const LIGHT_TUTORIALS = String[]

# Heavy tutorials (live MCMC fits, multi-backend AD, plotting) are each
# executed once in a fresh subprocess so native/memory state cannot accumulate.
const HEAVY_TUTORIALS = String[]

# Where the tutorial `.jl` sources and rendered `.md` pages live, relative to
# `docs/src`.
const TUTORIALS_SUBDIR = joinpath("getting-started", "tutorials")

# Fast-build stubs (`--skip-notebooks`): `"file.md" => "# Heading"` pairs. The
# heading should preserve the tutorial's `@id` (e.g.
# `"# [Title](@id my-anchor)"`) so cross-references from other pages still
# resolve in a fast build.
const TUTORIAL_STUBS = Pair{String, String}[]

# Heavy tutorials that always render from their `TUTORIAL_STUBS` heading and
# never execute, independent of `--skip-notebooks` — the escape hatch for a
# heavy tutorial with a problem of its own (e.g. a model that does not
# terminate in reasonable time), so it need not block its siblings from
# running for real. Leave empty; every heavy tutorial with no such problem
# should execute.
const FORCE_STUB_TUTORIALS = String[]

# Regexes for URLs to skip during the (full-build) linkcheck, e.g. a page
# published by a separate workflow that is not yet live. The stable docs site
# does not exist until the first deploy, and Discussions is off until enabled
# on the repo, so both self-links are ignored (mirrors ConvolvedDistributions).
const LINKCHECK_IGNORE = [
    r"epiaware\.org/EpiAwareADTools\.jl/stable",
    r"github\.com/EpiAware/EpiAwareADTools\.jl/discussions"
]

# README -> index.md link rewrites: `from => to` pairs applied line by line,
# e.g. rewriting an absolute docs URL to an in-site `@ref` so links stay within
# the built version.
const INDEX_REWRITES = Pair{String, String}[]

# Whether README ```julia blocks become runnable `@example readme` blocks on the
# generated home page. Keep `true` when the README's examples are real, runnable
# code; set `false` when they are illustrative (placeholder names) and must not
# execute.
const README_EXECUTE = true

# README headings whose whole section (heading + body, up to the next heading
# of the same or a higher level) is dropped when generating the home page. The
# managed badge block is always stripped via its `<!-- badges:start/end -->`
# markers; this list is the package-owned hook for omitting any OTHER named
# section from the home page (the managed build hardcodes none). Leave empty to
# keep the whole README — content tables and all.
const INDEX_STRIP_SECTIONS = String[]

# Whether the build generates the benchmark page (`src/benchmarks.md`): the
# package-owned `docs/benchmarks.md` prose hook plus the rendered performance
# history (the timeline published to the repo's `benchmarks` branch). Defaults
# to the `benchmarks` flag the package was scaffolded with; `false` drops the
# page and `make.jl` also omits its `pages.jl` nav entry.
const BENCHMARK_PAGE = true

# ---------------------------------------------------------------------------
# TEMPORARY WORKAROUND — remove once the empty-anchor header is fixed and
# DocumenterVitepress skips (rather than aborts on) inventory entries whose
# anchor id is empty. On CI deploy builds the vitepress inventory writer
# crashes the whole docs build with `ArgumentError: `name` must have non-zero
# length` when an anchored header has an empty anchor id — which the rendered
# `## Performance history` benchmark table can produce. Overwrite that one
# writer method with a copy whose inventory push is guarded: an empty id logs
# the page and heading (so the culprit is identifiable in the CI log) and skips
# the entry. Tracked upstream in EpiAwarePackageTools#204 (see also
# ConvolvedDistributions.jl#52, which carries the same override).
import Documenter
import DocumenterVitepress

function DocumenterVitepress.render(io::IO, mime::MIME"text/plain",
        node::Documenter.MarkdownAST.Node, header::Documenter.AnchoredHeader,
        page, doc; kwargs...)
    anchor = header.anchor
    id = replace(DocumenterVitepress.sanitized_anchor_label(anchor),
        " " => "-")
    heading = first(node.children)
    println(io)
    print(io, "#"^(heading.element.level), " ")
    heading_iob = IOBuffer()
    DocumenterVitepress.render(heading_iob, mime, node, heading.children,
        page, doc; kwargs...)
    heading_text = rstrip(String(take!(heading_iob)))
    print(io, heading_text)
    print(io, " {#$(id)}")
    if haskey(kwargs, :inventory)
        if isempty(anchor.id)
            @warn "Skipping inventory entry: anchored header has an empty "*
            "anchor id" page=page.source heading=heading_text
        else
            item = DocumenterVitepress.InventoryItem(
                name = anchor.id,
                domain = "std",
                role = "label",
                dispname = DocumenterVitepress._get_inventory_dispname(
                    anchor.id, Documenter.MDFlatten.mdflatten(anchor.node)),
                priority = -1,
                uri = DocumenterVitepress._get_inventory_uri(doc, page, id)
            )
            push!(kwargs[:inventory], item)
        end
    end
    println(io)
end
