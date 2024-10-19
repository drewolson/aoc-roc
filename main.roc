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
                _ -> Err (InvalidValue "Year must be in [2023, 2024], found $(str)")

        Opt.maybe { short: "y", long: "year", type: "year", parser }
        |> Cli.map \y -> Result.withDefault y 2024

    dayOpt =
        parser = \str ->
            when Str.toU8 str is
                Ok day if day >= 1 && day <= 25 -> Ok day
                _ -> Err (InvalidValue "Day must be between 1 and 25, found $(str)")

        Opt.single { short: "d", long: "day", type: "day", parser }

    partOpt =
        parser = \str ->
            when Str.toU8 str is
                Ok 1 -> Ok One
                Ok 2 -> Ok Two
                _ -> Err (InvalidValue "Part must be 1 or 2, found $(str)")

        Opt.single { short: "p", long: "part", type: "part", parser }

    command =
        { Cli.combine <-
            year: yearOpt,
            day: dayOpt,
            part: partOpt,
        }

    command
    |> Cli.finish {
        name: "aoc",
        description: "Run aoc solution",
        version: "0.1.0",
    }
    |> Cli.assertValid

main : Task {} [StdoutError _, Exit I32 Str]
main =
    task =
        args = Arg.list! {}

        when Cli.parseOrDisplayMessage cli args is
            Ok opts -> Runner.run opts
            Err e -> Stdout.line! e

    Task.mapErr task \err ->
        when err is
            BadDayPart day part -> Exit 1 "Invalid day and part: $(Inspect.toStr day), $(Inspect.toStr part)"
            BadInput path -> Exit 1 "Invalid input file: $(path)"
            BadYear year -> Exit 1 "Invalid year: $(Inspect.toStr year)"
            StdoutErr e -> StdoutError e
