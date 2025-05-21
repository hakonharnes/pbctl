import AppKit
import ArgumentParser
import Foundation
import MagicWrapper
import UniformTypeIdentifiers

struct Copy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Copy data into the pasteboard."
    )

    @OptionGroup var options: CopyOptions
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        pasteboard.clearContents()

        if options.reference {
            guard let inputPath = options.input else {
                throw ValidationError("--reference (-r) requires an --input file path.")
            }

            let url = URL(fileURLWithPath: inputPath).absoluteURL
            if !pasteboard.setString(url.absoluteString, forType: .fileURL) {
                throw ValidationError("Failed to copy file reference to the pasteboard.")
            }
            return
        }

        let data = try getData()
        var pasteboardType = try getPasteboardType(forData: data)

        if pasteboardType.rawValue.contains("plain-text") {
            pasteboardType = NSPasteboard.PasteboardType.string
        }

        if !pasteboard.setData(data, forType: pasteboardType) {
            throw ValidationError("Failed to copy data to the pasteboard.")
        }
    }

    private func getData() throws -> Data {
        if let input = options.input {
            try Data(contentsOf: URL(fileURLWithPath: input))
        } else {
            FileHandle.standardInput.readDataToEndOfFile()
        }
    }

    private func getPasteboardType(forData data: Data) throws -> NSPasteboard.PasteboardType {
        if let type = options.type {
            return try getTypeFromArgument(type: type)
        }

        let mime: String
        do {
            mime = try MagicWrapper().file(data, flags: .mimeType)
        } catch {
            mime = "application/octet-stream"
        }

        let uti = UTType(mimeType: mime)?.identifier ?? "com.pbctl.binary"
        return NSPasteboard.PasteboardType(uti)
    }

    private func getTypeFromArgument(type: String) throws -> NSPasteboard.PasteboardType {
        if let utType = UTType(mimeType: type), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        } else if let utType = UTType(type), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }

        throw ValidationError("\"\(type)\" is not a recognized MIME type or UTI.")
    }
}
