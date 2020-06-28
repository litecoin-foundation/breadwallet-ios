import UIKit

// This class disables all scrolling. This is desired
// when we don't want the scrollView to scroll to the active
// textField
class NonScrollingCollectionView: UICollectionView {
    override func setContentOffset(_: CGPoint, animated _: Bool) {
        // noop
    }
}
