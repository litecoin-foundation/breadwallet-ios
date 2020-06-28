import UIKit

class UnEditableTextView: UITextView {
    override var canBecomeFirstResponder: Bool {
        return false
    }
}
