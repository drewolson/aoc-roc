module [part1, part2]

Grid : List (List U8)

Cache : Dict Grid U64

transpose : List (List a) -> List (List a)
transpose = \matrix ->
    aux = \m, acc ->
        when List.mapTry m List.first is
            Ok firsts ->
                m
                |> List.map \l -> List.dropFirst l 1
                |> aux (List.append acc firsts)

            _ -> acc

    matrix |> aux []

rotate : Grid -> Grid
rotate = \grid ->
    grid
    |> transpose
    |> List.map List.reverse

parse : Str -> Grid
parse = \str ->
    str
    |> Str.splitOn "\n"
    |> List.map Str.toUtf8
    |> rotate

tilt : Grid -> Grid
tilt = \grid ->
    aux = \{ rocks, l }, s ->
        when s is
            'O' -> { rocks: List.append rocks 'O', l }
            '.' -> { rocks, l: List.append l '.' }
            '#' -> { rocks: [], l: List.concat l (rocks |> List.append '#') }
            _ -> { rocks, l }

    shiftRocks = \row ->
        { rocks, l } = List.walk row { rocks: [], l: [] } aux

        List.concat l rocks

    List.map grid shiftRocks

load : List U8 -> U64
load = \row ->
    row
    |> List.mapWithIndex \s, i ->
        if s == 'O' then i + 1 else 0
    |> List.sum

runCycles : Grid, U64, Cache -> Grid
runCycles = \grid, n, cache ->
    cycle = \g ->
        { start: At 0, end: At 3 }
        |> List.range
        |> List.walk g \gr, _ ->
            gr |> tilt |> rotate

    when n is
        0 -> grid
        _ ->
            when Dict.get cache grid is
                Ok i ->
                    grid
                    |> cycle
                    |> runCycles ((Num.rem n (i - n)) - 1) cache

                Err _ ->
                    grid
                    |> cycle
                    |> runCycles (n - 1) (Dict.insert cache grid n)

part1 : Str -> U64
part1 = \input ->
    input
    |> Str.trim
    |> parse
    |> tilt
    |> List.map load
    |> List.sum

part2 : Str -> U64
part2 = \input ->
    input
    |> Str.trim
    |> parse
    |> runCycles 1000000000 (Dict.empty {})
    |> List.map load
    |> List.sum

testInput : Str
testInput =
    """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

expect
    result = part1 testInput

    result == 136

expect
    result = part2 testInput

    result == 64
