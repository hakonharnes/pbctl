import AppKit
import ArgumentParser

struct Paste: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Paste data from the pasteboard.")

    @OptionGroup var global: GlobalOptions
    @OptionGroup var options: PasteOptions

    mutating func run() throws {
        let pasteboard = NSPasteboard(name: global.pasteboard.name)

        for type in pasteboard.types ?? [] {
            if let data = pasteboard.data(forType: type) {
                FileHandle.standardOutput.write(data)
                return
            }
        }

        print("No data found in pasteboard.")
    }
}
