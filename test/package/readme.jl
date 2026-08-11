# PACKAGE-OWNED — opt-in README wording checks, beyond the managed quality
# testset's structural README-sections item. Selected by the `readme_only`
# test filter (see test/runtests.jl).

@testitem "README: no scaffold placeholders" tags = [:readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_placeholders(pkgdir(QA_CONFIG.mod))
end

@testitem "README: prose standard" tags = [:readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_prose(pkgdir(QA_CONFIG.mod))
end

@testitem "README: Why section bullets" tags = [:readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_bullets(pkgdir(QA_CONFIG.mod))
end
