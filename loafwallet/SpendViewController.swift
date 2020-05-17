//
//  SpendViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/5/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import Security

protocol CardViewDelegate {
    func didReceiveTernioAccount(account: TernioAccountData)
    func ternioAccountExists(error: TernioErrorData)
}
  
class SpendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, LFAlertViewDelegate {
    
    static let serviceName = "com.litewallet.blockcard.service"

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var kycSSNTextField: UITextField!
    @IBOutlet weak var kycCustomerIDTextField: UITextField!
    @IBOutlet weak var kycIDTypeTextField: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!
    var currentTextField: UITextField?
    
    var pickerView: UIPickerView?
    var countries = [String]()
    let idTypes = [S.BlockCard.kycDriversLicense, S.BlockCard.kycPassport]
    
    let attrSilver = [NSAttributedString.Key.foregroundColor: UIColor.litecoinSilver]
    let attrOrange = [NSAttributedString.Key.foregroundColor: UIColor.litecoinOrange]
   
    var alertModal: LFAlertViewController?
    var userNotRegistered = true
    var delegate: CardViewDelegate?
    
    override func viewDidLoad() {
    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.automaticallyAdjustsScrollViewInsets = false
    
    setupModelData()
    super.viewDidLoad()
    setupSubViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissAlertView(notification:)), name: kDidReceiveNewTernioData , object: nil)
      
        //        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(dismissAlertView(notification:)), name: kDidReceiveNewTernioData , object: nil)
        
        
    }
    
    private func setupModelData() {
        Country.allCases.forEach {
            countries.append($0.name)
        }
    }
    
    private func setupSubViews() {
    
        self.pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
    
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = true
    
        titleLabel.text = S.BlockCard.title
        emailTextField.placeholder = S.BlockCard.emailPlaceholder
        passwordTextField.placeholder = S.BlockCard.passwordPlaceholder
        confirmPasswordTextField.placeholder = S.BlockCard.confirmPasswordPlaceholder
        firstNameTextField.placeholder = S.BlockCard.firstNamePlaceholder
        lastNameTextField.placeholder = S.BlockCard.lastNamePlaceholder
        addressTextField.placeholder = S.BlockCard.addressPlaceholder
        cityTextField.placeholder = S.BlockCard.cityPlaceholder
        stateTextField.placeholder = S.BlockCard.statePlaceholder
        postalCodeTextField.placeholder = S.BlockCard.postalPlaceholder
        mobileTextField.placeholder = S.BlockCard.mobileNumberPlaceholder
        kycSSNTextField.placeholder = S.BlockCard.kycSSN
        kycCustomerIDTextField.placeholder = S.BlockCard.kycIDOptionsPlaceholder
        kycIDTypeTextField.placeholder = S.BlockCard.kycIDType
        registerButton.setTitle(S.BlockCard.registerButtonTitle, for: .normal)
    
        countryTextField.text = S.BlockCard.USStates
        registerButton.layer.cornerRadius = 5.0
    
        let textFields = [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, confirmPasswordTextField, addressTextField, cityTextField, stateTextField, countryTextField, mobileTextField, postalCodeTextField, kycIDTypeTextField, kycSSNTextField, kycCustomerIDTextField]
        textFields.forEach { (textField) in
            textField?.inputAccessoryView = okToolbar()
        }
        countryTextField.inputView = self.pickerView
        kycIDTypeTextField.inputView = self.pickerView
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        let rand = Int.random(in: 10000 ..< 20099)
        let emailRand = "kwashingt+" + "\(rand)" + "@gmail.com"
        let mockedData = RegistrationData(email: emailRand, password: "password-23434", firstName: "firstName", lastName: "lastname", address: "100 address1", city: "city", country: "US", state: "CA", postalCode: "95129", mobileNumber: "4082167168")
    //  Mocking Over
//        do {
//            let email = try emailTextField.validatedText(validationType: ValidatorType.email)
//            let password = try passwordTextField.validatedText(validationType: ValidatorType.password)
//
//            let firstName = try firstNameTextField.validatedText(validationType: ValidatorType.firstName)
//            let lastname = try self.lastNameTextField.validatedText(validationType: ValidatorType.lastName)
//            let address1 = try addressTextField.validatedText(validationType: ValidatorType.address)
//            let city = try cityTextField.validatedText(validationType: ValidatorType.city)
//            let state = try stateTextField.validatedText(validationType: ValidatorType.state)
//            let postalCode = try postalCodeTextField.validatedText(validationType: ValidatorType.postalCode)
//            let country = try countryTextField.validatedText(validationType: ValidatorType.country)
//            let mobile = try mobileTextField.validatedText(validationType: ValidatorType.mobileNumber)
    
//         let registrationData = RegistrationData(email: email, password: password, firstName: firstName, lastName: lastname, address: address1, city: city, country: country, state: state, postalCode: postalCode, mobileNumber: mobile)
    
    
//           } catch(let error) {
//
//            let message = (error as! ValidationError).message
//
//            showErrorAlert(for: message)
//
//           }
        

        showRegistrationAlert(data: mockedData)
    }
    
    func showErrorAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showRegistrationAlert(data: RegistrationData) {
        
        
        let username = data.email
        let password = data.password.data(using: String.Encoding.utf8)!
        
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: username,
                                    kSecAttrServer as String: APIServerURL.stagingTernioServer,
                                    kSecValueData as String: password]
        
        
        self.alertModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFAlertViewController") as? LFAlertViewController
        
        guard let alertModal = self.alertModal else {
            NSLog("ERROR: Alert object not initialized")
            return

        }
        
