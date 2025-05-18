import AppKit
import ArgumentParser

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "List pasteboard types")
    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let items = pasteboard.pasteboardItems ?? []
        let indent = String(repeating: " ", count: 8)

        for (itemIndex, item) in items.enumerated() {
            for (typeIndex, type) in item.types.enumerated() {
                let prefix = typeIndex == 0
                    ? String(format: "Item %-3d", itemIndex)
                    : indent
                let mime = type.mimeType.map { "(\($0))" } ?? ""
                print("\(prefix) \(type.rawValue) \(mime)")
            }
        }
    }
}
