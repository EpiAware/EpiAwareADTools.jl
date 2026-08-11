# PACKAGE-OWNED — opt-in README wording checks, beyond the managed quality
# testset's structural README-sections item. Selected by the `readme_only`
# test filter (see test/runtests.jl). Also tagged :quality so `skip_quality`
# excludes them: they exercise kit helpers, and environments that resolve an
# older kit (e.g. the downgrade-compat job) do not have these functions.

@testitem "README: no scaffold placeholders" tags = [:quality, :readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_placeholders(pkgdir(QA_CONFIG.mod))
end

@testitem "README: prose standard" tags = [:quality, :readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_prose(pkgdir(QA_CONFIG.mod))
end

@testitem "README: Why section bullets" tags = [:quality, :readme] begin
    using EpiAwarePackageTools
    include(joinpath(@__DIR__, "qa_config.jl"))
    test_readme_bullets(pkgdir(QA_CONFIG.mod))
end
