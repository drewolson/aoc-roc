module [run]

import pf.Stdout
import Aoc.Args exposing [Part]
import Aoc.Year2024.Day01 as Day01

run : U8, Part, Str -> Task {} _
run = \day, part, input ->
    when (day, part) is
        (1, One) -> input |> Day01.part1 |> Inspect.toStr |> Stdout.line!
        (1, Two) -> input |> Day01.part2 |> Inspect.toStr |> Stdout.line!
        _ -> Task.err (BadDayPart day part)
