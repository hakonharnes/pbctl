import ArgumentParser

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Paste data from the pasteboard"
    )

    @OptionGroup()
    var options: GlobalOptions

    mutating func run() throws {
        print("Paste from \(options.pasteboard)")
    }
}
