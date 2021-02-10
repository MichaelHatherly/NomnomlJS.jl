using Test, NomnomlJS

@testset "NomnomlJS" begin
    dir = joinpath(@__DIR__, "data")
    file = joinpath(dir, "test.noml")
    string = read(file, String)
    d1 = read(file, Diagram)
    d2 = Diagram(string)
    @test d1.src == d2.src
    for ext in ("svg", "png") # TODO: pdf and eps checks.
        @testset "Format $ext" begin
            ref = read(joinpath(dir, "reference.$ext"))
            out = joinpath(dir, "generated.$ext")
            write(out, d1)
            gen = read(out)
            @test ref == gen
        end
    end
end
