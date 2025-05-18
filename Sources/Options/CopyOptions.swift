import ArgumentParser

struct CopyOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Input file.")
    var input: String?
}
