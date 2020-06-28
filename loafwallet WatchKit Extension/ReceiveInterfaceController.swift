import UIKit
import WatchKit
class ReceiveInterfaceController: WKInterfaceController {
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var label: WKInterfaceLabel!

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveInterfaceController.runUpdate), name: .ApplicationDataDidUpdateNotification, object: nil)
        runUpdate()
    }

    @objc func runUpdate() {
        guard let data = WatchDataManager.shared.data else { return }
        image.setImage(data.qrCode)
    }
}
