module [run]

import pf.Stdout
import Aoc.Args exposing [Part]

run : U8, Part, Str -> Task {} _
run = \_day, _part, _input ->
    Stdout.line! "2024"
