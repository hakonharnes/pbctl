import ArgumentParser

struct Clear: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Clear data from the pasteboard"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        print("Paste")
    }
}
