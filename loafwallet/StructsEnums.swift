//
//  StructsEnums.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/8/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftyJSON
 
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

struct TernioAccount {
    var user: String? //email
    var token: String?
    
    init(dict:[String:AnyObject]) {
        
        if let token = dict["token"] as? String {
            self.token = token
        }
        
        if let user = dict["user"] as? String {
            self.user = user
        }
    }
}

struct TernioUserTestnetWallet {
    var tltcaddress: String?  //QeEkvmFwEKsTrHbdKmerTWce3dkvuohYNw 10 tLTC as of 10/16
    var balance: String?
    var message: String?
    
    init(json: JSON) {
        
        if let address = json["ltc_address"].string {
            self.tltcaddress = address
        }
        if let balance = json["????balance"].string {
            self.balance = balance
        }
        if let message = json["response"]["message"].string {
            self.message = message
        }
    }
}
 
struct TernioErrorData {
    
    var errors: [Any]?
    var emailErrorMessage: String?
    var message: String?
    var code: Int?
    var version: String?
    var executed: Int?
    
    
    init(json: JSON) {
        
        if let message = json["response"]["message"].string {
            self.message = message
        }
        if let errors = json["response"]["errors"].array {
            self.errors = errors
        }
        if let emailArray = json["response"]["errors"]["email"].array,
            let emailMessage = emailArray.first?.string {
            self.emailErrorMessage = emailMessage
        }
        if let code = json["response"]["code"].int {
            self.code = code
        }
        if let version = json["meta"]["version"].string {
            self.version = version
        }
        if let executedValue = json["meta"]["executed"].int {
            self.executed = executedValue
        }
    }
}
 
struct TernioAccountData {
    
    var accountID: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var address1: String?
    var city: String?
    var country: String?
    var state: String?
    var postalCode: String?
    var mobileNumber: String?
    var driversLicense: String?
    var passportNumber: String?
    
    var creationTimestampString: String?
    var referralCode: String = ""
    var username: String = ""
    var errors: Any?
    var responseMessage: Any?
    
    var version: String?
    var executed: Int?

    init(json: JSON) {
        
        if let accountID = json["data"]["id"].string {
            self.accountID = accountID
        }
        if let email = json["data"]["email"].string {
            self.email = email
        }
        if let firstName = json["data"]["firstname"].string {
            self.firstName = firstName
        }
        if let lastName = json["data"]["lastname"].string {
            self.lastName = lastName
        }
        if let address1 = json["data"]["address1"].string {
            self.address1 = address1
        }
        if let city = json["data"]["city"].string {
            self.city = city
        }
        if let country = json["data"]["country"].string {
            self.country = country
        }
        if let state = json["data"]["state"].string {
            self.state = state
        }
        if let postcode = json["data"]["zip_code"].string {
            self.postalCode = postcode
        }
        if let phone = json["data"]["phone"].string {
            self.mobileNumber = phone
        }
        if let version = json["meta"]["version"].string {
            self.version = version
        }
        if let executedValue = json["meta"]["executed"].int {
            self.executed = executedValue
        }
         
        self.creationTimestampString = json["data"]["created_at"].string ?? ""
        self.referralCode = json["data"]["referral_code"].string ?? ""
        self.username = json["data"]["username"].string ?? ""
        
        self.errors = json["response"]["errors"].array ?? []
        self.responseMessage =  json["response"]["message"].string ?? ""
    }
}

struct RegistrationData {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var address: String
    var city: String
    var country: String
    var state: String
    var postalCode: String
    var mobileNumber: String
    
    func registrationDictionary() -> [String: Any] {
        
        return ["email": self.email,
                "password": self.password,
                "firstname": self.firstName,
                "lastname": self.lastName,
                "address1": self.address,
                "city": self.city,
                "country": self.country,
                "state": self.state,
                "zip_code": self.postalCode,
                "phone": self.mobileNumber]
        
        
    }
}

struct CardRegistrationData {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var address: String
    var city: String
    var country: String
    var state: String
    var postalCode: String
    var mobileNumber: String
}

struct LFTokenObject {
    var token: String?
    var message: String?
    var success: Bool?
    
    init(json: JSON) {
        
        guard let msg = json["message"].string,
            let token = json["token"].string,
            let success = json["success"].bool else {
                NSLog("ERROR: LF Token Object not sending needed values")
                return
        }
        
        self.token = token
        self.message = msg
        self.success = success
    }
}

enum LFServerURL: String {
    case getToken = "http://api.litewalletservice.cc:8910/gettoken"
    case localGetToken = "http://localhost:8910/gettoken"
}
 
enum TernioEndpointURL: String {
    case user = "https://whitelabel.dev.api1.blockcard.ternio.co/v1/user"
    case exchangeRates = "https://whitelabel.dev.api1.blockcard.ternio.co/v1/exchange/rates" //GET
}

enum APIServerURL: String {
    
    //case productionLFjwtokenServer
    case stagingLFJWTServer = "http://api.litewalletservice.cc:8910/"
    //case developmentLFjwtokenServer
    //case productionTernioServer
    case stagingTernioServer = "https://whitelabel.dev.api1.blockcard.ternio.co/v1/"
    //case developmentTernioServer
}
