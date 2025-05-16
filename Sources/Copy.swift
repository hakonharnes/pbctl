import ArgumentParser

struct Copy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Copy data into the pasteboard"
    )

    mutating func run() throws {
        print("Copy")
    }
}
