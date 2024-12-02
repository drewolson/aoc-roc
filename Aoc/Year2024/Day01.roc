module [part1, part2]

import Aoc.Util.List as ListUtil

parse : Str -> { left : List I64, right : List I64 }
parse = \input ->
    lists =
        input
        |> Str.trimEnd
        |> Str.splitOn "\n"
        |> List.map \s ->
            s
            |> Str.splitOn ("   ")
            |> List.keepOks Str.toI64
        |> ListUtil.transpose
        |> List.map List.sortAsc

    result =
        a = List.get? lists 0
        b = List.get? lists 1
        Ok { left: a, right: b }

    Result.withDefault result { left: [], right: [] }

part1 : Str -> I64
part1 = \input ->
    p = parse input

    List.map2 p.left p.right \l, r -> Num.abs (l - r)
    |> List.sum

part2 : Str -> I64
part2 = \input ->
    p = parse input

    counts = List.walk p.right (Dict.empty {}) \d, i ->
        prev = d |> Dict.get i |> Result.withDefault 0
        Dict.insert d i (prev + 1)

    p.left
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
