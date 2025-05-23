import AppKit
import ArgumentParser
import Foundation
import UniformTypeIdentifiers

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Paste data from the pasteboard."
    )

    @OptionGroup var options: PasteOptions
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let followFileURLs = !options.reference

        if let explicit = options.type {
            let pasteboardType = try getTypeFromArgument(type: explicit)
            guard let data = try pasteboard.getData(
                forType: pasteboardType,
                followFileURLs: followFileURLs
            ) else {
                throw ValidationError("No data found for type \"\(explicit)\".")
            }
            try write(data: data, type: pasteboardType)
            return
        }

        if let output = options.output {
            if let pasteboardType = try? getTypeFromFile(file: output),
               let data = try pasteboard.getData(
                   forType: pasteboardType,
                   followFileURLs: followFileURLs
               ) {
                try write(data: data, type: pasteboardType)
                return
            }
        }

        for type in pasteboard.types ?? [] {
            if let data = try pasteboard.getData(
                forType: type,
                followFileURLs: followFileURLs
            ) {
                try write(data: data, type: type)
                return
            }
        }

        throw CleanExit.message("No data found in the pasteboard.")
    }
}

private extension Paste {
    func getTypeFromArgument(type: String) throws -> NSPasteboard.PasteboardType {
        if let utType = UTType(mimeType: type), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        } else if let utType = UTType(type), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }
        throw ValidationError("\"\(type)\" is not a recognized MIME type or UTI.")
    }

    func getTypeFromFile(file: String) throws -> NSPasteboard.PasteboardType {
        let ext = URL(fileURLWithPath: file).pathExtension
        if let utType = UTType(filenameExtension: ext), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }
        throw ValidationError("\(file) is not a recognized file extension.")
    }

    func write(data: Data, type: NSPasteboard.PasteboardType) throws {
        if let output = options.output {
            try data.write(to: URL(fileURLWithPath: output))
            return
        }

        if options.stdout || isatty(STDOUT_FILENO) == 0 || type.isTextType {
            FileHandle.standardOutput.write(data)
            return
        }

        throw CleanExit.message("Binary data detected. Use --stdout to output to terminal or -o to save to file.")
    }
}
