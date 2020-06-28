import UIKit

extension UIScrollView {
    func verticallyOffsetContent(_ deltaY: CGFloat) {
        contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - deltaY)
        contentInset = UIEdgeInsetsMake(contentInset.top + deltaY, contentInset.left, contentInset.bottom, contentInset.right)
        scrollIndicatorInsets = contentInset
    }
}
