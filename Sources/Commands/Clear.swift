import AppKit
import ArgumentParser

struct Clear: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Clear data from the pasteboard"
    )

    @OptionGroup var global: GlobalOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)
        pasteboard.clearContents()
    }
}
