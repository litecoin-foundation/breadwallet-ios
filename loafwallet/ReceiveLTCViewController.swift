import UIKit

struct WalletAddressData {
    var address: String
    var qrCode: UIImage
    var balance: Double
    var balanceText: String {
        String(balance) + " Ł"
    }
}

class ReceiveLTCViewController: UIViewController {
    var store: Store?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_: Bool) {
        guard let store = self.store else {
            NSLog("ERROR: Store is not initialized")
            return
        }

        store.perform(action: RootModalActions.Present(modal: .receive))
    }
}
