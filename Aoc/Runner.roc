module [run]

import pf.File
import Aoc.Args exposing [Args]
import Aoc.Runner.Year2023 as Year2023
import Aoc.Runner.Year2024 as Year2024

readInput : Args -> Task Str _
readInput = \{ year, day } ->
    pad = \str ->
        if Str.countUtf8Bytes str == 1 then
            Str.concat "0" str
        else
            str

    yearStr = Num.toStr year

    dayStr = day |> Num.toStr |> pad

    path = "./data/$(yearStr)/day$(dayStr).txt"

    path
    |> File.readUtf8
    |> Task.mapErr \_ -> BadInput path

run : Args -> Task {} _
run = \args ->
    input = readInput! args

    when args is
        { year: 2023, day, part } -> Year2023.run! day part input
        { year: 2024, day, part } -> Year2024.run! day part input
        { year, day: _, part: _ } -> Task.err (BadYear year)
