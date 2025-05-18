import ArgumentParser

struct Status: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display pasteboard status"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        print("Status \(global.pasteboard)")
    }
}
