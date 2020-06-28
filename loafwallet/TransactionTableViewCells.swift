import LocalAuthentication
import UIKit

private let timestampRefreshRate: TimeInterval = 10.0
let kNormalTransactionCellHeight: CGFloat = 70.0
let kMaxTransactionCellHeight: CGFloat = 220.0
let kProgressHeaderHeight: CGFloat = 50.0
let kPromptCellHeight: CGFloat = 120.0

class TransactionTableViewCellv2: UITableViewCell, Subscriber {
    @IBOutlet var staticCommentLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var availabilityLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var commentTextLabel: UILabel!
    @IBOutlet var timedateLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var staticTxIDLabel: UILabel!
    @IBOutlet var txidStringLabel: UILabel!
    @IBOutlet var staticAmountDetailLabel: UILabel!
    @IBOutlet var startingBalanceLabel: UILabel!
    @IBOutlet var endingBalanceLabel: UILabel!
    @IBOutlet var staticBlockLabel: UILabel!
    @IBOutlet var blockLabel: UILabel!
    @IBOutlet var qrModalButton: UIButton!
    @IBOutlet var cardView: UIView!
    @IBOutlet var staticBackgroundView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var copyButton: UIButton!

    @IBOutlet var dropArrowImageView: UIImageView!
    @IBOutlet var expandCardView: UIView!
    @IBOutlet var qrBackgroundView: UIView!

    var didReceiveLitecoin: Bool?
    var showQRModalAction: (() -> Void)?
    var expandCell: (() -> Bool)?
    var isExpanded: Bool = false
    private var timer: Timer?
    private var transaction: Transaction?

    private class TransactionCellWrapper {
        weak var target: TransactionTableViewCellv2?
        init(target: TransactionTableViewCellv2) {
            self.target = target
        }

        @objc func timerDidFire() {
            target?.updateTimestamp()
        }
    }

    @IBAction func didTapCopy(_: Any) {
        guard let transactionAddress = transaction?.toAddress else {
            NSLog("ERROR: Address not set")
            return
        }

        UIPasteboard.general.string = transactionAddress
    }

    // MARK: - Public

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    deinit {
        timer?.invalidate()
    }

    func updateTimestamp() {
        guard let tx = transaction else { return }
        let timestampInfo = tx.timeSince
        timedateLabel.text = timestampInfo.0
        if !timestampInfo.1 {
            timer?.invalidate()
        }
    }

    func setupViews() {
        // TODO: polish when successful compiling happens

        staticTxIDLabel.text = S.Transaction.txIDLabel.lowercased()
        staticAmountDetailLabel.text = S.Transaction.amountDetailLabel.lowercased()
        staticBlockLabel.text = S.Transaction.blockHeightLabel.lowercased()
        staticCommentLabel.text = S.Transaction.commentLabel.lowercased()

        backgroundColor = .white
        staticBackgroundView.backgroundColor = .liteWalletBlue
        qrModalButton.setImage(UIImage(named: "genericqricon"), for: .normal)
    }

    func setTransaction(_ transaction: Transaction, isLtcSwapped: Bool, rate: Rate, maxDigits: Int, isSyncing: Bool) {
        self.transaction = transaction
        expandCardView.alpha = 0.0

        amountLabel.attributedText = transaction.descriptionString(isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: maxDigits)
        addressLabel.text = String(format: transaction.direction.addressTextFormat, transaction.toAddress ?? "")
        statusLabel.text = transaction.status
        commentTextLabel.text = transaction.comment
        blockLabel.text = transaction.blockHeight
        txidStringLabel.text = transaction.hash
        availabilityLabel.text = transaction.shouldDisplayAvailableToSpend ? S.Transaction.available : ""
        arrowImageView.image = UIImage(named: "black-circle-arrow-right")?.withRenderingMode(.alwaysTemplate)
        startingBalanceLabel.text = transaction.amountDetailsStartingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: [rate], maxDigits: maxDigits)
        endingBalanceLabel.text = transaction.amountDetailsEndingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: [rate], maxDigits: maxDigits)
        dropArrowImageView.image = UIImage(named: "modeDropArrow")

        if #available(iOS 11.0, *) {
            guard let textColor = UIColor(named: "labelTextColor") else {
                NSLog("ERROR: Custom color not found")
                return
            }

            guard let backgroundColor = UIColor(named: "inverseBackgroundViewColor") else {
                NSLog("ERROR: Custom color not found")
                return
            }

            amountLabel.textColor = textColor
            addressLabel.textColor = textColor
            commentTextLabel.textColor = textColor
            statusLabel.textColor = textColor
            timedateLabel.textColor = textColor

            staticCommentLabel.textColor = textColor
            staticTxIDLabel.textColor = textColor
            staticAmountDetailLabel.textColor = textColor
            staticBlockLabel.textColor = textColor

            qrBackgroundView.backgroundColor = backgroundColor

        } else {
            commentTextLabel.textColor = .darkText
            statusLabel.textColor = .darkText
            timedateLabel.textColor = .darkText

            staticCommentLabel.textColor = .darkText
            staticTxIDLabel.textColor = .darkText
            staticAmountDetailLabel.textColor = .darkText
            staticBlockLabel.textColor = .darkText

            qrBackgroundView.backgroundColor = .white
        }

        if transaction.status == S.Transaction.complete {
            statusLabel.isHidden = false
        } else {
            statusLabel.isHidden = isSyncing
        }

        let timestampInfo = transaction.timeSince
        timedateLabel.text = timestampInfo.0
        if timestampInfo.1 {
            timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: TransactionCellWrapper(target: self), selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
        timedateLabel.isHidden = !transaction.isValid

        let identity: CGAffineTransform = .identity
        if transaction.direction == .received {
            arrowImageView.transform = identity.rotated(by: π / 2.0)
            arrowImageView.tintColor = .txListGreen
        } else {
            arrowImageView.transform = identity.rotated(by: 3.0 * π / 2.0)
            arrowImageView.tintColor = .cameraGuideNegative
        }

        if transaction.direction == .received {
            qrModalButton.isHidden = false
        } else {
            qrModalButton.isHidden = true
        }
    }

    override func setSelected(_: Bool, animated _: Bool) {}

    override func setHighlighted(_: Bool, animated _: Bool) {}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func didTapQRButtonAction(_: Any) {
        showQRModalAction?()
    }
}

