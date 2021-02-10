# NomnomlJS

![CI](https://github.com/MichaelHatherly/NomnomlJS.jl/workflows/CI/badge.svg)

A Julia wrapper for the [`nomnoml`](https://github.com/skanaar/nomnoml)
JavaScript library for text-based UML diagrams exportable to `svg`, `png`,
`pdf`, and `eps`. Please refer to the upstream documentation for the supported
diagram syntax.

## Usage

```julia-repl
julia> ]add NomnomlJS

julia> using NomnomlJS

julia> d = Diagram("[A] is -> [B]");

julia> write("digram.svg", d);

julia> d = read("diagram.noml", Diagram);

```
