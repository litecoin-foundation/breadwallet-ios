import UIKit

extension UIBarButtonItem {
    static var negativePadding: UIBarButtonItem {
        let padding = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        padding.width = -16.0
        return padding
    }
}
