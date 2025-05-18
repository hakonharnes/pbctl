import ArgumentParser

struct PasteOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output file.")
    var output: String?

    @Option(name: .shortAndLong, help: "UTI or MIME type of the data to paste.")
    var type: String?
}
