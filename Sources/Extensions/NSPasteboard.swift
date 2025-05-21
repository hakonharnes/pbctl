import AppKit
import Foundation

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
