import FirebaseAnalytics
import Foundation
import LocalAuthentication
import UIKit

class DynamicDonationViewController: UIViewController, Subscriber {
    @IBOutlet var dialogView: UIView!
    @IBOutlet var dialogTitle: UILabel!

    @IBOutlet var staticSendLabel: UILabel!
    @IBOutlet var processingTimeLabel: UILabel!

    @IBOutlet var sendAmountLabel: UILabel!
    @IBOutlet var donationAddressLabel: UILabel!

    @IBOutlet var staticAmountToDonateLabel: UILabel!
    @IBOutlet var staticNetworkFeeLabel: UILabel!
    @IBOutlet var staticTotalCostLabel: UILabel!

    @IBOutlet var networkFeeLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var accountPickerView: UIPickerView!
    @IBOutlet var donationSlider: UISlider!
    @IBOutlet var decreaseDonationButton: UIButton!
    @IBOutlet var increaseDonationButton: UIButton!
    @IBOutlet var donationValueLabel: UILabel!

    var cancelButton = ShadowButton(title: S.Button.cancel, type: .secondary)
    var donateButton = ShadowButton(title: S.Donate.word, type: .flatLitecoinBlue, image: LAContext.biometricType() == .face ? #imageLiteral(resourceName: "FaceId") : #imageLiteral(resourceName: "TouchId"))

    var successCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?

    var store: Store?
    var feeType: FeeType?
    var senderClass: Sender?
    var selectedRate: Rate?
    var isUsingBiometrics: Bool = false
    var balance: UInt64 = 0
    var finalDonationAmount = Satoshis(rawValue: kDonationAmount)
    var finalDonationAddress = LWDonationAddress.litwalletHardware.address
    var finalDonationMemo = LWDonationAddress.litwalletHardware.rawValue

    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    let impactFeedbackGenerator: (
        light: UIImpactFeedbackGenerator,
        heavy: UIImpactFeedbackGenerator
    ) = (
        UIImpactFeedbackGenerator(style: .light),
        UIImpactFeedbackGenerator(style: .heavy)
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureDataAndFunction()
    }

    private func configureViews() {
        selectionFeedbackGenerator.prepare()
        impactFeedbackGenerator.light.prepare()
        impactFeedbackGenerator.heavy.prepare()
        dialogView.layer.cornerRadius = 6.0
        dialogView.layer.masksToBounds = true

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)

        dialogTitle.text = S.Donate.titleConfirmation
        staticSendLabel.text = S.Confirmation.staticAddressLabel.capitalizingFirstLetter()
        staticAmountToDonateLabel.text = S.Confirmation.donateLabel
        staticNetworkFeeLabel.text = S.Confirmation.feeLabel
        staticTotalCostLabel.text = S.Confirmation.totalLabel
        donationAddressLabel.text = LWDonationAddress.litwalletHardware.address

        processingTimeLabel.text = String(format: S.Confirmation.processingAndDonationTime, "2.5-5")

        donationSlider.setValue(Float(kDonationAmount / balance), animated: true)
        donationSlider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        donationSlider.minimumValue = Float(Double(kDonationAmount) / Double(balance))
        donationSlider.maximumValue = 1.0

        let amount = Satoshis(rawValue: UInt64(kDonationAmount))
        updateDonationLabels(donationAmount: amount)
        setupButtonLayouts()
    }

    private func setupButtonLayouts() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        donateButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(cancelButton)
        buttonsView.addSubview(donateButton)

        let viewsDictionary = ["cancelButton": cancelButton, "donateButton": donateButton]
        var viewConstraints = [NSLayoutConstraint]()

