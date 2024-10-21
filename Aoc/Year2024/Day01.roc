module [part1]

part1 : Str -> Str
part1 = \input ->
    input

expect
    input =
        """
        foo
        """

    result = part1 input

    result == "foo"
