"""
The `NomnomlJS` package provides an interface to the `nomnoml` JavaScript
library for rendering UML diagrams from `.noml` strings and via the
`read(filename, Diagram)` overload.

The public interface for this package is the `Diagram` type, which constructs
a `nomnoml` diagram. This object can then be written to several different
file formats via `write(filename, diagram)`.
"""
module NomnomlJS

using Artifacts, Librsvg_jll, NodeJS

export Diagram

"""
    Diagram(str::String)

Construct a *nomnoml* diagram from the given source code `str`. To create a
`Diagram` from a file use `read(filename, Diagram)` instead.
"""
struct Diagram
    src::String
end

Base.read(file::AbstractString, ::Type{Diagram}) = Diagram(read(file, String))
Base.write(filename::String, d::Diagram) = open(io -> show(io, mimetype(filename)(), d), filename, "w")

Base.show(io::IO, d::Diagram) = print(io, "$Diagram(...)")

### Keep next section in sync.

const SVG = MIME"image/svg+xml"
const PNG = MIME"image/png"
const PDF = MIME"application/pdf"
const EPS = MIME"application/postscript"

const SUPPORTED_MIMES = Union{SVG,PNG,PDF,EPS}

extension(::SVG) = "svg"
extension(::PNG) = "png"
extension(::PDF) = "pdf"
extension(::EPS) = "eps"
extension(other) = error("unknown extension '$other'.")

function mimetype(filename::AbstractString)
    _, ext = splitext(filename)
    return mimetype(Val{Symbol(ext[2:end])}())
end
mimetype(::Val{:svg}) = SVG
mimetype(::Val{:png}) = PNG
mimetype(::Val{:pdf}) = PDF
mimetype(::Val{:eps}) = EPS
mimetype(::Val{s}) where s = error("unknown format '$s'.")


###

function Base.show(io::IO, mime::SUPPORTED_MIMES, d::Diagram)
    function handler(mime::SUPPORTED_MIMES, svg::String, out::String)
        Librsvg_jll.rsvg_convert() do bin
            run(`$bin --format $(extension(mime)) --output $out $svg`)
        end
        write(io, read(out))
    end
    handler(::SVG, svg::String, ::String) = write(io, read(svg, String))
    handler(mime::MIME, ::String, ::String) = error("unknown mime type '$mime'.")
    mktemp() do noml, _
        mktemp() do svg, _
            mktemp() do out, _
                write(noml, d.src)
                nomnoml(noml, svg)
                handler(mime, svg, out)
            end
        end
    end
end

nomnoml_bin() = joinpath(artifact"nomnoml", "index.js")
nomnoml(input, output) = run(`$(nodejs_cmd()) $(nomnoml_bin()) $input $output`)

end # module
