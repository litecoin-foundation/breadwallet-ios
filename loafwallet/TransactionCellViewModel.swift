//
//  TransactionCellViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/2/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI

private let timestampRefreshRate: TimeInterval = 10.0

class TransactionCellViewModel: ObservableObject {
    
    //MARK: - Public Variables
    var transaction: Transaction
    
    var isLtcSwapped: Bool
     
    var rate: Rate
    
    var maxDigits: Int
    
    var isSyncing: Bool
     
    var amountText: String = ""
    
    var feeText: String = ""
  
    var directionText: String = ""
    
    var directionImageText: String = ""
    
    var directionArrowColor: Color = .clear
    
    var addressText: String  = ""
    
    var timedateText: String = ""
    
    var memoString: String = ""
    
    var qrImage = UIImage()
    
    //MARK: - Private Variables
    private var timer: Timer? = nil
 
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
         
        feeText = transaction.amountDetails(isLtcSwapped: isLtcSwapped, rate: rate, rates: [rate], maxDigits: maxDigits)
        
        addressText = String(format: transaction.direction.addressTextFormat, transaction.toAddress ?? "")
        
        if self.transaction.direction == .sent {
            directionImageText = "arrowtriangle.up.circle.fill"
            directionArrowColor = Color(UIColor.litecoinOrange)
        } else if self.transaction.direction == .received {
            directionImageText = "arrowtriangle.down.circle.fill"
            directionArrowColor = Color(UIColor.litecoinGreen)
        }
        
        let timestampInfo = transaction.timeSince
        timedateText = timestampInfo.0
        if timestampInfo.1 {
            timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: self, selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
          
        if let address = transaction.toAddress,
           let data = address.data(using: .utf8),
           let image = UIImage
                .qrCode(data: data,
                        color: .black)?
                .resize(CGSize(width: kQRImageSide,
                               height: kQRImageSide)) {
                            qrImage = image
        }
        
        if let memo = self.transaction.comment {
            memoString = memo
        }
    }
}
