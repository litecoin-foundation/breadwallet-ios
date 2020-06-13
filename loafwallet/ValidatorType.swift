//
//  Validation.swift
//  litewallet
//
//  Created by Kerry Washington on 8/25/19.
//  Copyright © 2019 litecoin. All rights reserved.
//
 
import Foundation

class Validation {
    
}

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case email
    case password
    case firstName
    case lastName
    case address
    case city
    case country
    case state
    case postalCode
    case mobileNumber
    case requiredField(field: String)
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .firstName: return FirstNameValidator()
        case .lastName: return LastNameValidator()
        case .address: return AddressValidator()
        case .city: return CityValidator()
        case .country: return CountryValidator()
        case .state: return StateValidator()
        case .postalCode: return PostalCodeValidator()
        case .mobileNumber: return MobileNumberValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}

class FirstNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("First Name is required")}
        return value
    }
}

class LastNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Last Name is required")}
        return value
    }
}

class AddressValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Address is required")}
        return value
    }
}

class CityValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("City is required")}
        return value
    }
}

class CountryValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Country is required")}
        return value
    }
}

class StateValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("State is required")}
        return value
    }
}

class PostalCodeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Postal code is required")}
        return value
    }
}


struct MobileNumberValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Mobile number is required")}
        guard value.count >= 10 else { throw ValidationError("Mobile number must have at least 10 digits") }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9]*$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Mobile number must only have digits")
            }
        } catch {
            throw ValidationError("Mobile number must only have digits")
        }
        return value
    }
}


struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 6 else { throw ValidationError("Password must have at least 6 characters") }
        
        do {
            if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
            }
        } catch {
            throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid e-mail Address")
            }
        } catch {
            throw ValidationError("Invalid e-mail Address")
        }
        return value
    }
}
