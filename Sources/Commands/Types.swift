import ArgumentParser

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List pasteboard types"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        print("Types")
    }
}
