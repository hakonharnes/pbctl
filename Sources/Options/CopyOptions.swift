import ArgumentParser

struct CopyOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Input file.")
    var input: String?

    @Option(name: .shortAndLong, help: "UTI or MIME type of the data to copy.")
    var type: String?

    @Flag(name: .shortAndLong, help: "Copy file reference instead of contents.")
    var reference: Bool = false
}
