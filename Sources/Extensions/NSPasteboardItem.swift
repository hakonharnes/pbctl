import AppKit
import UniformTypeIdentifiers

extension NSPasteboard.PasteboardType {
    var mimeType: String? {
        guard let ut = UTType(rawValue) else { return nil }
        return ut.preferredMIMEType
    }
}
