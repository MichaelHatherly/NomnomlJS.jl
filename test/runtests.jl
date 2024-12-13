using FileIO, ImageIO, Test, NomnomlJS, ReferenceTests

@testset "NomnomlJS" begin
    dir = joinpath(@__DIR__, "data")
    file = joinpath(dir, "test.noml")
    string = read(file, String)
    d1 = read(file, Diagram)
    d2 = Diagram(string)
    @test d1.src == d2.src
    # Check that the non-SVG results are similar to our reference. Testing the
    # SVG isn't important since they all get generated from that to begin with.
    for ext in ("png",) # TODO "pdf", "eps")
        gen = joinpath(dir, "generated.$ext")
        img = mktempdir() do tmp
            tmp_file = joinpath(tmp, "file.$ext")
            write(tmp_file, d1)
            FileIO.load(tmp_file)
        end
        @test_reference joinpath(dir, "reference.$ext") img
    end
    for ext in ("pdf", "eps")
        @test write(joinpath(dir, "generated.$ext"), d1) > 0
    end
end
