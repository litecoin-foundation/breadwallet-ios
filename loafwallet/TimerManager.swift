//
//  TimerManager.swift
//  loafwallet
//
//  Created by Kerry Washington on 2/3/21.
//  Copyright © 2021 Litecoin Foundation. All rights reserved.
//

import Foundation


class TimerManager: NSObject {
    
    static let sharedInstance = TimerManager()
    
    private var timer = Timer()
    
    override init() {
        super.init()
    }
     
}



//let timestampInfo = transaction.timeSince
////       timedateLabel.text = timestampInfo.0
////       if timestampInfo.1 {
////           timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: TransactionCellWrapper(target: self), selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
////       } else {
////           timer?.invalidate()
////       }
////       timedateLabel.isHidden = !transaction.isValid
