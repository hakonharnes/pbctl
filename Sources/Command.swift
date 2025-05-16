import ArgumentParser

@main
struct Pbctl: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Command-line interface to the MacOS pasteboard",
        subcommands: [
            Copy.self,
            Paste.self,
            Clear.self,
            Types.self,
            Status.self,
        ]
    )

    mutating func run() throws {
        print("Default mode")
    }
}
