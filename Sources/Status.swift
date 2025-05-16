import ArgumentParser

struct Status: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display pasteboard status"
    )

    mutating func run() throws {
        print("Status")
    }
}
