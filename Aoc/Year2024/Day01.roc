module [part1, part2]

import Aoc.Util.List as ListUtil

parse : Str -> (List I64, List I64)
parse = \input ->
    lists =
        input
        |> Str.trimEnd
        |> Str.splitOn "\n"
        |> List.map \s ->
            s
            |> Str.splitOn "   "
            |> List.keepOks Str.toI64
        |> ListUtil.transpose
        |> List.map List.sortAsc

    when lists is
        [a, b, ..] -> (a, b)
        _ -> ([], [])

part1 : Str -> I64
part1 = \input ->
    (left, right) = parse input

    left
    |> List.map2 right \l, r -> Num.abs (l - r)
    |> List.sum

part2 : Str -> I64
part2 = \input ->
    (left, right) = parse input

    counts = List.walk right (Dict.empty {}) \d, i ->
        prev = d |> Dict.get i |> Result.withDefault 0
        Dict.insert d i (prev + 1)

    left
    |> List.map \i ->
        mul = counts |> Dict.get i |> Result.withDefault 0
        i * mul
    |> List.sum

testInput : Str
testInput =
    """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

expect
    result = part1 testInput

    result == 11

expect
    result = part2 testInput

    result == 31
