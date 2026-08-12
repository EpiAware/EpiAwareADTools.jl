# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Package-specific configuration read by the managed `make.jl`: the
# Literate.jl tutorial pipeline, README/index link rewrites, and linkcheck
# ignore list.

# Tutorial source `.jl` files (Literate scripts) under `TUTORIALS_SUBDIR`.
# Light tutorials emit `@example` blocks Documenter runs in-process; keep
# cheap tutorials here.
const LIGHT_TUTORIALS = String[]

# Heavy tutorials (live MCMC fits, multi-backend AD, plotting) each run once
# in a fresh subprocess so native/memory state cannot accumulate. The
# `ad-backends.jl` page itself is kit-managed; only this registration is
# package-owned. Its `ad-comparison.jl` sibling is registered in
# `HEAVY_BENCHMARKS` below.
const HEAVY_TUTORIALS = ["ad-backends.jl"]

# Where tutorial `.jl` sources and rendered `.md` pages live, relative to
# `docs/src`.
const TUTORIALS_SUBDIR = joinpath("getting-started", "tutorials")

# Fast-build stubs (`--skip-notebooks`): `"file.md" => "# Heading"` pairs.
# Preserve the tutorial's `@id` in the heading so cross-references still
# resolve in a fast build.
const TUTORIAL_STUBS = Pair{String, String}[
    "ad-backends.md" =>
        "# [Automatic differentiation backends](@id ad-backends)",
]

# Heavy tutorials that always render from their `TUTORIAL_STUBS` heading and
# never execute, independent of `--skip-notebooks` — the escape hatch for a
# tutorial with its own problem. Leave empty; every heavy tutorial without
# such a problem should execute.
const FORCE_STUB_TUTORIALS = String[]

# The `docs/src/benchmarks/` Literate pipeline: its own heavy list and stubs,
# mirroring `HEAVY_TUTORIALS`/`TUTORIAL_STUBS` above but rooted at
# `docs/src/benchmarks`, so the AD-comparison report gets its own top-level
# "Benchmarks" nav group. The page itself is kit-managed; only this
# registration is package-owned.
const HEAVY_BENCHMARKS = ["ad-comparison.jl"]

# Fast-build stubs for `HEAVY_BENCHMARKS`, same convention as
# `TUTORIAL_STUBS`.
const BENCHMARK_STUBS = Pair{String, String}[
    "ad-comparison.md" => "# [AD backend comparison](@id ad-comparison)",
]

# This is an EpiAware org package: advertise it as part of the ecosystem in
# the README and the docs footer.
const ORG_BRANDING = true

# Regexes for URLs to skip during the (full-build) linkcheck. The stable docs
# site does not exist until the first deploy, and Discussions is off until
# enabled on the repo, so both self-links are ignored (mirrors
# ConvolvedDistributions).
const LINKCHECK_IGNORE = [
    r"^https://epiawareadtools\.epiaware\.org/stable",
    r"github\.com/EpiAware/EpiAwareADTools\.jl/discussions",
]

# README -> index.md link rewrites: `from => to` pairs applied line by line,
# e.g. rewriting an absolute docs URL to an in-site `@ref`.
const INDEX_REWRITES = Pair{String, String}[]

# README ```julia blocks become runnable `@example readme` blocks on the
# generated home page; the README's examples are real, runnable code.
const README_EXECUTE = true

# README headings whose whole section is dropped from the home page. The
# managed badge block is always stripped via its markers; leave empty to keep
# the whole README.
const INDEX_STRIP_SECTIONS = String[]

# Whether the build generates the benchmark page
# (`src/benchmarks/over-time.md`): the package-owned `docs/benchmarks.md`
# prose hook plus a summary table, trend plot, and one section per suite,
# rendered from the `benchmarks` branch timeline.
const BENCHMARK_PAGE = true

# Headline benchmark suites to keep on the performance-history page. Empty
# keeps every suite.
const HISTORY_SUITES = String[]

# How many of the most-recent revisions (columns) to show in the overall
# summary and history ratio table.
const HISTORY_COMMITS = 5

# Ratio at or above which a suite's `Status` flags "⚠ reg" on the
# performance-history page.
const HISTORY_REGRESSION_THRESHOLD = 1.1

# --- docs/pages.jl extension points ----------------------------------------
#
# `docs/pages.jl` is MANAGED: `scaffold`/`update` regenerate it in full on
# every run, owning group labels, ordering and placement. Add nav content
# here instead of editing `pages.jl` directly.

# The package's own Getting-started pages, listed right after Overview and
# the FAQ in the generated nav.
const PACKAGE_TUTORIALS = Pair{String, String}[
    "Installation" => "getting-started/installation.md",
]

# Extra top-level nav groups the package owns, spliced in after "Benchmarks"
# and before "Development". One page per tool family, plus the charter page
# listing each entry's upstream target and deletion condition.
const PACKAGE_SECTIONS = Pair{String, Any}[
    "Tools" => [
        "Charter and status" => "tools/index.md",
        "Tape-strip: primal" => "tools/tape-strip.md",
        "User-facing opt-out: nondifferentiable" =>
            "tools/nondifferentiable.md",
        "AD-safe evaluation hooks" => "tools/ad-safe-hooks.md",
        "Gamma-CDF derivative" => "tools/gamma-cdf.md",
        "Beta-CDF derivative" => "tools/beta-cdf.md",
        "xlogy/xlog1py Mooncake rules" => "tools/xlogy.md",
        "Streaming log-sum-exp: logsumexp_stream" =>
            "tools/logsumexp-stream.md",
        "Reparameterisation trick: fixed_draw/ad_eltype" =>
            "tools/reparameterisation.md",
    ],
]

# The one package-specific leaf in the managed "Development" group's fixed
# skeleton (Overview, Contributing, this leaf, Release process, Developer
# FAQ).
const DEVELOPMENT_EXTEND_PAGE =
    "Adding a workaround" => "developer/adding-a-tool.md"

# The Getting-started FAQ page, listed right after Overview.
const GETTING_STARTED_FAQ = "getting-started/faq.md"
