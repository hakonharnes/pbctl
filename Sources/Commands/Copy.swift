import AppKit
import ArgumentParser
import MagicWrapper
import UniformTypeIdentifiers

struct Copy: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Copy data into the pasteboard."
    )

    @OptionGroup var options: CopyOptions
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let data = try getData()
        var pasteboardType = try getPasteboardType(forData: data)

        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        pasteboard.clearContents()

        if pasteboardType.rawValue.contains("plain-text") {
            pasteboardType = NSPasteboard.PasteboardType.string
        }

        if !pasteboard.setData(data, forType: pasteboardType) {
            throw ValidationError("Failed to copy data to the pasteboard.")
        }
    }

    private func getData() throws -> Data {
        if let input = options.input {
            return try Data(contentsOf: URL(fileURLWithPath: input))
        } else {
            return FileHandle.standardInput.readDataToEndOfFile()
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
