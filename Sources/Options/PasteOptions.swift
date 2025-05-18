import ArgumentParser

struct PasteOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output file.")
    var output: String?
}
