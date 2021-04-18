//
//  RegistrationViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/24/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import KeychainAccess

enum UserDataType {
    case genericString
    case email
    case country
    case mobileNumber
    case password
    case confirmation
}

class RegistrationViewModel: ObservableObject {
    
    @Published
    var isRegistering: Bool = false
    
    @Published
    var didRegister: Bool = false
    
    @Published
    var message: String = S.LitecoinCard.registeringUser
    
    var dataDictionary = [String: Any]()
    
    init() {
        
    }
    
    func verify(data: [String: Any],
                completion: @escaping (Bool) -> ()) {
        
        guard let first = data["firstname"] as? String else { return }
        guard let last = data["lastname"] as? String else { return }
        guard let email = data["email"] as? String else { return }
        guard let password = data["password"] as? String else { return }
        guard let phone = data["phone"] as? String else { return }
        guard let country = data["country"] as? String else { return }
        guard let state = data["state"] as? String else { return }
        guard let city = data["city"] as? String else { return }
        guard let address1 = data["address1"] as? String else { return }
        guard let zip = data["zip_code"] as? String else { return }
        
        if  self.isDataValid(dataType: .genericString, data: first) &&
                isDataValid(dataType: .genericString, data: last) &&
                isDataValid(dataType: .email, data: email) &&
                isDataValid(dataType: .password, data: password) &&
                isDataValid(dataType: .mobileNumber, data: phone) &&
                isDataValid(dataType: .country, data: country) &&
                isDataValid(dataType: .genericString, data: state) &&
                isDataValid(dataType: .genericString, data: city) &&
                isDataValid(dataType: .genericString, data: address1) &&
                isDataValid(dataType: .genericString, data: zip) {
            
            self.dataDictionary = data
            
            self.isRegistering = true
            
            completion(isRegistering)
        }
    }
    
    func registerCardUser() {
        
        var setupUserID: String?
        
        PartnerAPI.shared.createUser(userDataParams: dataDictionary) { (newUser) in
        
            if let userID = newUser?.userID,
               let createdAt = newUser?.createdAtDateString {
                
                ///Move  setupUserID
                setupUserID = userID
     
                guard let password = self.dataDictionary["password"] as? String else { return }
                guard let email = self.dataDictionary["email"] as? String else { return }
                
                let cardService = "com.litecoincard.service"
                let keychain = Keychain(service: cardService)
                
                keychain[email] = password
                keychain["userID"] = userID
                keychain["createdAt"] = createdAt
                
                DispatchQueue.main.async {
                    self.message = S.LitecoinCard.registrationSuccess
                    self.didRegister = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.isRegistering = false
                    }
                }
            }
       }
     
        if setupUserID == nil {
            DispatchQueue.main.async {
                self.message = S.LitecoinCard.registrationFailure
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.isRegistering = false
                }
            }
        }
    }
    
    func isDataValid(dataType: UserDataType, firstString: String = "", data: Any) -> Bool {
        
        guard let dataString = data as? String else { return false }
        
        switch dataType {
            case .genericString:
                return isGenericStringValid(genericString: dataString)
            case .email:
                return isEmailValid(emailString: dataString)
            case .country:
                return  dataString == "US" ?  true : false
            case .mobileNumber:
                return isMobileNumberValid(mobileString: dataString)
            case .password:
                return isPasswordValid(passwordString: dataString)
            case .confirmation:
                return isConfirmedValid(firstString: firstString, confirmingString: dataString)
        }
    }
    
    //MARK: - Data Validators
    
    func isGenericStringValid(genericString: String) -> Bool {
        
        guard genericString != "" else {
            return false
        }
        
        guard genericString.count <= 32 else {
            return false
        }
        
        return true
    }
    
    func isConfirmedValid(firstString: String, confirmingString: String) -> Bool {
        return firstString == confirmingString ? true : false
    }
    
    func isEmailValid(emailString: String) -> Bool {
        
        if try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive)
            .firstMatch(in: emailString, options: [],
                        range: NSRange(location: 0,
                                       length: emailString.count)) == nil {
            return false
        } else {
            return true
        }
    }
    
    /// Password  Validator
    /// - Parameter passwordString: 6 chars minimum
    /// - Returns: Bool
    func isPasswordValid(passwordString: String) -> Bool {
        
        guard passwordString.count >= 6 else {
            return false
        }
        
        if try! NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive)
            .firstMatch(in: passwordString, options: [],
                        range: NSRange(location: 0,
                                       length: passwordString.count)) == nil {
            return false
        } else {
            return true
        }
    }
    
    /// Mobile Number Validator
    /// - Parameter mobileString: 10+ integers 0 - 9
    /// - Returns: Bool
    func isMobileNumberValid(mobileString: String) -> Bool {
        guard mobileString != "" else {
            return false
        }
        
        //https://boards.straightdope.com/t/longest-telephone-number-in-the-world/400450
        guard (mobileString.count >= 10 && mobileString.count <= 20) else {
            return false
        }
        
        if try! NSRegularExpression(pattern: "^[0-9]*$", options: .caseInsensitive)
            .firstMatch(in: mobileString, options: [],
                        range: NSRange(location: 0,
                                       length: mobileString.count)) == nil {
            return false
        } else {
            return true
        }
    }
}