//        registrationAlert.headerLabel.text = S.Register.registerAlert
//        registrationAlert.dynamicLabel.text = ""
        alertModal.providesPresentationContextTransitionStyle = true
        alertModal.definesPresentationContext = true
        alertModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alertModal.delegate = self
       
        self.present(alertModal, animated: true) {
        APIManager.sharedInstance.getLFUserToken(ternioEndpoint: .user, registrationData: data) { lfObject in
            
                guard let tokenObject = lfObject else {
                    NSLog("ERROR: LFToken not retreived")
                    return
                }
            
            print(tokenObject)
            
                self.fetchTernioAccount(registrationData: data, tokenObject: tokenObject)
            }
        }
    }
    
    private func fetchTernioAccount(registrationData: RegistrationData, tokenObject: LFTokenObject) {
        APIManager.sharedInstance.createTernioUserAccount(data: registrationData, tokenObject: tokenObject) { ternioAccountData in
             
            if let account = ternioAccountData as? TernioAccountData  {
                //self.delegate?.didReceiveTernioAccount(account: account)
                print("ACCOUNT \(account)")
               self.createTernioWallet(ternioAccount: account, tokenObject: tokenObject)
               //self.createTernioCard(ternioAccount: account, tokenObject: tokenObject)

            } else if let error = ternioAccountData as? TernioErrorData,
                let message = error.emailErrorMessage,
                let code = error.code {
                self.alertModal?.headerLabel.text = "Error"//S.Register.registerAlert
                self.alertModal?.dynamicLabel.text = message + " " + "(\(code))"
                self.alertModal?.activityIndicatorView.isHidden = true
                self.alertModal?.cancelButton.setTitle("Ok", for: .normal)
                self.delegate?.ternioAccountExists(error: error)
            }
            
            //TODO: Uncomment to show the card after launch
            //  UserDefaults.standard.set(ternioAccountData?.creationTimestampString, forKey: timeSinceLastBlockcardRequest)
            //  UserDefaults.standard.synchronize()
        }
    }
     
    private func createTernioWallet(ternioAccount: TernioAccountData, tokenObject: LFTokenObject) {
        
        let jsonWallet = APIManager.sharedInstance.createTernioWallet(ternioAccount: ternioAccount, tokenObject: tokenObject)
        
        
       // self.delegate?.didReceiveTernioAccount(account: account)
    }
    
    @objc func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
            self.resignFirstResponder()
    }
      
    func alertViewCancelButtonTapped() {
        dismiss(animated: true) {
            NSLog("Cancel Alert")
        }
    }
    
    @objc func dismissAlertView(notification: Notification) {
        dismiss(animated: true) {
                   NSLog("Dismissed Spend View Controller")
        }
    }
    
    func okToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 88))
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, okButton, flexibleSpace], animated: true)
        toolbar.tintColor = .litecoinDarkSilver
        toolbar.isUserInteractionEnabled = true
        return toolbar
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
    
    //MARK: UIPickerView Delegate & Setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if self.countryTextField.isFirstResponder {
            return self.countries.count
        }
        
        if self.kycIDTypeTextField.isFirstResponder {
            return self.idTypes.count
        }
        
        
    
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        if self.countryTextField.isFirstResponder {
            return self.countries[row]
        }
        
        if self.kycIDTypeTextField.isFirstResponder {
            return self.idTypes[row]
        }
    
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if self.countryTextField.isFirstResponder {
            countryTextField.text = self.countries[row]
        }
        
        if self.kycIDTypeTextField.isFirstResponder {
            self.kycIDTypeTextField.text = self.idTypes[row]
        }
    }
    
    //MARK: UITextField Delegate & Setup
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    currentTextField = textField
    
    //    guard let text = textField.text else {
    //      NSLog("Text not set")
    //      return
    //    }
    //
    //    guard let countryIndex = countries.firstIndex(of:text) else {
    //      NSLog("Country Index not set")
    //      return
    //    }
    
    //    if textField == self.countryTextField {
    //      self.pickerView?.selectedRow(inComponent: countryIndex)
    //    }
    
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        return true
    }
    


}
 
