using Test, NomnomlJS

@testset "NomnomlJS" begin
    dir = joinpath(@__DIR__, "data")
    file = joinpath(dir, "test.noml")
    string = read(file, String)
    d1 = read(file, Diagram)
    d2 = Diagram(string)
    @test d1.src == d2.src
    for ext in ("svg", "png", "pdf", "eps")
        ref = read(joinpath(dir, "reference.$ext"))
        out = joinpath(dir, "generated.$ext")
        write(out, d1)
        gen = read(out)
        ext == "svg" && @test ref == gen # TODO: actually test against the others.
    end
end
