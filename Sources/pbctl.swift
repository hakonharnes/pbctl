import ArgumentParser
import Foundation

private let year = Calendar.current.component(.year, from: Date())

private let version = """
pbctl 0.1.0
Copyright (C) \(year) Håkon Harnes
License MIT <https://opensource.org/licenses/MIT>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
"""

@main
struct Pbctl: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Command-line interface to the MacOS pasteboard.",
        version: version,
        subcommands: [
            Paste.self,
            Copy.self,
            Clear.self,
            Types.self,
            Status.self,
        ],
        defaultSubcommand: getDefaultSubcommand()
    )

    private static func getDefaultSubcommand() -> ParsableCommand.Type {
        let args = CommandLine.normalizedArguments
        if args.contains("-o") || args.contains("--output") {
            return Paste.self
        } else if args.contains("-i") || args.contains("--input") {
            return Copy.self
        }

        return isatty(STDIN_FILENO) != 0 ? Paste.self : Copy.self
    }
}
