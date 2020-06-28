import Foundation
import UIKit

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)

        if let text = self.text {
            return try validator.validated(text)
        }
        return "ERROR"
    }
}
