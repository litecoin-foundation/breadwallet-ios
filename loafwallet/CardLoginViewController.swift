//
//  CardLoginViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 6/7/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import UIKit

class CardLoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var placerholderImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var secureEntryToggleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var emailUnderlineView: UIView!
    @IBOutlet weak var passwordUnderlineView: UIView!
    
    var currentTextField: UITextField?
    var isShowingPassword = false
    
    @IBAction func toggleSecureEntry(_ sender: Any) {
        passwordTextField.isSecureTextEntry = isShowingPassword
        isShowingPassword = !isShowingPassword
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        
        //Setup Scrollview
        self.automaticallyAdjustsScrollViewInsets = true
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = true
        
    }
    
    //MARK: UI Keyboard Methods
   @objc func dismissKeyboard() {
       currentTextField?.resignFirstResponder()
           self.resignFirstResponder()
   }
    
   @objc private func adjustForKeyboard(notification: NSNotification) {
  
       guard let keyboardValue = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
           return
       }
        
       let keyboardScreenEndFrame = keyboardValue
       let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
   
       if notification.name == NSNotification.Name.UIKeyboardWillHide {
           scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       } else {

           guard let yPosition = currentTextField?.frame.origin.y else {
               NSLog("ERROR:  - Could not get y position")
               return
           }
            
           scrollView.contentInset = UIEdgeInsets(top: 0 - yPosition, left: 0, bottom: keyboardViewEndFrame.height - self.view.frame.height, right: 0)
           scrollView.scrollIndicatorInsets = scrollView.contentInset
       }
       
   }
    
    
    //MARK: UITextField Delegate & Setup
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)

        } else if textField == passwordTextField {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == emailTextField {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
        } else if textField == passwordTextField {
            print("Password")

        }
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
