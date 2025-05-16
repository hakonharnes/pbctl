import ArgumentParser

enum Pasteboard: String, ExpressibleByArgument {
    case general
    case find
    case font
    case ruler
}

struct GlobalOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Specify which pasteboard to use")
    var pasteboard: Pasteboard = .general
}
