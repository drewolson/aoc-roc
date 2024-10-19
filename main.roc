app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br",
    parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.8.0/PCkJq9IGyIpMfwuW-9hjfXd6x-bHb1_OZdacogpBcPM.tar.br",
}

import pf.Stdout
import Aoc.Runner as Runner
import Aoc.Args exposing [Args]
import pf.Arg
import pf.Arg.Cli as Cli exposing [CliParser]
import pf.Arg.Opt as Opt

cli : CliParser Args
cli =
    yearOpt =
        years = Set.fromList [2023, 2024]

        parser = \str ->
            when Str.toU16 str is
                Ok year if Set.contains years year -> Ok year
                _ -> Err (InvalidValue "$(str) is not a valid year")

        Opt.maybe { short: "y", long: "year", type: "int", parser }
        |> Cli.map \y -> Result.withDefault y 2024

    dayOpt =
        parser = \str ->
            when Str.toU8 str is
                Ok day if day >= 1 && day <= 25 -> Ok day
                _ -> Err (InvalidValue "$(str) is not a valid day")

        Opt.single { short: "d", long: "day", type: "int", parser }

    partOpt =
        parser = \str ->
            when Str.toU8 str is
                Ok 1 -> Ok One
                Ok 2 -> Ok Two
                _ -> Err (InvalidValue "$(str) is not a valid part")

        Opt.single { short: "p", long: "part", type: "int", parser }

    command =
        { Cli.combine <-
            year: yearOpt,
            day: dayOpt,
            part: partOpt,
        }

    command
    |> Cli.finish {
        name: "aoc",
        description: "run aoc solution",
        version: "0.1.0",
    }
    |> Cli.assertValid

main : Task {} _
main =
    args = Arg.list! {}

    when Cli.parseOrDisplayMessage cli args is
        Ok opts -> Runner.run opts
        Err e -> e |> Inspect.toStr |> Stdout.line!
