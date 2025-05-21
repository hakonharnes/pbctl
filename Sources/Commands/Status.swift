import AppKit
import ArgumentParser
import Foundation

struct Status: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Display current pasteboard status."
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        let changeCount = pasteboard.changeCount
        let items = pasteboard.pasteboardItems ?? []

        let totalBytes = items.reduce(0) { running, item in
            running + item.types.reduce(0) { inner, type in
                let count = (try? pasteboard
                    .getData(forType: type, followFileURLs: true)?.count) ?? 0
                return inner + count
            }
        }

        let fmt = ByteCountFormatter(); fmt.countStyle = .binary

        print("Pasteboard  : \(global.pasteboard)")
        print("Change #    : \(changeCount)")
        print("Items       : \(items.count)")
        if totalBytes > 0 {
            print("Size        : \(fmt.string(fromByteCount: Int64(totalBytes)))")
        }
    }
}
