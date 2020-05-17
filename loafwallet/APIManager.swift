//
//  APIManager.swift
//  litewallet
//
//  Created by Kerry Washington on 8/4/19.
//  Copyright © 2019 litecoin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    
    let ternioUserURL = URL(string: TernioEndpointURL.user.rawValue)! //forced unwrap because this resource is static
 
    var ternioHTTPHeaders : HTTPHeaders = [
               "Accept": "application/json",
               "Content-Type": "application/json",
               "Authorization": "",
               "User-Agent": UAString(),
               "Cache-Control": "no-cache"
           ]
    
    
    enum TernioUserEndpoint {
        case user /* CREATE POST /user */
        case details  /* GET /user/:user_id */
        case ledger /* GET /user/:user_id/ledger */
        case verify /* PATCH /user/:user_id/verify */
        case suspend /* PATCH /user/:user_id/suspend */
        case delete /* DELETE /user/:user_id */
    }
    
    enum TernioUserNotificationEndpoint {
        case user /* CREATE POST /user/:user_id/notification */
        case list  /* GET /user/:user_id/notification */
        case markAsRead /* GET /user/:user_id/notification/read */
    }
     
    static let sharedInstance = APIManager()
    private var manager: SessionManager
    
    override private init() {
        self.manager = Alamofire.SessionManager.default
    }
 
    func getLFUserToken(ternioEndpoint: TernioUserEndpoint, registrationData: RegistrationData
    , completion: @escaping (LFTokenObject?) -> Void) {
     
        let failedObject = JSON(["success":false, "token": "INVALID TOKEN", "code": 400, "message":"FAIL"])
 
        let params = [
            "firstname": registrationData.firstName,
            "lastname": registrationData.lastName,
            "email": registrationData.email,
            "address1": registrationData.address,
            "city": registrationData.city,
            "state": registrationData.state,
            "zip_code": registrationData.postalCode,
            "country": registrationData.country,
            "phone": registrationData.mobileNumber,
            "username": registrationData.email
            ] as [String : Any]
 
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let litecoinFoundationURL = URL(string: LFServerURL.getToken.rawValue) {
            
            var postData = Data()
            do {
                postData = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("ERROR: Cannot JSON Conversion")
            }
 
            let request = NSMutableURLRequest(url: litecoinFoundationURL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                do {
                    
                    guard let lfData = data else {
                        NSLog("Error: LF Data not sent")
                        return
                    }
                    
                    let json = try JSON(data: lfData)
                    let tokenObject = LFTokenObject(json: json)
                        completion(tokenObject)
                } catch {
                    completion(nil)
                }
            })
            
            dataTask.resume()
        }
    }
     
    func createTernioUserAccount(data: RegistrationData, tokenObject: LFTokenObject, completion: @escaping (Any?) -> Void) {
        
        let params = data.registrationDictionary()
        guard let token = tokenObject.token else { return }
        let tokenString = "Bearer " + token
        
        var headers = self.ternioHTTPHeaders
        headers["Authorization"] = tokenString
        
        self.manager.request(ternioUserURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
 
            var jsonData = JSON()
            guard let ternioData = response.data else {
                NSLog("Error: Ternio Data not sent")
                return
            }
              
            do {
                 jsonData = try JSON(data: ternioData)
             } catch {
                 NSLog("ERROR: Unable to create user Data JSON")
            }
             
            switch response.response?.statusCode {
            case 200:
            let ternioDataObject = TernioAccountData(json: jsonData)
            completion(ternioDataObject)
            case 422:
            let ternioErrorObject = TernioErrorData(json: jsonData)
            completion(ternioErrorObject)
            default:
                NSLog("error with response status: \(String(describing:response.response?.statusCode))")
            }
        }
     }
    
    func createTernioWallet(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) -> TernioUserTestnetWallet? {
        //Per Corey of Ternio this step is superflouus and will be combined in new revisions 10/17/19
        var userWallet = TernioUserTestnetWallet(json: JSON())

        guard let id = ternioAccount.accountID else {
            NSLog("ERROR: Unable to init id string")
            return nil }
        guard let url = URL(string: TernioEndpointURL.user.rawValue + "/" + id + "/wallet" ) else {
            NSLog("ERROR: Unable to init url")
            return nil }
        guard let token = tokenObject.token else {
            NSLog("ERROR: Unable to init token")
            return nil }
        var headers = self.ternioHTTPHeaders
        headers["Authorization"] = "Bearer " + token
        
           self.manager.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
           
            switch response.response?.statusCode {
            case 200:
                
                if let walletdetails = self.fetchTernioWalletDetails(ternioAccount: ternioAccount, tokenObject: tokenObject) {
                    userWallet = walletdetails
                } else {
                    NSLog("ERROR: Unable retrieve wallet details")
                }
                
            default:
                NSLog("ERROR: with response status: \(String(describing:response.response?.statusCode))")
            }
            }
           
            return userWallet
       }
    func fetchTernioWalletDetails(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) -> TernioUserTestnetWallet? {
          
        var userWallet = TernioUserTestnetWallet(json: JSON())
         guard let id = ternioAccount.accountID else {
             NSLog("ERROR: Unable to init id string")
             return nil }
         guard let url = URL(string: TernioEndpointURL.user.rawValue + "/" + id + "/wallet" ) else {
             NSLog("ERROR: Unable to init url")
             return nil }
         guard let token = tokenObject.token else {
             NSLog("ERROR: Unable to init token")
             return nil }
         var headers = self.ternioHTTPHeaders
         headers["Authorization"] = "Bearer " + token

        self.manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
              
         var jsonData = JSON()
         guard let walletData = response.data else {
             NSLog("ERROR: Ternio wallet data not sent")
             return
         }
           
         do {
              jsonData = try JSON(data: walletData)
          } catch {
              NSLog("ERROR: Unable to retreive wallet details JSON")
         }
          
         switch response.response?.statusCode {
         case 200:
          userWallet = TernioUserTestnetWallet(json: jsonData)
         default:
             NSLog("ERROR with response status: \(String(describing:response.response?.statusCode))")
         }
         }
        
        return userWallet
    }
    
//    func fetchBlockcardDetails(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) -> JSON? {
//        //GET /user/:user_id/card
//        
//    }
//    
//    func fetchBlockcardVirtualImage(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) -> JSON? {
//        //GET /user/:user_id/card/image
//        
//    }
//    
//    func subscribeToBlockcardPlan(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) -> JSON? {
//        
//    }

}
