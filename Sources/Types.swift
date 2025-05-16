import ArgumentParser

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List pasteboard types"
    )

    mutating func run() throws {
        print("Types")
    }
}
