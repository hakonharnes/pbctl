import ArgumentParser

struct PasteOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Output file.")
    var output: String?

    @Option(name: .shortAndLong, help: "Generic type (text, image, audio, video, html, rtf, pdf), UTI, or MIME type of the data to paste.")
    var type: String?

    @Flag(name: .shortAndLong, help: "Do not resolve file-urls; paste the reference.")
    var reference: Bool = false

    @Flag(name: .long, inversion: .prefixedNo, help: "Force output to stdout (automatic for text or when piped).")
    var stdout: Bool = false
}
