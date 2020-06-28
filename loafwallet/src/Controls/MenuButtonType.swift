import UIKit

enum MenuButtonType {
    case security
    case support
    case settings
    case lock

    var title: String {
        switch self {
        case .security:
            return S.MenuButton.security
        case .support:
            return S.MenuButton.support
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
        case .settings:
            return #imageLiteral(resourceName: "Settings")
        case .lock:
            return #imageLiteral(resourceName: "Lock")
        }
    }
}
