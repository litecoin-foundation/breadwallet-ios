//
//  TransactionCellViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

class TransactionCellViewModel: ObservableObject {
    
    
    //MARK: - Public Variables
    var transaction: Transaction
    
    var isLtcSwapped: Bool
     
    var rate: Rate
    
    var maxDigits: Int
    
    var isSyncing: Bool
     
    var  amountText: String = ""
    
    var  directionText: String = ""
    
    var  directionImageText: String = ""
    
    var directionArrowColor: Color = .clear
    
    var addressText: String  = ""
    
    var timedateText: String = ""
    

    init(transaction: Transaction,
         isLtcSwapped: Bool,
         rate: Rate,
         maxDigits: Int,
         isSyncing: Bool) {
        
        self.transaction = transaction
        self.isLtcSwapped = isLtcSwapped
        self.rate = rate
        self.maxDigits = maxDigits
        self.isSyncing = isSyncing
        
        loadVariables()
     }
    
    private func loadVariables() {
        
        amountText = transaction.descriptionString(isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: maxDigits).string
        
        if self.transaction.direction == .sent {
            directionImageText = "arrowtriangle.up.circle.fill"
            directionArrowColor = Color(UIColor.litecoinGreen)
        } else if self.transaction.direction == .received {
            directionImageText = "arrowtriangle.down.circle.fill"
            directionArrowColor = Color(UIColor.litecoinOrange) 
        }
        
      let timestampInfo = transaction.timeSince
      timedateText = timestampInfo.0
      
        if timestampInfo.1 {
                   
            
//                timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: TransactionCellWrapper(target: self), selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
//               } else {
//                   timer?.invalidate()
//               }
        
//               timedateLabel.isHidden = !transaction.isValid
    }
        
        addressText = String(format: transaction.direction.addressTextFormat, transaction.toAddress ?? "")
    }
 
}


//func setTransaction(_ transaction: Transaction, isLtcSwapped: Bool, rate: Rate, maxDigits: Int, isSyncing: Bool) {
//
//    self.transaction = transaction
//
//    amountLabel.attributedText = transaction.descriptionString(isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: maxDigits)
//    addressLabel.text = String(format: transaction.direction.addressTextFormat, transaction.toAddress ?? "")
//    statusLabel.text = transaction.status
//    commentTextLabel.text = transaction.comment
//    blockLabel.text = transaction.blockHeight
//    txidStringLabel.text = transaction.hash
//    availabilityLabel.text = transaction.shouldDisplayAvailableToSpend ? S.Transaction.available : ""
//    arrowImageView.image = UIImage(named: "black-circle-arrow-right")?.withRenderingMode(.alwaysTemplate)
//    startingBalanceLabel.text = transaction.amountDetailsStartingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: [rate], maxDigits: maxDigits)
//    endingBalanceLabel.text = transaction.amountDetailsEndingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: [rate], maxDigits: maxDigits)
//    dropArrowImageView.image = UIImage(named: "modeDropArrow")
//
//    if #available(iOS 11.0, *) {
//
//        guard let textColor = UIColor(named: "labelTextColor") else {
//            NSLog("ERROR: Custom color not found")
//            return
//        }
//
//        guard let backgroundColor = UIColor(named: "inverseBackgroundViewColor") else {
//            NSLog("ERROR: Custom color not found")
//            return
//        }
//
//        amountLabel.textColor = textColor
//        addressLabel.textColor = textColor
//        commentTextLabel.textColor = textColor
//        statusLabel.textColor = textColor
//        timedateLabel.textColor = textColor
//
//        staticCommentLabel.textColor = textColor
//        staticTxIDLabel.textColor = textColor
//        staticAmountDetailLabel.textColor = textColor
//        staticBlockLabel.textColor = textColor
//
//        qrBackgroundView.backgroundColor = backgroundColor
//
//    } else {
//        commentTextLabel.textColor = .darkText
//        statusLabel.textColor = .darkText
//        timedateLabel.textColor = .darkText
//
//        staticCommentLabel.textColor = .darkText
//        staticTxIDLabel.textColor = .darkText
//        staticAmountDetailLabel.textColor = .darkText
//        staticBlockLabel.textColor = .darkText
//
//        qrBackgroundView.backgroundColor = .white
//    }
//
//    if transaction.status == S.Transaction.complete {
//        statusLabel.isHidden = false
//    } else {
//        statusLabel.isHidden = isSyncing
//    }
//
//    let timestampInfo = transaction.timeSince
//    timedateLabel.text = timestampInfo.0
//    if timestampInfo.1 {
//        timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: TransactionCellWrapper(target: self), selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
//    } else {
//        timer?.invalidate()
//    }
//    timedateLabel.isHidden = !transaction.isValid
//
//    let identity: CGAffineTransform = .identity
//    if transaction.direction == .received {
//        arrowImageView.transform = identity.rotated(by: π/2.0)
//        arrowImageView.tintColor = .txListGreen
//    } else {
//        arrowImageView.transform = identity.rotated(by: 3.0*π/2.0)
//        arrowImageView.tintColor = .cameraGuideNegative
//    }
//
//    if transaction.direction == .received {
//        qrModalButton.isHidden = false
//    } else {
//        qrModalButton.isHidden = true
//    }
//}
//



