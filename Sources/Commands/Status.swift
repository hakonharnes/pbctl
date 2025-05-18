import AppKit
import ArgumentParser
import Foundation

struct Status: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display pasteboard status"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let changeCount = pasteboard.changeCount
        let items = pasteboard.pasteboardItems ?? []

        let totalBytes = items.reduce(0) { running, item in
            running + item.types.reduce(0) { inner, type in
                inner + (item.data(forType: type)?.count ?? 0)
            }
        }

        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary

        print("Pasteboard  : \(global.pasteboard)")
        print("Change #    : \(changeCount)")
        print("Items       : \(items.count)")
        if totalBytes > 0 {
            print("Size        : \(formatter.string(fromByteCount: Int64(totalBytes)))")
        }
    }
}
