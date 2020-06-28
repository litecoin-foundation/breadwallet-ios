import UIKit

class StartNavigationDelegate: NSObject, UINavigationControllerDelegate {
    let store: Store

    init(store: Store) {
        self.store = store
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        if viewController is RecoverWalletIntroViewController {
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.customBold(size: 17.0),
            ]
            navigationController.setClearNavbar()
            navigationController.navigationBar.barTintColor = .clear
        }

        if viewController is EnterPhraseViewController {
            navigationController.navigationBar.tintColor = .darkText
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.darkText,
                NSAttributedString.Key.font: UIFont.customBold(size: 17.0),
            ]
            navigationController.setClearNavbar()
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = .whiteTint
        }

        if viewController is UpdatePinViewController {
            navigationController.navigationBar.tintColor = .darkText
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.darkText,
                NSAttributedString.Key.font: UIFont.customBold(size: 17.0),
            ]
            navigationController.setClearNavbar()
        }

        if viewController is UpdatePinViewController {
            if let gr = navigationController.interactivePopGestureRecognizer {
                navigationController.view.removeGestureRecognizer(gr)
            }
        }

        if viewController is StartWipeWalletViewController {
            navigationController.setClearNavbar()
            navigationController.setWhiteStyle()
        }
    }
}
