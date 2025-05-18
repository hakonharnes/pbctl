import ArgumentParser

enum Pasteboard: String, ExpressibleByArgument, CaseIterable {
    case general, find, font, ruler
}
