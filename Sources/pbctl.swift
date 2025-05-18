import ArgumentParser
import Foundation

let version = """
pbctl 0.1.0
Copyright (C) 2025 Håkon Harnes
License MIT <https://opensource.org/licenses/MIT>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
"""

@main
struct Pbctl: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Command-line interface to the MacOS pasteboard",
        version: version,
        subcommands: [
            Copy.self,
            Paste.self,
            Clear.self,
            Types.self,
            Status.self,
        ],
        defaultSubcommand: isatty(STDIN_FILENO) != 0 ? Paste.self : Copy.self
    )
}
