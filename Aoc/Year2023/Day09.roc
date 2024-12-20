module [part1, part2]

nextVal : List I64 -> I64
nextVal = \l ->
    if List.all l \n -> n == 0 then
        0
    else
        diffs = List.map2 l (List.dropFirst l 1) \a, b -> b - a
        next = nextVal diffs
        next + (l |> List.last |> Result.withDefault 0)

part1 : Str -> I64
part1 = \input ->
    input
    |> Str.splitOn "\n"
    |> List.map \l ->
        l
        |> Str.splitOn " "
        |> List.keepOks Str.toI64
        |> nextVal
    |> List.sum

part2 : Str -> I64
part2 = \input ->
    input
    |> Str.splitOn "\n"
    |> List.map \l ->
        l
        |> Str.splitOn " "
        |> List.keepOks Str.toI64
        |> List.reverse
        |> nextVal
    |> List.sum

testInput : Str
testInput =
    """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

expect
    result = part1 testInput

    result == 114

expect
    result = part2 testInput

    result == 2
