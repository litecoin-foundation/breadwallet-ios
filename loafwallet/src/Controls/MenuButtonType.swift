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
    case support
    case supportLF
    case settings
    case lock

    var title: String {
        switch self {
        case .security:
            return S.MenuButton.security
        case .support:
            return S.MenuButton.support
        case .supportLF:
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
        case .support:
            return #imageLiteral(resourceName: "FaqFill")
        case .supportLF:
            return #imageLiteral(resourceName: "BuyLitecoin")
        case .settings:
            return #imageLiteral(resourceName: "Settings")
        case .lock:
            return #imageLiteral(resourceName: "Lock") 
        }
    }
}
