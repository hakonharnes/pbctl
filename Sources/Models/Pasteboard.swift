import AppKit
import ArgumentParser

enum Pasteboard: String, ExpressibleByArgument, CaseIterable {
    case general, find, font, ruler, drag

    var name: NSPasteboard.Name {
        switch self {
        case .general: return .general
        case .find: return .find
        case .font: return .font
        case .ruler: return .ruler
        case .drag: return .drag
        }
    }
}
