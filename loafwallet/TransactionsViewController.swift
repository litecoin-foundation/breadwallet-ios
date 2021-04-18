//
//  TransactionsViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import SwiftUI
import LocalAuthentication

let kNormalTransactionCellHeight: CGFloat = 65.0
let kProgressHeaderHeight: CGFloat = 50.0
let kDormantHeaderHeight: CGFloat = 1.0
let kPromptCellHeight : CGFloat = 120.0
let kQRImageSide: CGFloat = 110.0
let kFiveYears: Double = 157680000.0
let kTodaysEpochTime: TimeInterval = Date().timeIntervalSince1970
 
class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Subscriber, Trackable {

    @IBOutlet weak var tableView: UITableView!
      
    var store: Store?
    var walletManager: WalletManager?
    var selectedIndexes = [IndexPath: NSNumber]()
    var shouldBeSyncing: Bool = false
    var syncingHeaderView : SyncProgressHeaderView?
    var shouldShowPrompt = true

    private var transactions: [Transaction] = []
    private var allTransactions: [Transaction] = [] {
        didSet {
            transactions = allTransactions
        }
    }
    
    private var rate: Rate? {
        didSet { reload() }
    }
    
    private var currentPromptType: PromptType? {
        didSet {
            if currentPromptType != nil && oldValue == nil {
                tableView.beginUpdates()
                tableView.insertSections(IndexSet(integer: 0), with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    var isLtcSwapped: Bool? {
        didSet { reload() }
    }
    
    override func viewDidLoad() {
      setup()
      addSubscriptions()
    }
    
    private func setup() {
        
        guard let _ = walletManager else {
             NSLog("ERROR - Wallet manager not initialized")
             assertionFailure("PEER MANAGER Not initialized")
             return
        }
        
        guard let reduxState = self.store?.state else {
            return
        }

        self.tableView.register(HostingTransactionCell<TransactionCellView>.self, forCellReuseIdentifier: "HostingTransactionCell<TransactionCellView>")
        self.transactions = TransactionManager.sharedInstance.transactions
        self.rate = TransactionManager.sharedInstance.rate
        
        tableView.backgroundColor = .liteWalletBlue
        initSyncingHeaderView(reduxState: reduxState, completion: { })
        attemptShowPrompt()
    }
    
    
    /// Calls the Syncing HeaderView
    /// - Parameters:
    ///   - reduxState: Current ReduxState
    ///   - completion: Signals the initialzation of the view
    private func initSyncingHeaderView(reduxState: ReduxState, completion: @escaping () -> Void) {
        self.syncingHeaderView = Bundle.main.loadNibNamed("SyncProgressHeaderView",
        owner: self,
        options: nil)?.first as? SyncProgressHeaderView
        self.syncingHeaderView?.isRescanning = reduxState.walletState.isRescanning
        self.syncingHeaderView?.progress = 0.02 // Small value to show user it is in process
        self.syncingHeaderView?.headerMessage = reduxState.walletState.syncState
        self.syncingHeaderView?.noSendImageView.alpha = 1.0
        self.syncingHeaderView?.timestamp = reduxState.walletState.lastBlockTimestamp
        
        completion()
    }
	
    private func attemptShowPrompt() {
        guard let walletManager = walletManager else { return }
        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }
         
        let types = PromptType.defaultOrder
        if let type = types.first(where: { $0.shouldPrompt(walletManager: walletManager, state: store.state) }) {
            self.saveEvent("prompt.\(type.name).displayed")
            currentPromptType = type
            if type == .biometrics {
                UserDefaults.hasPromptedBiometrics = true
            }
            if type == .shareData {
                UserDefaults.hasPromptedShareData = true
            }
        } else {
            currentPromptType = nil
        }
    }
    
    /// Update displayed transactions. Used mainly when the database needs an update
    /// - Parameter txHash: String reprsentation of the TX
    private func updateTransactions(txHash: String) {
        self.transactions.enumerated().forEach { i, tx in
            if tx.hash == txHash {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: i, section: 1)], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    /// Empty Message View as a placeholder
    /// - Returns: a UILabel
    private func emptyMessageView() -> UILabel {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = S.TransactionDetails.emptyMessage
        messageLabel.textColor = .litecoinGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.barlowMedium(size: 20)
        messageLabel.sizeToFit()
        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
        return messageLabel
    }
    
    /// Dyanmic Update Progress View: Advances the progress bar
    /// - Parameters:
    ///   - syncProgress: The state of the initial Sync Progress
    ///   - lastBlockTimestamp: Corresponding timestamp
    /// - Returns: CGFloat value
    private func updateProgressView(syncProgress: CGFloat, lastBlockTimestamp: Double) -> CGFloat {
        
        ///DEV:  HACK if the previous value is the same add a ration
        /// The problem is the progress needs to go to o to 1 .
        var progressValue: CGFloat = 0.0
        let num =  lastBlockTimestamp - kFiveYears
        let den =   kTodaysEpochTime - kFiveYears
        if syncProgress == 0.05 {
            progressValue =  abs(CGFloat(num) / CGFloat(den))
        } else {
            progressValue =  syncProgress
        }
 
        return progressValue
    }
    
    // MARK: - Table view data / delegate source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch  indexPath.section {
            case 0:
                
                if currentPromptType != nil {
                    return configurePromptCell(promptType: currentPromptType, indexPath: indexPath)
                }
                return EmptyTableViewCell()
                
            default:
                let transaction = transactions[indexPath.row]
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HostingTransactionCell<TransactionCellView>", for: indexPath) as? HostingTransactionCell<TransactionCellView> else {
                    NSLog("ERROR No cell found")
                    return UITableViewCell()
                }
                
                if let rate = rate,
                   let store = self.store,
                   let isLtcSwapped = self.isLtcSwapped {
                    let viewModel = TransactionCellViewModel(transaction: transaction, isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: store.state.maxDigits, isSyncing: store.state.walletState.syncState != .success)
                    cell.set(rootView: TransactionCellView(viewModel: viewModel), parentController: self)
                    cell.selectionStyle = .default
                }
                
                return cell
        }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let transaction = transactions[indexPath.row]
            
            if let rate = rate,
               let store = self.store,
               let isLtcSwapped = self.isLtcSwapped {
                
                  let viewModel = TransactionCellViewModel(transaction: transaction, isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: store.state.maxDigits, isSyncing: store.state.walletState.syncState != .success)
                
                  let hostingController = UIHostingController(rootView: TransactionModalView(viewModel: viewModel))
                
                      hostingController.modalPresentationStyle = .formSheet
                        
                    self.present(hostingController, animated: true) {
                        
                        
                        // Notes of bugfix: https://github.com/litecoin-foundation/loafwallet-ios/pull/247
                        // Refactored the class to have two section and make sure the row never extends outside the transaction count.
                        
                        if indexPath.row < self.transactions.count {
                            tableView.cellForRow(at: indexPath)?.isSelected = false
                        }
                    }
            }
        }
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return currentPromptType != nil ? kPromptCellHeight : kDormantHeaderHeight
        } else {
            return kNormalTransactionCellHeight
        }
    }
     
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if shouldBeSyncing && section == 0 {
            return self.syncingHeaderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var sectionHeight = 0.0
        switch section {
            case 0:
                sectionHeight = Double(shouldBeSyncing ? kProgressHeaderHeight : kDormantHeaderHeight)
                return CGFloat(sectionHeight)
            default: return 0.0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            if transactions.count > 0  {
                self.tableView.backgroundView = nil
                return transactions.count
            } else {
                self.tableView.backgroundView = emptyMessageView()
                self.tableView.separatorStyle = .none
                return 0
            }
        }
    }
     
    // MARK: - UITableView Support Methods
    private func configurePromptCell(promptType: PromptType?, indexPath: IndexPath) -> PromptTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromptTVC2", for: indexPath) as? PromptTableViewCell else {
            NSLog("ERROR No cell found")
            return PromptTableViewCell()
        }
        
        cell.type = promptType
        cell.titleLabel.text = promptType?.title
        cell.bodyLabel.text = promptType?.body
        cell.didClose = { [weak self] in
            self?.saveEvent("prompt.\(String(describing: promptType?.name)).dismissed")
            self?.currentPromptType = nil
            self?.reload()
        }
        
        cell.didTap = { [weak self] in
            
            if let store = self?.store,
               let trigger = self?.currentPromptType?.trigger {
                store.trigger(name: trigger)
            }
            self?.saveEvent("prompt.\(String(describing: self?.currentPromptType?.name)).trigger")
            self?.currentPromptType = nil
        }
        
        return cell
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Subscription Methods
    private func addSubscriptions() {
        
        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }
        
        
        // MARK: - Wallet State: Transactions
        store.subscribe(self, selector: { $0.walletState.transactions != $1.walletState.transactions },
                        callback: { state in
                            self.allTransactions = state.walletState.transactions
                            self.reload()
                        })
        
        // MARK: - Wallet State: isLTCSwapped
        store.subscribe(self, selector: { $0.isLtcSwapped != $1.isLtcSwapped },
                        callback: { self.isLtcSwapped = $0.isLtcSwapped })
        
        // MARK: - Wallet State:  CurrentRate
        store.subscribe(self, selector: { $0.currentRate != $1.currentRate},
                        callback: { self.rate = $0.currentRate })
        
        // MARK: - Wallet State:  Max Digits
        store.subscribe(self, selector: { $0.maxDigits != $1.maxDigits }, callback: {_ in
            self.reload()
        })
        
        // MARK: - Wallet State:  Sync Progress
        store.subscribe(self, selector: { $0.walletState.lastBlockTimestamp != $1.walletState.lastBlockTimestamp },
                        callback: { reduxState in
                            
                            guard let syncView =  self.syncingHeaderView else { return }
                            
                            syncView.isRescanning = reduxState.walletState.isRescanning
                            if (syncView.isRescanning || (reduxState.walletState.syncState == .syncing)) {
                                syncView.progress = CGFloat(self.updateProgressView(syncProgress:
                                                                                        CGFloat(reduxState.walletState.syncProgress), lastBlockTimestamp: Double(reduxState.walletState.lastBlockTimestamp)))
                                syncView.headerMessage = reduxState.walletState.syncState
                                syncView.noSendImageView.alpha = 1.0
                                
                                syncView.timestamp = reduxState.walletState.lastBlockTimestamp
                                self.shouldBeSyncing = true
                                
                                if reduxState.walletState.syncProgress >= 0.99 {
                                    self.shouldBeSyncing = false
                                    self.syncingHeaderView = nil
                                }
                            }
                            
                            self.reload()
        })
        
        // MARK: - Wallet State:  Show Status Bar
        store.subscribe(self, name:.showStatusBar) { (didShowStatusBar) in
            //DEV: May fix where the action view persists after confirming pin
            self.reload()
        }
        
        // MARK: - Wallet State:  Sync State
        store.subscribe(self, selector: { $0.walletState.syncState != $1.walletState.syncState },
                        callback: { reduxState in
                            
                            guard let _ = self.walletManager?.peerManager else {
                                assertionFailure("PEER MANAGER Not initialized")
                                return
                            }
                            
                            if reduxState.walletState.syncState == .syncing {
                                self.shouldBeSyncing = true
                                self.initSyncingHeaderView(reduxState: reduxState, completion: {
                                    self.syncingHeaderView?.isRescanning = reduxState.walletState.isRescanning
                                    self.syncingHeaderView?.progress = 0.02 // Small value to show user it is in process
                                    self.syncingHeaderView?.headerMessage = reduxState.walletState.syncState
                                    self.syncingHeaderView?.noSendImageView.alpha = 1.0
                                    self.syncingHeaderView?.timestamp = reduxState.walletState.lastBlockTimestamp
                                })
                            }
                            
                            if reduxState.walletState.syncState == .success {
                                self.shouldBeSyncing = false
                                self.syncingHeaderView = nil
                            }
                            self.reload()
                        })
        
        // MARK: - Subscription:  Recommend Rescan
        store.subscribe(self, selector: { $0.recommendRescan != $1.recommendRescan }, callback: { _ in
            self.attemptShowPrompt()
        })
        
        // MARK: - Subscription:  Did Upgrade PIN
        store.subscribe(self, name: .didUpgradePin, callback: { _ in
            if self.currentPromptType == .upgradePin {
                self.currentPromptType = nil
            }
        })
        
        // MARK: - Subscription:  Did Enable Share Data
        store.subscribe(self, name: .didEnableShareData, callback: { _ in
            if self.currentPromptType == .shareData {
                self.currentPromptType = nil
            }
        })
        
        // MARK: - Subscription:  Did Write Paper Key
        store.subscribe(self, name: .didWritePaperKey, callback: { _ in
            if self.currentPromptType == .paperKey {
                self.currentPromptType = nil
            }
        })
        
        // MARK: - Subscription:  Memo Updated
        store.subscribe(self, name: .txMemoUpdated(""), callback: {
            guard let trigger = $0 else { return }
            if case .txMemoUpdated(let txHash) = trigger {
                self.updateTransactions(txHash: txHash)
            }
        })
        
        reload()
    }
}
