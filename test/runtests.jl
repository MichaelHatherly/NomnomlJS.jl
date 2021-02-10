using FileIO, Test, NomnomlJS, VisualRegressionTests

@testset "NomnomlJS" begin
    dir = joinpath(@__DIR__, "data")
    file = joinpath(dir, "test.noml")
    string = read(file, String)
    d1 = read(file, Diagram)
    d2 = Diagram(string)
    @test d1.src == d2.src
    # Check that the non-SVG results are similar to our reference. Testing the
    # SVG isn't important since they all get generated from that to begin with.
    for ext in ("png", "pdf", "eps")
        gen = joinpath(dir, "generated.$ext")
        write(gen, d1)
        func = fname -> save(fname, (load(gen)))
        @visualtest func joinpath(dir, "reference.png") false 5.0
    end
end
