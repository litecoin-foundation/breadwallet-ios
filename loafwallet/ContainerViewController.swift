import Foundation
import UIKit

class ContainerViewController: UIViewController {
    override func viewDidLoad() {}
}

extension ContainerViewController: ModalDisplayable {
    var faqArticleId: String? {
        return nil
    }

    var modalTitle: String {
        return ""
    }
}
