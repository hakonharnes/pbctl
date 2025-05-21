import ArgumentParser

struct PasteOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output file.")
    var output: String?

    @Option(name: .shortAndLong, help: "UTI or MIME type of the data to paste.")
    var type: String?

    @Flag(name: .shortAndLong, help: "Do not resolve file-urls; paste the reference.")
    var reference: Bool = false
}
