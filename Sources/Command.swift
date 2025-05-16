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
        ]
    )

    @OptionGroup()
    var options: GlobalOptions

    mutating func run() throws {
        let stdinIsTTY = isatty(STDIN_FILENO) != 0
        let stdoutIsTTY = isatty(STDOUT_FILENO) != 0

        if stdinIsTTY && stdoutIsTTY {
            throw CleanExit.helpRequest(self)
        } else if !stdinIsTTY && stdoutIsTTY {
            var copyCommand = Copy()
            copyCommand.options = options
            try copyCommand.run()
        } else {
            var pasteCommand = Paste()
            pasteCommand.options = options
            try pasteCommand.run()
        }
    }
}
