import UIKit

class LFModalReceiveQRViewController: UIViewController {
    @IBOutlet var modalView: UIView!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var receiveModalTitleLabel: UILabel!

    var dismissQRModalAction: (() -> Void)?

    @IBAction func didCancelAction(_: Any) {
        dismissQRModalAction?()
    }

    override func viewWillAppear(_: Bool) {}

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        modalView.layer.cornerRadius = 15
        modalView.clipsToBounds = true

        addressLabel.text = ""
        receiveModalTitleLabel.text = ""
    }
}
