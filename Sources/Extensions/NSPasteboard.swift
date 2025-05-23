import AppKit
import Foundation
import UniformTypeIdentifiers

extension NSPasteboard {
    /// Returns pasteboard data for `type`.
    ///
    /// If `type == .fileURL` **and** `followFileURLs == true`,
    /// the referenced file is read and its bytes are returned;
    /// otherwise the raw pasteboard data is returned.
    func getData(
        forType type: NSPasteboard.PasteboardType,
        followFileURLs: Bool = true
    ) throws -> Data? {
        // Follow file references?
        guard followFileURLs, type == .fileURL else {
            return data(forType: type)
        }

        // Extract URL string (may be “file:///…” or plain path).
        guard let urlString = string(forType: .fileURL) else { return nil }

        let url = URL(string: urlString).flatMap { $0.isFileURL ? $0 : nil }
            ?? URL(fileURLWithPath: urlString)

        return try Data(contentsOf: url)
    }
}

extension NSPasteboard.PasteboardType {
    var isTextType: Bool {
        guard let utType = UTType(rawValue) else {
            return false
        }

        return utType.conforms(to: .text) ||
            utType.conforms(to: .plainText) ||
            utType.conforms(to: .utf8PlainText) ||
            utType.conforms(to: .utf16PlainText) ||
            utType.conforms(to: .utf16ExternalPlainText) ||
            utType.conforms(to: .rtf) ||
            utType.conforms(to: .rtfd) ||
            utType.conforms(to: .html) ||
            utType.conforms(to: .xml) ||
            utType.conforms(to: .sourceCode) ||
            utType.conforms(to: .script)
    }
}
