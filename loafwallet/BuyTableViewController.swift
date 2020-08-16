//
//  BuyTableViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/18/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import CNIntegration

class BuyTableViewController: UITableViewController {

    @IBOutlet weak var simplexLogoImageView: UIImageView!
    @IBOutlet weak var simplexHeaderLabel: UILabel!
    @IBOutlet weak var simplexDetailsLabel: UILabel!
    @IBOutlet weak var simplexCellContainerView: UIView!
    
    @IBOutlet weak var chooseFiatLabel: UILabel!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!

    @IBOutlet weak var changeNowHeaderLabel: UILabel!
    @IBOutlet weak var changeNowDetailsLabel: UILabel!
    @IBOutlet weak var changeNowLogoImageView: UIImageView!
    @IBOutlet weak var changeNowLogoBackgroundView: UIView!
    @IBOutlet weak var changeNowCellContainerView: UIView!

    private var currencyCode: String = "USD"

    private lazy var changeNowIntegration: CNIntegration = {
        return CNIntegration(apiKey: "4b18e6466b7ae3984dba1b9359d13b0a4b22f42c2ed423dbd1f72cddccac6632",
                             theme: CNLiteWalletTheme(),
                             navigationType: .sequence,
                             exchangeType: .specific(currency: "ltc", address: nil))
    }()
    
    @IBAction func didTapSimplex(_ sender: Any) {
        
        if let vcWKVC = UIStoryboard.init(name: "Buy", bundle: nil).instantiateViewController(withIdentifier: "BuyWKWebViewController") as? BuyWKWebViewController {
            vcWKVC.partnerPrefixString = PartnerPrefix.simplex.rawValue
            vcWKVC.currencyCode = currencyCode
            addChildViewController(vcWKVC)
            self.view.addSubview(vcWKVC.view)
            vcWKVC.didMove(toParentViewController: self)
            
            vcWKVC.didDismissChildView = { [weak self] in
                guard self != nil else { return }
                vcWKVC.willMove(toParentViewController: nil)
                vcWKVC.view.removeFromSuperview()
                vcWKVC.removeFromParentViewController()
            }
        }  else {
            NSLog("ERROR: Storyboard not initialized")
        }
    }

    @IBAction func didTapChangeNow(_ sender: Any) {
        present(changeNowIntegration.start(), animated: true, completion: nil)
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

        let changeNowData = Partner.partnerDataArray()[1]
        changeNowHeaderLabel.text = changeNowData.headerTitle
        changeNowDetailsLabel.text = changeNowData.details
        changeNowLogoImageView.image = changeNowData.logo
        changeNowLogoBackgroundView.backgroundColor = UIColor(red: 0.208, green: 0.208, blue: 0.298, alpha: 1)
        changeNowCellContainerView.layer.cornerRadius = 6.0
        changeNowCellContainerView.layer.borderColor = UIColor.white.cgColor
        changeNowCellContainerView.layer.borderWidth = 1.0
        changeNowCellContainerView.clipsToBounds = true
    }
    
    @objc private func didChangeCurrency() {
        if let code = PartnerFiatOptions(rawValue: currencySegmentedControl.selectedSegmentIndex)?.description {
            self.currencyCode = code
        }
    }
}