enum PromptType {
    case biometrics
    case paperKey
    case upgradePin
    case recommendRescan
    case noPasscode
    case shareData

    static var defaultOrder: [PromptType] = {
        [.recommendRescan, .upgradePin, .paperKey, .noPasscode, .biometrics, .shareData]
    }()

    var title: String {
        switch self {
        case .biometrics: return LAContext.biometricType() == .face ? S.Prompts.FaceId.title : S.Prompts.TouchId.title
        case .paperKey: return S.Prompts.PaperKey.title
        case .upgradePin: return S.Prompts.SetPin.title
        case .recommendRescan: return S.Prompts.RecommendRescan.title
        case .noPasscode: return S.Prompts.NoPasscode.title
        case .shareData: return S.Prompts.ShareData.title
        }
    }

    var name: String {
        switch self {
        case .biometrics: return "biometricsPrompt"
        case .paperKey: return "paperKeyPrompt"
        case .upgradePin: return "upgradePinPrompt"
        case .recommendRescan: return "recommendRescanPrompt"
        case .noPasscode: return "noPasscodePrompt"
        case .shareData: return "shareDataPrompt"
        }
    }

    var body: String {
        switch self {
        case .biometrics: return LAContext.biometricType() == .face ? S.Prompts.FaceId.body : S.Prompts.TouchId.body
        case .paperKey: return S.Prompts.PaperKey.body
        case .upgradePin: return S.Prompts.SetPin.body
        case .recommendRescan: return S.Prompts.RecommendRescan.body
        case .noPasscode: return S.Prompts.NoPasscode.body
        case .shareData: return S.Prompts.ShareData.body
        }
    }

    // This is the trigger that happens when the prompt is tapped
    var trigger: TriggerName? {
        switch self {
        case .biometrics: return .promptBiometrics
        case .paperKey: return .promptPaperKey
        case .upgradePin: return .promptUpgradePin
        case .recommendRescan: return .recommendRescan
        case .noPasscode: return nil
        case .shareData: return .promptShareData
        }
    }

    func shouldPrompt(walletManager: WalletManager, state: State) -> Bool {
        switch self {
        case .biometrics:
            return !UserDefaults.hasPromptedBiometrics && LAContext.canUseBiometrics && !UserDefaults.isBiometricsEnabled
        case .paperKey:
            return UserDefaults.walletRequiresBackup
        case .upgradePin:
            return walletManager.pinLength != 6
        case .recommendRescan:
            return state.recommendRescan
        case .noPasscode:
            return !LAContext.isPasscodeEnabled
        case .shareData:
            return !UserDefaults.hasAquiredShareDataPermission && !UserDefaults.hasPromptedShareData
        }
    }
}

class PromptTableViewCell: UITableViewCell {
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var tapButton: UIButton!

    var type: PromptType?
    var didClose: (() -> Void)?
    var didTap: (() -> Void)?

    @IBAction func didTapAction(_: Any) {
        didTap?()
    }

    @IBAction func closeAction(_: Any) {
        didClose?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
