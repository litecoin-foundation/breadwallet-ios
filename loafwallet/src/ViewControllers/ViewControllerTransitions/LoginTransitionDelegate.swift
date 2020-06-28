import UIKit

class LoginTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissLoginAnimator()
    }
}