        let constraintsHorizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelButton(170)]-8-[donateButton(170)]-10-|", options: [], metrics: nil, views: viewsDictionary)
        viewConstraints += constraintsHorizontal

        let cancelConstraintVertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[cancelButton]-|", options: [], metrics: nil, views: viewsDictionary)
        viewConstraints += cancelConstraintVertical

        let sendConstraintVertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[donateButton]-|", options: [], metrics: nil, views: viewsDictionary)

        viewConstraints += sendConstraintVertical
        NSLayoutConstraint.activate(viewConstraints)
    }

    private func configureDataAndFunction() {
        cancelButton.tap = strongify(self) { myself in
            myself.cancelCallback?()
            LWAnalytics.logEventWithParameters(itemName: ._20200225_DCD)
        }
        donateButton.tap = strongify(self) { myself in
            myself.successCallback?()
        }

        guard let store = store else {
            NSLog("ERROR: Store not initialized")
            return
        }

        store.subscribe(self, selector: { $0.walletState.balance != $1.walletState.balance },
                        callback: {
                            if let balance = $0.walletState.balance {
                                self.balance = balance
                            }
        })
    }

    private func maxAmountLessFees() -> Float {
        var adjustedBalance = Float(Double(balance))
        if let sender = senderClass {
            let maxFee = sender.feeForTx(amount: balance)
            adjustedBalance = Float(Double(balance) - Double(maxFee))
        }
        return adjustedBalance
    }

    private func updateDonationLabels(donationAmount: Satoshis) {
        guard let sender = senderClass else {
            NSLog("ERROR: Sender not initialized")
            return
        }
        guard let state = store?.state else {
            NSLog("ERROR: State not initialized")
            return
        }

        finalDonationAmount = donationAmount
        sendAmountLabel.text = DisplayAmount(amount: donationAmount, state: state, selectedRate: state.currentRate, minimumFractionDigits: 2).combinedDescription
        let feeAmount = sender.feeForTx(amount: donationAmount.rawValue)
        networkFeeLabel.text = DisplayAmount(amount: Satoshis(rawValue: feeAmount), state: state, selectedRate: state.currentRate, minimumFractionDigits: 2).combinedDescription.combinedFeeReplacingZeroFeeWithOneCent()
        totalCostLabel.text = DisplayAmount(amount: donationAmount + Satoshis(rawValue: feeAmount), state: state, selectedRate: state.currentRate, minimumFractionDigits: 2).combinedDescription
        donationValueLabel.text = totalCostLabel.text
    }

    @objc func sliderDidChange() {
        let newDonationValue = donationSlider.value * maxAmountLessFees()
        updateDonationLabels(donationAmount: Satoshis(rawValue: UInt64(newDonationValue)))
        selectionFeedbackGenerator.selectionChanged()
    }

    @IBAction func reduceDonationAction(_: Any) {
        impactFeedbackGenerator.light.impactOccurred()

        if donationSlider.value >= Float(kDonationAmount / balance) {
            let newValue = donationSlider.value - Float(Double(1_000_000) / Double(balance))
            if newValue >= donationSlider.minimumValue {
                donationSlider.setValue(newValue, animated: true)
                let newDonationValue = donationSlider.value * maxAmountLessFees()
                updateDonationLabels(donationAmount: Satoshis(rawValue: UInt64(newDonationValue)))
            }
        }
    }

    @IBAction func increaseDonationAction(_: Any) {
        impactFeedbackGenerator.heavy.impactOccurred()

        let newValue = donationSlider.value + Float(Double(1_000_000) / Double(balance))
        if newValue <= 1.0 {
            donationSlider.setValue(newValue, animated: true)
            let newDonationValue = donationSlider.value * maxAmountLessFees()
            updateDonationLabels(donationAmount: Satoshis(rawValue: UInt64(newDonationValue)))
        }
    }
}

extension DynamicDonationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return LWDonationAddress.allValues.count
    }

    func pickerView(_: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing _: UIView?) -> UIView {
        let title = S.Donate.toThe + " " + LWDonationAddress.allValues[row].rawValue
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.barlowRegular(size: 17), NSAttributedString.Key.foregroundColor: UIColor.black])
        return label
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        donationAddressLabel.text = LWDonationAddress.allValues[row].address
        finalDonationAddress = LWDonationAddress.allValues[row].address
        finalDonationMemo = LWDonationAddress.allValues[row].rawValue
    }
}
