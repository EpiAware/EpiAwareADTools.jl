# PACKAGE-OWNED — a standards check this package keeps for itself.
#
# Standard 8 of the EpiAware Julia package standards: a comment, a docstring
# or a docs page carries no issue or pull request numbers, because a number
# in the source is a second copy of this repository's own record and it is
# the copy that rots. A pointer to ANOTHER project's tracker is not that, and
# no `git blame` here holds it, so a citation is allowed when it names the
# repository it belongs to.

@testitem "Quality: no own-repo issue references" tags = [:quality] begin
    root = normpath(joinpath(@__DIR__, "..", ".."))
    trees = ["src", "ext", "test", joinpath("docs", "src")]

    # An own-repo citation, attached to this package's name: never allowed.
    own_repo = r"EpiAwareADTools(\.jl)?#\d+"
    # Any hash-and-number. Allowed only when qualified by a
    # repository, either attached to it directly or named on the same or
    # the previous line.
    citation = r"#\d+"
    attached = r"[A-Za-z0-9_.]$"
    qualifier = r"""
        [A-Za-z][A-Za-z0-9_]*\.jl |
        github\.com |
        \bkit\b |
        ComposedDistributions |
        DistributionsInference |
        SpecialFunctions |
        Mooncake |
        EpiAwarePackageTools
    """x

    # Files the kit owns and rewrites on sync carry the kit's own record,
    # which is a cross-repo reference from here.
    managed = r"MANAGED by EpiAwarePackageTools|Force-managed"

    sources = String[]
    for tree in trees
        for (dir, _, files) in walkdir(joinpath(root, tree))
            for f in files
                endswith(f, ".jl") || endswith(f, ".md") || continue
                push!(sources, joinpath(dir, f))
            end
        end
    end

    offences = String[]
    for path in sources
        text = read(path, String)
        occursin(managed, text) && continue
        rel = relpath(path, root)
        lines = split(text, '\n')
        for (i, line) in pairs(lines)
            previous = i > 1 ? lines[i - 1] : ""
            context = line * "\n" * previous
            for m in eachmatch(citation, line)
                before = line[1:prevind(line, m.offset)]
                is_own = occursin(own_repo, before * m.match)
                qualified = !is_own && (
                    occursin(attached, before) || occursin(qualifier, context)
                )
                qualified && continue
                push!(offences, "$rel:$i: $(strip(line))")
            end
        end
    end

    if !isempty(offences)
        @info "unqualified issue references (standard 8)" offences
    end
    @test isempty(offences)
end
