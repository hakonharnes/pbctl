import ArgumentParser

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Paste data from the pasteboard"
    )

    mutating func run() throws {
        print("Paste")
    }
}