//private func configureTransactionCell(transaction:Transaction?, wasSelected: Bool?, indexPath: IndexPath) -> TransactionTableViewCellv2 {
//
//    //TODO: Polish animation based on 'wasSelected'
//
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC2", for: indexPath) as? TransactionTableViewCellv2 else {
//        NSLog("ERROR: No cell found")
//        return TransactionTableViewCellv2()
//    }
//
//    if let transaction = transaction {
//        if transaction.direction == .received {
//            cell.showQRModalAction = { [unowned self] in
//
//                if let addressString = transaction.toAddress,
//                   let qrImage =  UIImage.qrCode(data: addressString.data(using: .utf8) ?? Data(), color: CIColor(color: .black))?.resize(CGSize(width: qrImageSize, height: qrImageSize)),
//                   let receiveLTCtoAddressModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFModalReceiveQRViewController") as? LFModalReceiveQRViewController {
//
//                    receiveLTCtoAddressModal.providesPresentationContextTransitionStyle = true
//                    receiveLTCtoAddressModal.definesPresentationContext = true
//                    receiveLTCtoAddressModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                    receiveLTCtoAddressModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                    receiveLTCtoAddressModal.dismissQRModalAction = { [unowned self] in
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    self.present(receiveLTCtoAddressModal, animated: true) {
//                        receiveLTCtoAddressModal.receiveModalTitleLabel.text = S.TransactionDetails.receiveModaltitle
//                        receiveLTCtoAddressModal.addressLabel.text = addressString
//                        receiveLTCtoAddressModal.qrImageView.image = qrImage
//                    }
//                }
//            }
//        }
//
//        if let rate = rate,
//           let store = self.store,
//           let isLtcSwapped = self.isLtcSwapped {
//            cell.setTransaction(transaction, isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: store.state.maxDigits, isSyncing: store.state.walletState.syncState != .success)
//        }
//
//        cell.staticBlockLabel.text = S.TransactionDetails.blockHeightLabel
//        cell.staticCommentLabel.text = S.TransactionDetails.commentsHeader
//        cell.staticAmountDetailLabel.text = S.Transaction.amountDetailLabel
//    }
//    else {
//        assertionFailure("Transaction must exist")
//    }
//    return cell
//}


//    private func configureTransactionCell(transaction:Transaction?, wasSelected: Bool?, indexPath: IndexPath) -> TransactionTableViewCellv2 {
//
//        //TODO: Polish animation based on 'wasSelected'
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC2", for: indexPath) as? TransactionTableViewCellv2 else {
//            NSLog("ERROR: No cell found")
//            return TransactionTableViewCellv2()
//        }
//
//        if let transaction = transaction {
//            if transaction.direction == .received {
//                cell.showQRModalAction = { [unowned self] in
//
//                    if let addressString = transaction.toAddress,
//                        let qrImage =  UIImage.qrCode(data: addressString.data(using: .utf8) ?? Data(), color: CIColor(color: .black))?.resize(CGSize(width: qrImageSize, height: qrImageSize)),
//                        let receiveLTCtoAddressModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFModalReceiveQRViewController") as? LFModalReceiveQRViewController {
//
//                        receiveLTCtoAddressModal.providesPresentationContextTransitionStyle = true
//                        receiveLTCtoAddressModal.definesPresentationContext = true
//                        receiveLTCtoAddressModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                        receiveLTCtoAddressModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                        receiveLTCtoAddressModal.dismissQRModalAction = { [unowned self] in
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                        self.present(receiveLTCtoAddressModal, animated: true) {
//                             receiveLTCtoAddressModal.receiveModalTitleLabel.text = S.TransactionDetails.receiveModaltitle
//                             receiveLTCtoAddressModal.addressLabel.text = addressString
//                             receiveLTCtoAddressModal.qrImageView.image = qrImage
//                         }
//                    }
//                }
//            }
//
//            if let rate = rate,
//                let store = self.store,
//                let isLtcSwapped = self.isLtcSwapped {
//                cell.setTransaction(transaction, isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: store.state.maxDigits, isSyncing: store.state.walletState.syncState != .success)
//            }
//
//            cell.staticBlockLabel.text = S.TransactionDetails.blockHeightLabel
//            cell.staticCommentLabel.text = S.TransactionDetails.commentsHeader
//            cell.staticAmountDetailLabel.text = S.Transaction.amountDetailLabel
//        }
//        else {
//            assertionFailure("Transaction must exist")
//        }
//        return cell
//    }




//TransactionModalView if let transaction = transaction {
//        if transaction.direction == .received {
//            cell.showQRModalAction = { [unowned self] in
//
//                if let addressString = transaction.toAddress,
//                   let qrImage =  UIImage.qrCode(data: addressString.data(using: .utf8) ?? Data(), color: CIColor(color: .black))?.resize(CGSize(width: qrImageSize, height: qrImageSize)),
//                   let receiveLTCtoAddressModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFModalReceiveQRViewController") as? LFModalReceiveQRViewController {
//
//                    receiveLTCtoAddressModal.providesPresentationContextTransitionStyle = true
//                    receiveLTCtoAddressModal.definesPresentationContext = true
//                    receiveLTCtoAddressModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                    receiveLTCtoAddressModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                    receiveLTCtoAddressModal.dismissQRModalAction = { [unowned self] in
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    self.present(receiveLTCtoAddressModal, animated: true) {
//                        receiveLTCtoAddressModal.receiveModalTitleLabel.text = S.TransactionDetails.receiveModaltitle
//                        receiveLTCtoAddressModal.addressLabel.text = addressString
//                        receiveLTCtoAddressModal.qrImageView.image = qrImage
//                    }
//                }
//            }
//        }
