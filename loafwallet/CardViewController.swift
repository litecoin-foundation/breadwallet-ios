//
//  CardViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 10/1/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var blockcardImageView: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var bottomVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var demoTimestampLabel: UILabel!
    @IBOutlet weak var demoIDLabel: UILabel!
    @IBOutlet weak var demoVersionLabel: UILabel!
    
    var ternioAccountData: TernioAccountData?
    var userHasTernioCard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        animateCardToBottomView()
    }
    
    private func setupSubviews() {
        
        guard let accountData = self.ternioAccountData else {
            NSLog("ERROR: ternio data not found")
            return
        }
        self.demoTimestampLabel.alpha = 0
        self.demoIDLabel.alpha = 0
        self.demoVersionLabel.alpha = 0
        self.demoTimestampLabel.text = accountData.creationTimestampString
        self.demoIDLabel.text = accountData.accountID
        self.demoVersionLabel.text = accountData.version
        
//        SUCCESS: {
//            data =     {
//                address1 = "100 address1";
//                city = city;
//                country = US;
//                "created_at" = "2019-10-08 17:28:03";
//                email = "kwashingt+411@gmail.com";
//                firstname = firstName;
//                id = "efaf6187-8511-4e61-be7c-527df7e010ff";
//                lastname = lastname;
//                phone = 4082167168;
//                "referral_code" = "<null>";
//                state = CA;
//                username = "<null>";
//                "zip_code" = 95129;
//            };
//            meta =     {
//                executed = 1570555683163;
//                received = "<null>";
//                version = "1.0.2";
//            };
//            response =     {
//                code = 200;
//                errors =         {
//                };
//                message = OK;
//            };
//        }
        
         
        if let initial  = accountData.firstName?.prefix(1) {
            self.firstnameLabel.text = initial.uppercased() + "."
        }
        
        self.lastnameLabel.text = accountData.lastName?.uppercased()
        self.cardBackgroundView.layer.cornerRadius =  5.0
        self.cardBackgroundView.clipsToBounds = true
        self.bottomVerticalConstraint.constant = self.view.frame.height/2  - self.cardBackgroundView.frame.height/2
        self.view.layoutIfNeeded()
    }
    
    private func animateCardToBottomView() {
        
          bottomVerticalConstraint.constant = 50
          
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
          }, completion: { finished in
            
            self.demoTimestampLabel.alpha = 1
            self.demoIDLabel.alpha = 1
            self.demoVersionLabel.alpha = 1
            
            self.presentBiBoxAccountDetails()
          })
    }
    
    private func presentBiBoxAccountDetails() {
        
    }
    
    

}
