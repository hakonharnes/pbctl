import AppKit
import ArgumentParser
import UniformTypeIdentifiers

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Paste data from the pasteboard.")

    @OptionGroup var options: PasteOptions
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)

        /// If a type is specified, try to get the data for that type
        /// exit immediately with an error if no data is found
        if let type = options.type {
            let pasteboardType = try getTypeFromArgument(type: type)
            guard let data = pasteboard.data(forType: pasteboardType) else {
                throw ValidationError("No data found for type \"\(type)\".")
            }

            try write(data: data)
            return
        }

        /// If a file is specified, try to get the data for the file's type
        if let output = options.output {
            if let pasteboardType = try? getTypeFromFile(file: output),
               let data = pasteboard.data(forType: pasteboardType)
            {
                try write(data: data)
                return
            }
        }

        /// If no type is specified, try to get the default type (first type in pasteboard or string)
        let defaultType = pasteboard.types?.first ?? NSPasteboard.PasteboardType.string
        if let data = pasteboard.data(forType: defaultType) {
            try write(data: data)
            return
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
        let fileExtension = URL(fileURLWithPath: file).pathExtension
        if let utType = UTType(filenameExtension: fileExtension), !utType.isDynamic {
            return NSPasteboard.PasteboardType(utType.identifier)
        }

        throw ValidationError("\(file) is not a recognized file extension.")
    }

    func write(data: Data) throws {
        if let output = options.output {
            try data.write(to: URL(fileURLWithPath: output))
        } else {
            FileHandle.standardOutput.write(data)
        }
    }
}
