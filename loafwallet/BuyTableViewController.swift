import UIKit

class BuyTableViewController: UITableViewController {
    @IBOutlet var simplexLogoImageView: UIImageView!
    @IBOutlet var simplexHeaderLabel: UILabel!
    @IBOutlet var simplexDetailsLabel: UILabel!
    @IBOutlet var simplexCellContainerView: UIView!

    @IBOutlet var chooseFiatLabel: UILabel!
    @IBOutlet var currencySegmentedControl: UISegmentedControl!

    private var currencyCode: String = "USD"

    @IBAction func didTapSimplex(_: Any) {
        if let vcWKVC = UIStoryboard(name: "Buy", bundle: nil).instantiateViewController(withIdentifier: "BuyWKWebViewController") as? BuyWKWebViewController {
            vcWKVC.partnerPrefixString = PartnerPrefix.simplex.rawValue
            vcWKVC.currencyCode = currencyCode
            addChild(vcWKVC)
            view.addSubview(vcWKVC.view)
            vcWKVC.didMove(toParent: self)

            vcWKVC.didDismissChildView = { [weak self] in
                guard self != nil else { return }
                vcWKVC.willMove(toParent: nil)
                vcWKVC.view.removeFromSuperview()
                vcWKVC.removeFromParent()
            }
        } else {
            NSLog("ERROR: Storyboard not initialized")
        }
    }

    var store: Store?
    var walletManager: WalletManager?
    let mountPoint = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let thinHeaderView = UIView()
        thinHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0)
        thinHeaderView.backgroundColor = .white
        tableView.tableHeaderView = thinHeaderView
        tableView.tableFooterView = UIView()

        currencySegmentedControl.addTarget(self, action: #selector(didChangeCurrency), for: .valueChanged)
        currencySegmentedControl.selectedSegmentIndex = PartnerFiatOptions.usd.index
        setupData()
    }

    private func setupData() {
        let simplexData = Partner.partnerDataArray()[0]
        simplexLogoImageView.image = simplexData.logo
        simplexHeaderLabel.text = simplexData.headerTitle
        simplexDetailsLabel.text = simplexData.details
        simplexCellContainerView.layer.cornerRadius = 6.0
        simplexCellContainerView.layer.borderColor = UIColor.white.cgColor
        simplexCellContainerView.layer.borderWidth = 1.0
        simplexCellContainerView.clipsToBounds = true

        chooseFiatLabel.text = S.DefaultCurrency.chooseFiatLabel
    }

    @objc private func didChangeCurrency() {
        if let code = PartnerFiatOptions(rawValue: currencySegmentedControl.selectedSegmentIndex)?.description {
            currencyCode = code
        }
    }
}
