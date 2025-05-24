import AppKit
import ArgumentParser
import UniformTypeIdentifiers

extension NSPasteboard.PasteboardType {
    enum GenericType: String, CaseIterable {
        case text
        case image
        case audio
        case video
        case html
        case rtf
        case pdf

        var defaultPasteboardType: NSPasteboard.PasteboardType {
            switch self {
            case .text:
                .string
            case .image:
                NSPasteboard.PasteboardType("public.image")
            case .audio:
                NSPasteboard.PasteboardType("public.audio")
            case .video:
                NSPasteboard.PasteboardType("public.movie")
            case .html:
                .html
            case .rtf:
                .rtf
            case .pdf:
                .pdf
            }
        }

        func matches(_ pasteboardType: NSPasteboard.PasteboardType) -> Bool {
            guard let utType = UTType(pasteboardType.rawValue) else {
                return false
            }

            switch self {
            case .text:
                return utType.conforms(to: .text) ||
                    utType.conforms(to: .plainText) ||
                    utType.conforms(to: .utf8PlainText) ||
                    utType.conforms(to: .sourceCode) ||
                    pasteboardType == .string
            case .image:
                return utType.conforms(to: .image)
            case .audio:
                return utType.conforms(to: .audio)
            case .video:
                return utType.conforms(to: .movie) || utType.conforms(to: .video)
            case .html:
                return utType.conforms(to: .html) || pasteboardType == .html
            case .rtf:
                return utType.conforms(to: .rtf) || utType.conforms(to: .rtfd) || pasteboardType == .rtf
            case .pdf:
                return utType.conforms(to: .pdf) || pasteboardType == .pdf
            }
        }
    }

    static func from(typeString: String) throws -> NSPasteboard.PasteboardType {
        // Try to parse as generic type
        if let genericType = GenericType(rawValue: typeString.lowercased()) {
            return genericType.defaultPasteboardType
        }

        // Try to parse as MIME type
        if let utType = UTType(mimeType: typeString), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }

        // Try to parse as UTI
        if let utType = UTType(typeString), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }

        throw ValidationError("\"\(typeString)\" is not a recognized generic type, MIME type, or UTI.")
    }

    static func findMatching(genericType: GenericType, in availableTypes: [NSPasteboard.PasteboardType]) -> NSPasteboard.PasteboardType? {
        availableTypes.first { genericType.matches($0) }
    }
}

