import ArgumentParser

struct PasteOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output file.")
    var output: String?

    @Option(name: .shortAndLong, help: "UTI.")
    var type: String?
}
