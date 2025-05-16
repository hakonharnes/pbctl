import ArgumentParser

struct Copy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Copy data into the pasteboard"
    )

    @OptionGroup()
    var options: GlobalOptions

    mutating func run() throws {
        print("Copy to \(options.pasteboard)")
    }
}
