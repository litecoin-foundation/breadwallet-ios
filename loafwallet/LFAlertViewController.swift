import UIKit

enum LFAlertType: Int {
    case singleButton
    case twoButton
}

protocol LFAlertViewDelegate: AnyObject {
    // func okButtonTapped(selectedOption: String, textFieldValue: String)
    func alertViewCancelButtonTapped()
}

class LFAlertViewController: UIViewController {
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var dynamicLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!

    @IBOutlet var alertModalView: UIView!
    var delegate: LFAlertViewDelegate?

    @IBAction func didCancelRegistrationAction(_: Any) {
        activityIndicatorView.stopAnimating()
        delegate?.alertViewCancelButtonTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        activityIndicatorView.startAnimating()
        alertModalView.layer.cornerRadius = 15
        alertModalView.clipsToBounds = true
    }
}
