import Foundation
import UIKit

class WarningConfirmationViewController: UIViewController {
    @IBOutlet var warningContentTextView: UITextView!
    @IBOutlet var confirmButton: UIButton!

    override func viewDidLoad() {
        title = "Paper Phrase Warning"
    }
}
