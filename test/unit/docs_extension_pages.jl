# Guard for the docs Extensions nav group. The managed `docs/pages.jl`
# writes one Extensions entry per `[extensions]` declaration in
# Project.toml, pointing at a page under `docs/src/extensions/`, and
# Documenter silently drops any entry whose page is missing — a whole group
# can vanish from the built site with a green docs run. These items pin the
# pages to the nav so a missing or renamed file fails here instead.

@testitem "Docs: every Extensions nav page exists" begin
    using EpiAwareADTools: EpiAwareADTools

    root = pkgdir(EpiAwareADTools)
    include(joinpath(root, "docs", "pages.jl"))

    group = only(p for p in pages if first(p) == "Extensions")
    entries = last(group)
    @test !isempty(entries)
    for (label, path) in entries
        page = joinpath(root, "docs", "src", path)
        @test isfile(page)
    end
end

@testitem "Docs: one Extensions page per declared extension" begin
    using EpiAwareADTools: EpiAwareADTools
    using Pkg: Pkg

    root = pkgdir(EpiAwareADTools)
    include(joinpath(root, "docs", "pages.jl"))

    project = Pkg.TOML.parsefile(joinpath(root, "Project.toml"))
    declared = keys(project["extensions"])

    group = only(p for p in pages if first(p) == "Extensions")
    @test length(last(group)) == length(declared)

    dir = joinpath(root, "docs", "src", "extensions")
    written = isdir(dir) ? readdir(dir) : String[]
    @test length(filter(endswith(".md"), written)) == length(declared)
end
