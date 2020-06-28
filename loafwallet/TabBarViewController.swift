import Foundation
import SwiftyJSON
import UIKit

enum TabViewControllerIndex: Int {
    case transactions = 0
    case send = 1
    case spendOrCard = 2
    case receive = 3
    case buy = 4
}

protocol MainTabBarControllerDelegate {
    func alertViewShouldDismiss()
}

class TabBarViewController: UIViewController, Subscriber, Trackable, UITabBarDelegate, LitecoinCardRegistrationViewDelegate, LitecoinCardLoginViewDelegate {
    let kInitialChildViewControllerIndex = 0 // History  VC
    @IBOutlet var headerView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var currentLTCPriceLabel: UILabel!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var timeStampStackView: UIStackView!
    @IBOutlet var timeStampStackViewHeight: NSLayoutConstraint!

    @IBOutlet var floatingRegistrationView: UIView!
    @IBOutlet var registrationTitleLabel: UILabel!

    var primaryBalanceLabel: UpdatingLabel?
    var secondaryBalanceLabel: UpdatingLabel?
    private let largeFontSize: CGFloat = 24.0
    private let smallFontSize: CGFloat = 12.0
    private var hasInitialized = false
    private let dateFormatter = DateFormatter()
    private let equalsLabel = UILabel(font: .barlowMedium(size: 12), color: .whiteTint)
    private var regularConstraints: [NSLayoutConstraint] = []
    private var swappedConstraints: [NSLayoutConstraint] = []
    private let currencyTapView = UIView()
    private let storyboardNames: [String] = ["Transactions", "Send", "Spend", "Receive", "Buy"]
    var storyboardIDs: [String] = ["TransactionsViewController", "SendLTCViewController", "CardLoginViewController", "ReceiveLTCViewController", "BuyTableViewController"]
    var viewControllers: [UIViewController] = []
    var activeController: UIViewController?

    var delegate: MainTabBarControllerDelegate?

    var updateTimer: Timer?
    var store: Store?
    var walletManager: WalletManager?
    var exchangeRate: Rate? {
        didSet { setBalances() }
    }

    private var balance: UInt64 = 0 {
        didSet { setBalances() }
    }

    var isLtcSwapped: Bool? {
        didSet { setBalances() }
    }

