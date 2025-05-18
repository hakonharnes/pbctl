import ArgumentParser

struct Copy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Copy data into the pasteboard"
    )

    @OptionGroup var options: CopyOptions
    @OptionGroup var globalOptions: GlobalOptions

    mutating func run() throws {
        print("Copy")
    }
}
