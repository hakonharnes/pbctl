import AppKit
import ArgumentParser

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "List pasteboard types")
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let items = pasteboard.pasteboardItems ?? []

        for (index, item) in items.enumerated() {
            print("Item \(index)")

            for type in item.types {
                if let mime = type.mimeType {
                    print("  \(type.rawValue) (\(mime))")
                } else {
                    print("  \(type.rawValue)")
                }
            }
        }
    }
}