    @IBAction func showSettingsAction(_: Any) {
        guard let store = self.store else {
            NSLog("ERROR: Store not set")
            return
        }
        store.perform(action: RootModalActions.Present(modal: .menu))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if userHasLitecoinCard(), litecoinCardAccessTokenIsValid() {
            // Switch VC to CardViewController
            storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "CardViewController", "ReceiveLTCViewController", "BuyTableViewController"]
            loadViewControllers()
        } else {
            storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "CardLoginViewController", "ReceiveLTCViewController", "BuyTableViewController"]
        }

        setupViews()
        configurePriceLabels()
        addSubscriptions()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")

        loadViewControllers()

        updateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.setBalances()
        }

        guard let array = tabBar.items as? [UITabBarItem] else {
            NSLog("ERROR: no items found")
            return
        }

        tabBar.selectedItem = array[kInitialChildViewControllerIndex]
    }

    deinit {
        self.updateTimer = nil
    }

    private func setupViews() {
        if #available(iOS 11.0, *),
            let backgroundColor = UIColor(named: "mainColor") {
            headerView.backgroundColor = backgroundColor
            tabBar.barTintColor = backgroundColor
            containerView.backgroundColor = backgroundColor
            self.view.backgroundColor = backgroundColor
        } else {
            headerView.backgroundColor = .liteWalletBlue
            tabBar.barTintColor = .liteWalletBlue
            containerView.backgroundColor = .liteWalletBlue
            view.backgroundColor = .liteWalletBlue
        }

        registrationTitleLabel.text = S.LitecoinCard.title
        registrationTitleLabel.layer.cornerRadius = 10.0
        registrationTitleLabel.clipsToBounds = true
        floatingRegistrationView.isHidden = true
    }

    private func loadViewControllers() {
        viewControllers.removeAll()
        for (index, storyboardID) in storyboardIDs.enumerated() {
            let controller = UIStoryboard(name: storyboardNames[index], bundle: nil).instantiateViewController(withIdentifier: storyboardID)
            viewControllers.append(controller)
        }
    }

    private func configurePriceLabels() {
        // TODO: Debug the reizing of label...very important
        guard let primaryLabel = primaryBalanceLabel,
            let secondaryLabel = secondaryBalanceLabel else {
            NSLog("ERROR: Price labels not initialized")
            return
        }

        let priceLabelArray = [primaryBalanceLabel, secondaryBalanceLabel, equalsLabel]

        priceLabelArray.enumerated().forEach { _, view in
            view?.backgroundColor = .clear
            view?.textColor = .white
        }

        primaryLabel.font = UIFont.barlowSemiBold(size: largeFontSize)
        secondaryLabel.font = UIFont.barlowSemiBold(size: largeFontSize)

        equalsLabel.text = "="
        headerView.addSubview(primaryLabel)
        headerView.addSubview(secondaryLabel)
        headerView.addSubview(equalsLabel)
        headerView.addSubview(currencyTapView)

        secondaryLabel.constrain([
            secondaryLabel.constraint(.firstBaseline, toView: primaryLabel, constant: 0.0),
        ])

        equalsLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        regularConstraints = [
            primaryLabel.firstBaselineAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            primaryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: C.padding[1] * 1.25),
            equalsLabel.firstBaselineAnchor.constraint(equalTo: primaryLabel.firstBaselineAnchor, constant: 0),
            equalsLabel.leadingAnchor.constraint(equalTo: primaryLabel.trailingAnchor, constant: C.padding[1] / 2.0),
            secondaryLabel.leadingAnchor.constraint(equalTo: equalsLabel.trailingAnchor, constant: C.padding[1] / 2.0),
        ]

        swappedConstraints = [
            secondaryLabel.firstBaselineAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            secondaryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: C.padding[1] * 1.25),
            equalsLabel.firstBaselineAnchor.constraint(equalTo: secondaryLabel.firstBaselineAnchor, constant: 0),
            equalsLabel.leadingAnchor.constraint(equalTo: secondaryLabel.trailingAnchor, constant: C.padding[1] / 2.0),
            primaryLabel.leadingAnchor.constraint(equalTo: equalsLabel.trailingAnchor, constant: C.padding[1] / 2.0),
        ]

        if let isLTCSwapped = isLtcSwapped {
            NSLayoutConstraint.activate(isLTCSwapped ? swappedConstraints : regularConstraints)
        }

        currencyTapView.constrain([
            currencyTapView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            currencyTapView.trailingAnchor.constraint(equalTo: timeStampStackView.leadingAnchor, constant: 0),
            currencyTapView.topAnchor.constraint(equalTo: primaryLabel.topAnchor, constant: 0),
            currencyTapView.bottomAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: C.padding[1]),
        ])

        let gr = UITapGestureRecognizer(target: self, action: #selector(currencySwitchTapped))
        currencyTapView.addGestureRecognizer(gr)
    }

    private func addSubscriptions() {
        guard let store = self.store else {
            NSLog("ERROR - Store not passed")
            return
        }

        guard let primaryLabel = primaryBalanceLabel,
            let secondaryLabel = secondaryBalanceLabel else {
            NSLog("ERROR: Price labels not initialized")
            return
        }

        store.subscribe(self, selector: { $0.walletState.syncProgress != $1.walletState.syncProgress },
                        callback: { _ in
                            self.tabBar.selectedItem = self.tabBar.items?.first
        })

        store.lazySubscribe(self,
                            selector: { $0.isLtcSwapped != $1.isLtcSwapped },
                            callback: { self.isLtcSwapped = $0.isLtcSwapped })
        store.lazySubscribe(self,
                            selector: { $0.currentRate != $1.currentRate },
                            callback: {
                                if let rate = $0.currentRate {
                                    let placeholderAmount = Amount(amount: 0, rate: rate, maxDigits: $0.maxDigits)
                                    secondaryLabel.formatter = placeholderAmount.localFormat
                                    primaryLabel.formatter = placeholderAmount.ltcFormat
                                }
                                self.exchangeRate = $0.currentRate
        })

        store.lazySubscribe(self,
                            selector: { $0.maxDigits != $1.maxDigits },
                            callback: {
                                if let rate = $0.currentRate {
                                    let placeholderAmount = Amount(amount: 0, rate: rate, maxDigits: $0.maxDigits)
                                    secondaryLabel.formatter = placeholderAmount.localFormat
                                    primaryLabel.formatter = placeholderAmount.ltcFormat
                                    self.setBalances()
                                }
        })

        store.subscribe(self,
                        selector: { $0.walletState.balance != $1.walletState.balance },
                        callback: { state in
                            if let balance = state.walletState.balance {
                                self.balance = balance
                                self.setBalances()
                            }
                        })
    }

    private func setBalances() {
        guard let rate = exchangeRate, let store = self.store, let isLTCSwapped = isLtcSwapped else {
            NSLog("ERROR: Rate, Store not initialized")
            return
        }
        guard let primaryLabel = primaryBalanceLabel,
            let secondaryLabel = secondaryBalanceLabel else {
            NSLog("ERROR: Price labels not initialized")
            return
        }

        let amount = Amount(amount: balance, rate: rate, maxDigits: store.state.maxDigits)

        if !hasInitialized {
            let amount = Amount(amount: balance, rate: exchangeRate!, maxDigits: store.state.maxDigits)
            NSLayoutConstraint.deactivate(isLTCSwapped ? regularConstraints : swappedConstraints)
            NSLayoutConstraint.activate(isLTCSwapped ? swappedConstraints : regularConstraints)
            primaryLabel.setValue(amount.amountForLtcFormat)
            secondaryLabel.setValue(amount.localAmount)
            if isLTCSwapped {
                primaryLabel.transform = transform(forView: primaryLabel)
            } else {
                secondaryLabel.transform = transform(forView: secondaryLabel)
            }
            hasInitialized = true
        } else {
            if primaryLabel.isHidden {
                primaryLabel.isHidden = false
            }

            if secondaryLabel.isHidden {
                secondaryLabel.isHidden = false
            }
        }

        primaryLabel.setValue(amount.amountForLtcFormat)
        secondaryLabel.setValue(amount.localAmount)

        if !isLTCSwapped {
            primaryLabel.transform = .identity
            secondaryLabel.transform = transform(forView: secondaryLabel)
        } else {
            secondaryLabel.transform = .identity
            primaryLabel.transform = transform(forView: primaryLabel)
        }

        timeStampLabel.text = S.TransactionDetails.priceTimeStampLabel + " " + dateFormatter.string(from: Date())
        let fiatRate = Double(round(100 * rate.rate) / 100)
        let formattedFiatString = String(format: "%.02f", fiatRate)
        currentLTCPriceLabel.text = Currency.getSymbolForCurrencyCode(code: rate.code)! + formattedFiatString
    }

    private func transform(forView: UIView) -> CGAffineTransform {
        forView.transform = .identity // Must reset the view's transform before we calculate the next transform
        let scaleFactor: CGFloat = smallFontSize / largeFontSize
        let deltaX = forView.frame.width * (1 - scaleFactor)
        let deltaY = forView.frame.height * (1 - scaleFactor)
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        return scale.translatedBy(x: -deltaX, y: deltaY / 2.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let array = tabBar.items as? [UITabBarItem] else {
            NSLog("ERROR: no items found")
            return
        }

        array.forEach { item in

            switch item.tag {
            case 0: item.title = S.History.barItemTitle
            case 1: item.title = S.Send.barItemTitle
            case 2: item.title = S.Spend.barItemTitle
            case 3: item.title = S.Receive.barItemTitle
            case 4: item.title = S.BuyCenter.barItemTitle
            default:
                item.title = "XXXXXX"
                NSLog("ERROR: UITabbar item count is wrong")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayContentController(contentController: viewControllers[kInitialChildViewControllerIndex])
    }

    // MARK: LitecoinCard Login Delegates

    func shouldShowLoginView() {
        //
    }

    func didLoginLitecoinCardAccount() {
        storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "CardViewController", "ReceiveLTCViewController", "BuyTableViewController"]
        loadViewControllers()
        displayContentController(contentController: viewControllers[2])
    }

    func didForgetPassword() {
        //
    }

    func shouldShowRegistrationView() {
        storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "SpendViewController", "ReceiveLTCViewController", "BuyTableViewController"]
        loadViewControllers()
        displayContentController(contentController: viewControllers[2])
    }

    // MARK: LitecoinCard Registration Delegates

    func floatingRegistrationHeader(shouldHide _: Bool) {
        //
    }

    func shouldReturnToLoginView() {
        storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "CardLoginViewController", "ReceiveLTCViewController", "BuyTableViewController"]
        loadViewControllers()
        displayContentController(contentController: viewControllers[2])
    }

    func didReceiveOpenLitecoinCardAccount(account _: Data) {
        storyboardIDs = ["TransactionsViewController", "SendLTCViewController", "CardViewController", "ReceiveLTCViewController", "BuyTableViewController"]
        loadViewControllers()
        displayContentController(contentController: viewControllers[2])
    }

    func litecoinCardAccountExists(error _: Error) {
        //
    }

    private func litecoinCardAccessTokenIsValid() -> Bool {
        // DEV Code: This is set to the opposite until the endpoints work
        // Secure keychain to get the token
        if let _ = UserDefaults.standard.string(forKey: tokenDoesExistAndIsValid) {
            return true
        } else {
            return false
        }
        return false
    }

    private func userHasLitecoinCard() -> Bool {
        // DEV Code: This is set to the opposite until the endpoints work

        if let _ = UserDefaults.standard.string(forKey: timeSinceLastLitecoinCardRequest) {
            return true
        } else {
            return false
        }
        return false
    }

    // MARK: TabViewController Delegates

    func displayContentController(contentController: UIViewController) {
        print(" class: XX \(contentController.classForCoder)")
        switch NSStringFromClass(contentController.classForCoder) {
        case "loafwallet.TransactionsViewController":

            guard let transactionVC = contentController as? TransactionsViewController else {
                return
            }

            transactionVC.store = store
            transactionVC.walletManager = walletManager
            transactionVC.isLtcSwapped = store?.state.isLtcSwapped

        case "loafwallet.SendLTCViewController":
            guard let sendVC = contentController as? SendLTCViewController else {
                return
            }
            sendVC.store = store

        case "loafwallet.SpendViewController":
            guard let spendVC = contentController as? SpendViewController else {
                return
            }
            spendVC.delegate = self

        case "loafwallet.CardLoginViewController":
            guard let cardLoginVC = contentController as? CardLoginViewController else {
                return
            }
            cardLoginVC.delegate = self

        case "loafwallet.CardViewController":
            guard let cardVC = contentController as? CardViewController else {
                return
            }
            cardVC.userHasLitecoinCard = userHasLitecoinCard()

        case "loafwallet.ReceiveLTCViewController":
            guard let receiveVC = contentController as? ReceiveLTCViewController else {
                return
            }
            receiveVC.store = store

        case "loafwallet.BuyTableViewController":
            guard let buyVC = contentController as? BuyTableViewController else {
                return
            }
            buyVC.store = store
            buyVC.walletManager = walletManager
        default:
            fatalError("Tab viewController not set")
        }
        exchangeRate = TransactionManager.sharedInstance.rate

        addChild(contentController)
        contentController.view.frame = containerView.frame
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        activeController = contentController
        view.bringSubviewToFront(floatingRegistrationView)
    }

    func hideContentController(contentController: UIViewController) {
        contentController.willMove(toParent: nil)
        contentController.view.removeFromSuperview()
        contentController.removeFromParent()
    }

    func tabBar(_: UITabBar, didSelect item: UITabBarItem) {
        if let tempActiveController = activeController {
            hideContentController(contentController: tempActiveController)
        }
        displayContentController(contentController: viewControllers[item.tag])
    }
}

extension TabBarViewController {
    @objc private func currencySwitchTapped() {
        view.layoutIfNeeded()
        guard let store = self.store else { return }
        guard let isLTCSwapped = isLtcSwapped else { return }
        guard let primaryLabel = primaryBalanceLabel,
            let secondaryLabel = secondaryBalanceLabel else {
            NSLog("ERROR: Price labels not initialized")
            return
        }

        UIView.spring(0.7, animations: {
            primaryLabel.transform = primaryLabel.transform.isIdentity ? self.transform(forView: primaryLabel) : .identity
            secondaryLabel.transform = secondaryLabel.transform.isIdentity ? self.transform(forView: secondaryLabel) : .identity
            NSLayoutConstraint.deactivate(!isLTCSwapped ? self.regularConstraints : self.swappedConstraints)
            NSLayoutConstraint.activate(!isLTCSwapped ? self.swappedConstraints : self.regularConstraints)
            self.view.layoutIfNeeded()

        }) { _ in }
        store.perform(action: CurrencyChange.toggle())
    }
}
