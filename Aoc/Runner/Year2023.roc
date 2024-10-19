module [run]

import pf.Stdout
import Aoc.Args exposing [Part]
import Aoc.Year2023.Day09 as Day09

run : U8, Part, Str -> Task {} _
run = \day, part, input ->
    when (day, part) is
        (9, One) -> input |> Day09.part1 |> Inspect.toStr |> Stdout.line!
        (9, Two) -> input |> Day09.part2 |> Inspect.toStr |> Stdout.line!
        _ -> Task.err (BadDayPart day part)
