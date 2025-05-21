import AppKit
import ArgumentParser
import Foundation
import UniformTypeIdentifiers

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List available pasteboard types."
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let items = pasteboard.pasteboardItems ?? []

        for (index, item) in items.enumerated() {
            print("Item \(index)")

            for type in item.types {
                var line = "  \(type.rawValue)"

                if let mime = type.mimeType {
                    line += " (\(mime))"
                }

                if type == .fileURL,
                   let urlString = pasteboard.string(forType: .fileURL) {
                    let url = URL(string: urlString).flatMap { $0.isFileURL ? $0 : nil }
                        ?? URL(fileURLWithPath: urlString)

                    let ext = url.pathExtension
                    if let ut = UTType(filenameExtension: ext), !ut.isDynamic {
                        line += " → \(ut.identifier)"
                        if let mime = ut.preferredMIMEType {
                            line += " (\(mime))"
                        }
                    }
                }

                print(line)
            }
        }
    }
}
