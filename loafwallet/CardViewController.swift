//
//  CardViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 10/1/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit 
import LitewalletPartnerAPI

class CardViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var cardViewHeight: NSLayoutConstraint! //200 pixels Start
    @IBOutlet weak var cardShadowView: LitecoinCardImageView!
    @IBOutlet weak var litecoinCardDepositStatusLabel: UILabel!
    
    @IBOutlet weak var staticCardBalanceLabel: UILabel!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    @IBOutlet weak var circleButtonContainerView: UIView!
    
    @IBOutlet weak var upAmountButton: UIButton!
    @IBOutlet weak var downAmountButton: UIButton!
    
    @IBOutlet weak var fiatLTCSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var transferTextField: UITextField!
    
    @IBOutlet weak var staticLitewalletBalanceLabel: UILabel!
    @IBOutlet weak var litewalletBalanceLabel: UILabel!
    
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
     
    var litecoinCardAccountData: [String:Any]?
    var userHasLitecoinCard: Bool = false
   
    var localFiatCode = "USD"
    var exchangeRate: Rate? {
        didSet { updateFiatCode() }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func updateFiatCode() {
        if let code = exchangeRate?.code {
            localFiatCode = code
        }
    }
    
    private func setupSubviews() {
    UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.barlowBold(size: 18)], for: .selected)
    UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font: UIFont.barlowBold(size: 18)], for: .normal)
         
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = true
        
        transferButton.setTitle(S.LitecoinCard.transferButtonTitle, for: .normal)
        transferButton.layer.cornerRadius = 5.0
        
        //Setup card view dimensions
        switch E.screenHeight {
        case 0..<320:
            cardViewHeight.constant = 100
        case 320..<564:
            cardViewHeight.constant = 175
        case 564..<768:
            cardViewHeight.constant = 250
        case 768..<2000:
            cardViewHeight.constant = 300
        default:
        cardViewHeight.constant = 200
        }
        
        // Setup corners 
        circleButtonContainerView.layer.cornerRadius = (circleButtonContainerView.frame.height / 2)
        circleButtonContainerView.clipsToBounds = true
        circleButtonContainerView.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)
        circleButtonContainerView.layer.borderWidth = 2.0
        circleButtonContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 
        fiatLTCSegmentedControl.setTitle("LTC", forSegmentAt: 0)
        fiatLTCSegmentedControl.setTitle(localFiatCode, forSegmentAt: 1)
        
        self.view.layoutIfNeeded()
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
    
               let yPosition = transferTextField.frame.origin.y 
                
               scrollView.contentInset = UIEdgeInsets(top: 0 - yPosition, left: 0, bottom: keyboardViewEndFrame.height - self.view.frame.height, right: 0)
               scrollView.scrollIndicatorInsets = scrollView.contentInset
           }
           
       }
    
    private func presentLitecoinCardAccountDetails() {
        
        
        
    }
    
    

}
