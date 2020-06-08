//
//  CardLoginViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/7/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import UIKit

class CardLoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var litecoinCardTeaserView: LitecoinCardImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        //Corners
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.clipsToBounds = true
        
        registrationButton.layer.cornerRadius = 5.0
        registrationButton.clipsToBounds = true
        
        
        //Borders
        
        registrationButton.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)
        registrationButton.layer.borderWidth = 1.0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
