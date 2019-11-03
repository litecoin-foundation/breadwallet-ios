//
//  Keys.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/6/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//
// THIS FILE IS in GITIGNORE...SHOULD NOT BE IN THE OPEN SOURCE REPO
import UIKit

struct K {
    static let mixpanelTokenProduction  = "7773cfa76d8f0a30772a5e9d1802736d"
    static let mixpanelTokenDevelopment = "1bc7f0d029f05d37480b227c24df2004"
    
    enum MixpanelEvents: String {
        case _20191105_AL = "APP_LAUNCHED" 
        case _20191105_VSC = "VISIT_SEND_CONTROLLER"
        case _20191105_DSL = "DID_SEND_LTC"
        case _20191105_DULP = "DID_UPDATE_LTC_PRICE"
        case _20191105_EO = "ERROR_OCCURRED"
        case _20191105_DTBT = "DID_TAP_BUY_TAB"
    }
}
