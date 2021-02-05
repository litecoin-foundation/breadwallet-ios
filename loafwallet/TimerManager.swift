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

