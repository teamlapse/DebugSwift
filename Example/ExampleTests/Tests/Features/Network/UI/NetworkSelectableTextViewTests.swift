@testable import DebugSwift
import Testing
import UIKit

struct NetworkSelectableTextViewTests {
    @Test("Copy uses the exact selected range")
    @MainActor
    func copySelectedRange() {
        let textView = NetworkSelectableTextView()
        textView.text = "Request response body"
        textView.selectedRange = NSRange(location: 8, length: 8)

        textView.copy(nil)

        #expect(UIPasteboard.general.string == "response")
    }

    @Test("Copy is unavailable without a selection")
    @MainActor
    func copyUnavailableWithoutSelection() {
        let textView = NetworkSelectableTextView()
        textView.text = "Response body"
        textView.selectedRange = NSRange(location: 0, length: 0)

        let canCopy = textView.canPerformAction(#selector(UIResponderStandardEditActions.copy(_:)), withSender: nil)

        #expect(!canCopy)
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
