import ArgumentParser

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Paste data from the pasteboard.")

    @OptionGroup var global: GlobalOptions
    @OptionGroup var options: PasteOptions

    mutating func run() throws {
        print("Paste")
    }
}
