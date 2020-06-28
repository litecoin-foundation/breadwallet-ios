import LitewalletPartnerAPI
import UIKit

class CardViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet var cardViewHeight: NSLayoutConstraint! // 200 pixels Start
    @IBOutlet var cardShadowView: LitecoinCardImageView!
    @IBOutlet var litecoinCardDepositStatusLabel: UILabel!

    @IBOutlet var staticCardBalanceLabel: UILabel!
    @IBOutlet var cardBalanceLabel: UILabel!
    @IBOutlet var circleButtonContainerView: UIView!

    @IBOutlet var upAmountButton: UIButton!
    @IBOutlet var downAmountButton: UIButton!

    @IBOutlet var fiatLTCSegmentedControl: UISegmentedControl!

    @IBOutlet var transferTextField: UITextField!

    @IBOutlet var staticLitewalletBalanceLabel: UILabel!
    @IBOutlet var litewalletBalanceLabel: UILabel!

    @IBOutlet var transferButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!

    var litecoinCardAccountData: [String: Any]?
    var userHasLitecoinCard: Bool = false
    var shouldTransferToLitewallet: Bool = true

    private let blueUpArrow = UIImage(named: "up-arrow-blue")
    private let blueDownArrow = UIImage(named: "down-arrow-blue")
    private let greyUpArrow = UIImage(named: "up-arrow-gray")
    private let greyDownArrow = UIImage(named: "down-arrow-gray")

    var localFiatCode = "USD"
    var exchangeRate: Rate? {
        didSet { updateFiatCode() }
    }

    @IBAction func didTapUpArrowAction(_: Any) {
        downAmountButton.setImage(greyDownArrow, for: .normal)
        upAmountButton.setImage(blueUpArrow, for: .normal)
        shouldTransferToLitewallet = false
        litecoinCardDepositStatusLabel.text = S.LitecoinCard.depositToCard
    }

    @IBAction func didTapDownArrowAction(_: Any) {
        downAmountButton.setImage(blueDownArrow, for: .normal)
        upAmountButton.setImage(greyUpArrow, for: .normal)
        shouldTransferToLitewallet = true
        litecoinCardDepositStatusLabel.text = S.LitecoinCard.transferToLitewallet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewWillAppear(_: Bool) {}

    private func updateFiatCode() {
        if let code = exchangeRate?.code {
            localFiatCode = code
        }
    }

    private func setupSubviews() {
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.barlowBold(size: 18)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.barlowBold(size: 18)], for: .normal)

        automaticallyAdjustsScrollViewInsets = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true

        transferButton.setTitle(S.LitecoinCard.transferButtonTitle, for: .normal)
        transferButton.layer.cornerRadius = 5.0

        // Setup card view dimensions
        switch E.screenHeight {
        case 0 ..< 320:
            cardViewHeight.constant = 90
        case 320 ..< 564:
            cardViewHeight.constant = 150
        case 564 ..< 768:
            cardViewHeight.constant = 200
        case 768 ..< 2000:
            cardViewHeight.constant = 300
        default:
            cardViewHeight.constant = 200
        }

        // Setup corners
        circleButtonContainerView.layer.cornerRadius = (circleButtonContainerView.frame.height / 2)
        circleButtonContainerView.clipsToBounds = true
        circleButtonContainerView.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)
        circleButtonContainerView.layer.borderWidth = 2.0
        circleButtonContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        fiatLTCSegmentedControl.setTitle("LTC", forSegmentAt: 0)
        fiatLTCSegmentedControl.setTitle(localFiatCode, forSegmentAt: 1)

        if shouldTransferToLitewallet {
            downAmountButton.setImage(blueDownArrow, for: .normal)
            upAmountButton.setImage(greyUpArrow, for: .normal)
            litecoinCardDepositStatusLabel.text = S.LitecoinCard.transferToLitewallet
        }
        // TODO: Build out later
        //let maxButton = UIButton.textFieldMaxAmount(height: transferTextField.frame.height)

        view.layoutIfNeeded()
    }

    @objc private func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            let yPosition = transferTextField.frame.origin.y

            scrollView.contentInset = UIEdgeInsets(top: 0 - yPosition, left: 0, bottom: keyboardViewEndFrame.height - view.frame.height, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }

    private func presentLitecoinCardAccountDetails() {}
}
