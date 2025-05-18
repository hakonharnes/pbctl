import ArgumentParser

struct Status: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display pasteboard status"
    )

    @OptionGroup var globalOptions: GlobalOptions

    mutating func run() throws {
        print("Status \(globalOptions.pasteboard)")
    }
}
