import UIKit

extension UIScrollView {
    func verticallyOffsetContent(_ deltaY: CGFloat) {
        contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - deltaY)
        contentInset = UIEdgeInsets(top: contentInset.top + deltaY, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
        scrollIndicatorInsets = contentInset
    }
}
