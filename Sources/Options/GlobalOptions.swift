import ArgumentParser

struct GlobalOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Pasteboard to target.")
    var pasteboard: Pasteboard = .general
}
