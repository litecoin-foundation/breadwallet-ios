import Foundation
import UIKit

class SendLTCViewController: UIViewController {
    var store: Store?

    override func viewDidLoad() {}

    override func viewWillAppear(_: Bool) {
        guard let store = self.store else {
            NSLog("ERROR: Store is not initialized")
            return
        }

        store.perform(action: RootModalActions.Present(modal: .send))
    }
}
