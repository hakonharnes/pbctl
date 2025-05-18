extension CommandLine {
    static var normalizedArguments: [String] {
        return arguments.dropFirst().flatMap { arg -> [String] in
            let components = arg.split(separator: "=", maxSplits: 1).map(String.init)
            return components.first.map { [$0] } ?? []
        }
    }
}
