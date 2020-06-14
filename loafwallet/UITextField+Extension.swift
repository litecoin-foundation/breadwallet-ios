//
//  UITextField+Extension.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/13/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

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
