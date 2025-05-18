import AppKit
import ArgumentParser
import UniformTypeIdentifiers

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Paste data from the pasteboard.")

    @OptionGroup var global: GlobalOptions
    @OptionGroup var options: PasteOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)

        if let typeInput = options.type {
            let uti: String

            if let utType = UTType(mimeType: typeInput) {
                uti = utType.identifier
            } else if let utType = UTType(typeInput) {
                uti = utType.identifier
            } else {
                throw ValidationError("Invalid type: \(typeInput) is not a recognized MIME type or UTI.")
            }

            let pasteboardType = NSPasteboard.PasteboardType(uti)

            guard let data = pasteboard.data(forType: pasteboardType) else {
                throw ValidationError("No data found for type: \(typeInput). Available types: \(pasteboard.types ?? [])")
            }

            try write(data: data)
            return
        }

        if let output = options.output {
            let fileExtension = (output as NSString).pathExtension

            if let utType = UTType(filenameExtension: fileExtension) {
                let inferredType = NSPasteboard.PasteboardType(utType.identifier)

                if let data = pasteboard.data(forType: inferredType) {
                    try write(data: data)
                    return
                } else {
                    fputs("Warning: No data for inferred type '\(utType.identifier)' (from '.\(fileExtension)'). Falling back.\n", stderr)
                }
            }
        }

        // Fallback to first matching pasteboard type
        for type in pasteboard.types ?? [] {
            if let data = pasteboard.data(forType: type) {
                try write(data: data)
                return
            }
        }

        throw CleanExit.message("No data found in the pasteboard.")
    }

    private func write(data: Data) throws {
        if let output = options.output {
            try data.write(to: URL(fileURLWithPath: output))
        } else {
            FileHandle.standardOutput.write(data)
        }
    }
}
