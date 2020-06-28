import UIKit

extension UIViewController {
    func addChildViewController(_ viewController: UIViewController, layout: () -> Void) {
        addChild(viewController)
        view.addSubview(viewController.view)
        layout()
        viewController.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    func addCloseNavigationItem(tintColor: UIColor? = nil) {
        let close = UIButton.close
        close.tap = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        if let color = tintColor {
            if #available(iOS 11.0, *),
                let labelTextColor = UIColor(named: "labelTextColor") {
                close.tintColor = labelTextColor
            } else {
                close.tintColor = color
            }
        }
        navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: close)]
    }

    func hideCloseNavigationItem() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem.negativePadding, UIBarButtonItem(customView: UIView())]
    }
}
