module [part1]

part1 : Str -> Str
part1 = \input ->
    input

testInput : Str
testInput =
    """
    foo
    """

expect
    result = part1 testInput

    result == "foo"
