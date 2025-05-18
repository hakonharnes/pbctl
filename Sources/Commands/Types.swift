import AppKit
import ArgumentParser

struct Types: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "List pasteboard types"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let items = pasteboard.pasteboardItems ?? []

        for (itemIndex, item) in items.enumerated() {
            for (typeIndex, type) in item.types.enumerated() {
                if typeIndex == 0 {
                    print(String(format: "Item %-3d %@", itemIndex, type.rawValue))
                } else {
                    print(String(format: "         %@", type.rawValue))
                }
            }
        }
    }
}
