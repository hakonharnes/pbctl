import ArgumentParser

struct CopyOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Input file.")
    var input: String?

    @Option(name: .shortAndLong, help: "Generic type (text, image, audio, video, html, rtf, pdf), UTI, or MIME type of the data to copy.")
    var type: String?

    @Flag(name: .shortAndLong, help: "Copy file reference instead of contents.")
    var reference: Bool = false

    @Flag(name: .long, inversion: .prefixedNo, help: "Output copied data to stdout (automatic when output is piped).")
    var stdout: Bool = false
}
