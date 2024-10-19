module [run]

import pf.Stdout
import Aoc.Args exposing [Args]

run2023 : U8, U8 -> Task {} _
run2023 = \_day, _part ->
    Stdout.line! "2023"

run2024 : U8, U8 -> Task {} _
run2024 = \_day, _part ->
    Stdout.line! "2024"

run : Args -> Task {} _
run = \args ->
    when args is
        { year: 2023, day, part } -> run2023! day part
        { year: 2024, day, part } -> run2024! day part
        { year, day: _, part: _ } -> Stdout.line! "Unknown year: $(Num.toStr year)"
