# Guard for AD test-item self-sufficiency (#88).
# TestItemRunner runs every item in one process, and `run_tests` iterates a
# `Dict` keyed by absolute file path, so item order is hash order over those
# paths rather than file order. An item that needs `EpiAwareADTools` loaded
# but never loads it therefore passes only while some earlier item happens
# to load the package first. `test/ad/xlogy_ad.jl` was in that state and
# turned 30 assertions red on an unrelated PR (#86), with no change to the
# file or to anything it exercises.
# Package extensions make the gap sharp. An extension loads only once every
# trigger *and* `EpiAwareADTools` itself are loaded modules, so an item that
# loads only the triggers gets the plain upstream method and silently tests
# the wrong thing.
# The same hazard applies to the backends. `DifferentiationInterface` reaches
# a backend through its own extension, so an item that asks for
# `AutoForwardDiff` without loading `ForwardDiff` also depends on a
# neighbour having loaded it.
# These items pin every AD item to loading what it exercises, so reordering
# the files cannot change the result.

@testitem "AD test items load the packages they exercise" begin
    using EpiAwareADTools: EpiAwareADTools

    root = pkgdir(EpiAwareADTools)
    ad_dir = joinpath(root, "test", "ad")

    # Does `ex` contain a `using`/`import` of module `mod`?
    function loads_module(ex, mod::Symbol)
        ex isa Expr || return false
        if ex.head === :using || ex.head === :import
            for arg in ex.args
                arg isa Expr || continue
                path = arg.head === :(:) ? arg.args[1] : arg
                if path isa Expr && path.head === :. &&
                        !isempty(path.args) && path.args[1] === mod
                    return true
                end
            end
            return false
        end
        return any(a -> loads_module(a, mod), ex.args)
    end

    parse_file(file) = Meta.parseall(read(file, String); filename = file)

    # Every `@testitem` in `file`, with the setup snippets it names, its
    # body, and whether that body loads the package.
    function testitems(file)
        found = NamedTuple[]
        for ex in parse_file(file).args
            ex isa Expr && ex.head === :macrocall || continue
            ex.args[1] === Symbol("@testitem") || continue
            setups = Symbol[]
            for arg in ex.args
                if arg isa Expr && arg.head === :(=) &&
                        arg.args[1] === :setup && arg.args[2] isa Expr &&
                        arg.args[2].head === :vect
                    append!(setups, Symbol.(arg.args[2].args))
                end
            end
            push!(
                found, (
                    label = string(basename(file), ": ", ex.args[3]),
                    setups = setups,
                    body = ex.args[end],
                    loads = loads_module(ex.args[end], :EpiAwareADTools),
                )
            )
        end
        return found
    end

    # A `setup = [...]` snippet stands in for the item's own `using` only
    # when the snippet itself reaches the package. `ADHelpers` reaches it
    # through `ADFixtures`, so check that hop rather than assume it: a
    # scaffold sync that drops `using ADFixtures`, or an `ADFixtures` that
    # stops loading the package, then fails here instead of quietly
    # widening the exemption.
    fixtures = joinpath(root, "test", "ADFixtures", "src", "ADFixtures.jl")
    fixtures_loads = loads_module(parse_file(fixtures), :EpiAwareADTools)
    @test fixtures_loads

    snippets = Dict{Symbol, Any}()
    for ex in parse_file(joinpath(ad_dir, "setup.jl")).args
        if ex isa Expr && ex.head === :macrocall &&
                ex.args[1] === Symbol("@testsnippet")
            snippets[Symbol(ex.args[3])] = ex.args[end]
        end
    end

    function reaches(name::Symbol)
        haskey(snippets, name) || return false
        body = snippets[name]
        loads_module(body, :EpiAwareADTools) && return true
        return fixtures_loads && loads_module(body, :ADFixtures)
    end

    files = sort(filter(endswith(".jl"), readdir(ad_dir; join = true)))
    @test !isempty(files)

    items = NamedTuple[]
    for file in files
        append!(items, testitems(file))
    end
    @test !isempty(items)

    # Every AD item states its dependency on the package where the item is
    # written, so the suite does not depend on the order it happens to run.
    offenders = [
        item.label for item in items
            if !(item.loads || any(reaches, item.setups))
    ]
    @test offenders == String[]

    # Same rule for the backends. `DifferentiationInterface` dispatches an
    # `AutoX` type through its own extension, so an item that names one
    # without loading the backend errors on the runs where no neighbour has
    # loaded it yet.
    triggers = [
        :AutoForwardDiff => :ForwardDiff,
        :AutoReverseDiff => :ReverseDiff,
        :AutoEnzyme => :Enzyme,
        :AutoMooncake => :Mooncake,
        :AutoMooncakeForward => :Mooncake,
        :AutoFiniteDifferences => :FiniteDifferences,
    ]

    # Does `ex` use `sym`? `using`/`import` lines are skipped, so a name
    # that is only imported does not count as used.
    function mentions(ex, sym::Symbol)
        ex === sym && return true
        ex isa Expr || return false
        (ex.head === :using || ex.head === :import) && return false
        return any(a -> mentions(a, sym), ex.args)
    end

    unloaded = [
        string(item.label, " (", backend, " without ", mod, ")")
            for item in items for (backend, mod) in triggers
            if mentions(item.body, backend) &&
            !loads_module(item.body, mod) &&
            !any(
                s -> haskey(snippets, s) &&
                loads_module(snippets[s], mod), item.setups
            )
    ]
    @test unloaded == String[]
end
