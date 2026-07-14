@testable import DebugSwift
import Testing
import UIKit

struct NetworkTextSelectionTests {
    @Test("Native copy uses the exact selected range")
    @MainActor
    func copySelectedRange() {
        let cell = NetworkTableViewCellDetail(style: .default, reuseIdentifier: nil)
        let textView = cell.details
        textView.text = "Request response body"
        textView.selectedRange = NSRange(location: 8, length: 8)

        textView.copy(nil)

        #expect(UIPasteboard.general.string == "response")
    }

    @Test("HTTP details use native selectable text")
    @MainActor
    func nativeSelectableText() {
        let cell = NetworkTableViewCellDetail(style: .default, reuseIdentifier: nil)

        #expect(cell.details.isSelectable)
        #expect(!cell.details.isEditable)
    }

    @Test("Section copy uses the complete displayed value")
    @MainActor
    func copyCompleteSection() {
        let model = HttpModel()
        model.url = URL(string: "https://api.yap.app/graphql")
        let viewController = NetworkViewControllerDetail(model: model)

        viewController.copySection(atDisplayedIndex: 0)

        #expect(UIPasteboard.general.string == "https://api.yap.app/graphql")
    }
}
