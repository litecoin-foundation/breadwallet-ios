//
//  MenuButtonType.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-30.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

enum MenuButtonType {
    case security
    case customerSupport
    case supportGiveToLF
    case settings
    case lock

    var title: String {
        switch self {
        case .security:
            return S.MenuButton.security
        case .customerSupport:
            return S.MenuButton.support
        case .supportGiveToLF:
            return S.SupportLitecoinFoundation.title
        case .settings:
            return S.MenuButton.settings
        case .lock:
            return S.MenuButton.lock
        }
    }

    var image: UIImage {
        switch self {
        case .security:
            return #imageLiteral(resourceName: "Shield")
        case .customerSupport:
            return #imageLiteral(resourceName: "FaqFill")
        case .supportGiveToLF:
            return #imageLiteral(resourceName: "buy_icon_gray")
        case .settings:
            return #imageLiteral(resourceName: "Settings")
        case .lock:
            return #imageLiteral(resourceName: "Lock") 
        }
    }
}
