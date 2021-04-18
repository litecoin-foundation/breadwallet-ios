//
//  CardViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import SwiftUI
import KeychainAccess
 

class CardViewModel: ObservableObject {
    
    //MARK: - Login Status
    @Published
    var isLoggedIn: Bool = false
    
    @Published
    var isNotRegistered: Bool = true
      
    //MARK: - Combine Variables
    @Published
    var walletDetails: CardWalletDetails?
     
    init() { }
    
    func fetchCardWalletDetails(completion: @escaping () -> Void) {
        
        let cardService = "com.litecoincard.service"
        let keychain = Keychain(service: cardService)
        
        guard let token = (try? keychain.getString("token")) as? String else {
            print("Error: Token not found")
            return
        }
        
        guard let userID = (try? keychain.getString("userID")) as? String else {
            print("Error: UserID not found")
            return
        }
        
        PartnerAPI.shared.getWalletDetails(userID: userID, token: token) { detailsDict in
            
            //Only reteives the data element there is the metadata and the result as well
            guard let data = detailsDict?["data"] as? [String: Any] else {
                print("Error: Data dict not found")
                return
            }
            
            do {
                
                let jsonData = try JSONSerialization.data(withJSONObject: data, options:[])
                
                let decoder = JSONDecoder() 
                
                let walletDetails = try? decoder.decode(CardWalletDetails.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.walletDetails = walletDetails
                }
            } catch {
                print("Error: Incomplete dictionary data from partner API")
                LWAnalytics.logEventWithParameters(itemName:._20210405_TAWDF) 
            }
        }
    }
}
