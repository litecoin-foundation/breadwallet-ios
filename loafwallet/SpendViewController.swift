//
//  SpendViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 9/5/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import Security
import LitewalletPartnerAPI

@objc protocol LitecoinCardRegistrationViewDelegate {
    func didReceiveOpenLitecoinCardAccount(account: Data)
    func litecoinCardAccountExists(error: Error)
    func floatingRegistrationHeader(shouldHide:Bool)
    func shouldReturnToLoginView()
}
 
class SpendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, LFAlertViewDelegate {
    
    static let serviceName = "com.litewallet.litecoincard.service"
    let rand = Int.random(in: 10000 ..< 20099)
    let emailRand = "kwashingt+" + "3" + "@gmail.com"
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
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
    @IBOutlet weak var loginButton: UIButton!
    
    
    var currentTextField: UITextField?
    var isRegistered: Bool?
    var pickerView: UIPickerView?
    var countries = [String]()
    let idTypes = [S.LitecoinCard.kycDriversLicense, S.LitecoinCard.kycPassport]
    
    let attrSilver = [NSAttributedString.Key.foregroundColor: UIColor.litecoinSilver]
    let attrOrange = [NSAttributedString.Key.foregroundColor: UIColor.litecoinOrange]
   
    var alertModal: LFAlertViewController?
    var userNotRegistered = true
    var delegate: LitecoinCardRegistrationViewDelegate?
    
    var manager = PartnerAPIManager.init()
    
    override func viewDidLoad() {
    
    setupModelData()
    super.viewDidLoad()
    setupSubViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchToCardViewController), name: kDidReceiveNewLitecoinCardData , object: nil)
    }
    
    
    override func viewWillLayoutSubviews() {
         
    }
    override func viewWillAppear(_ animated: Bool) {
         
    }
     
    private func setupModelData() {
        // Phase 0 only supports US transactions on LitecoinCard
        countries.append(Country.unitedStates.name)
    }
    
    private func setupSubViews() {
        
           self.pickerView = UIPickerView()
           pickerView?.delegate = self
           pickerView?.dataSource = self

           self.automaticallyAdjustsScrollViewInsets = true
           self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
           self.scrollView.delegate = self
           self.scrollView.isScrollEnabled = true
       
           emailTextField.placeholder = S.LitecoinCard.emailPlaceholder
           passwordTextField.placeholder = S.LitecoinCard.passwordPlaceholder
           confirmPasswordTextField.placeholder = S.LitecoinCard.confirmPasswordPlaceholder
           firstNameTextField.placeholder = S.LitecoinCard.firstNamePlaceholder
           lastNameTextField.placeholder = S.LitecoinCard.lastNamePlaceholder
           addressTextField.placeholder = S.LitecoinCard.addressPlaceholder
           cityTextField.placeholder = S.LitecoinCard.cityPlaceholder
           stateTextField.placeholder = S.LitecoinCard.statePlaceholder
           postalCodeTextField.placeholder = S.LitecoinCard.postalPlaceholder
           mobileTextField.placeholder = S.LitecoinCard.mobileNumberPlaceholder
           kycSSNTextField.placeholder = S.LitecoinCard.kycSSN
           kycCustomerIDTextField.placeholder = S.LitecoinCard.kycIDOptionsPlaceholder
           kycIDTypeTextField.placeholder = S.LitecoinCard.kycIDType
           registerButton.setTitle(S.LitecoinCard.registerButtonTitle, for: .normal)
           registerButton.layer.cornerRadius = 5.0
           countryTextField.text = Country.unitedStates.name

           let textFields = [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, confirmPasswordTextField, addressTextField, cityTextField, stateTextField, countryTextField, mobileTextField, postalCodeTextField, kycIDTypeTextField, kycSSNTextField, kycCustomerIDTextField]
           textFields.forEach { (textField) in
               textField?.inputAccessoryView = okToolbar()
           }
           kycIDTypeTextField.inputView = self.pickerView
           registerButton.layer.cornerRadius = 5.0
           registerButton.clipsToBounds = true
        
           loginButton.layer.borderWidth = 1.0
           loginButton.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)

           loginButton.layer.cornerRadius = 5.0
           loginButton.clipsToBounds = true
         
    }
//    var mockData: Data?
//      return
//    """
//        { "firstname":"Test",
//            "lastname":"User",
//            "email": emailRand,
//            "address1":"123 Main",
//            "city":"Sat",
//            "country":"US",
//            "phone":"1234567890",
//            "zip_code":"95014",
//            "username":"test"
//        }
//    """.data(using: .utf8)
 
    @IBAction func registerAction(_ sender: Any) {
        
        //Validate registration data
        let registeredData = didValidateRegistrationData
 
        // Mock Data
        let mockRegisteredData  = Data()
        
        ///Fake setting the UserDefaults
       let timestampString = "FAKE-DATE"
        UserDefaults.standard.set(timestampString, forKey: timeSinceLastLitecoinCardRequest)
        UserDefaults.standard.synchronize()
              
        //Send the data to make the REST API
        self.delegate?.didReceiveOpenLitecoinCardAccount(account: mockRegisteredData)
          
        //showRegistrationAlertView(data: mockedData)
    }
    @IBAction func returnToLoginView(_ sender: Any) {
        self.delegate?.shouldReturnToLoginView()
    }
    
    private func didValidateRegistrationData() -> (Data?) {
        //TODO: Refactor whenTernio OAUTH is ready

        let mockUser: [String: Any] = ["firstname":"Test", "lastname":"User", "email": emailRand,"address1":"123 Main","city":"Sat","country":"US","phone":"1234567890","zip_code":"95014", "username":"test"]
                      
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
        // return registrationData
            
        //           } catch(let error) {
        //
        //            let message = (error as! ValidationError).message
        //
        //            showErrorAlert(for: message)
        //
        //           }
        
        let jsonData = try? JSONSerialization.data(withJSONObject:mockUser)

        return jsonData
    }
    
    func showErrorAlert(for alert: String) {
        
        //TODO: Refactor whenTernio OAUTH is ready

        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showRegistrationAlertView(data: LitecoinCardAccountData) {
        
        
        //TODO: Refactor whenTernio OAUTH is ready
//        
//        let username = data.email
//        let password = data.accountID
//        
//       // password.data(using: String.Encoding.utf8)
//        
//        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
//                                    kSecAttrAccount as String: username,
//                                    kSecAttrServer as String: APIServerURL.stagingTernioServer,
//                                    kSecValueData as String: password]
//        
//        
//        self.alertModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFAlertViewController") as? LFAlertViewController
//        
//        guard let alertModal = self.alertModal else {
//            NSLog("ERROR: Alert object not initialized")
//            return
//
//        }
        
//        registrationAlert.headerLabel.text = S.Register.registerAlert
//        registrationAlert.dynamicLabel.text = ""
//        alertModal.providesPresentationContextTransitionStyle = true
//        alertModal.definesPresentationContext = true
//        alertModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        alertModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        alertModal.delegate = self
//       
//        self.present(alertModal, animated: true) {
//        APIManager.sharedInstance.getLFUserToken(ternioEndpoint: .user, registrationData: data) { lfObject in
//            
//                guard let tokenObject = lfObject else {
//                    NSLog("ERROR: LFToken not retreived")
//                    return
//                }
//             
//            self.fetchLitecoinCardAccount(registrationData: data, tokenObject: tokenObject)
//                
//            }
//        }
    }
    
    private func createUser(registrationData: Data) {
        
        //TODO: Refactor whenTernio OAUTH is ready
        manager.createUser(userData: registrationData) { (user) in
          
            var timestampString = ""
            
            if user != nil,
                let jsonObject = try? JSONSerialization.data(withJSONObject: user, options: []) {
                
                timestampString = "lastTimeReachedTimestamp" ///stripped from user timestamp
                UserDefaults.standard.set(timestampString, forKey: timeSinceLastLitecoinCardRequest)
                UserDefaults.standard.synchronize()
                self.delegate?.didReceiveOpenLitecoinCardAccount(account: jsonObject)
            }
        }
    }
     
    private func createLitecoinCardWallet(cardAccountData: LitecoinCardAccountData) {
        
        
        //TODO: Refactor whenTernio OAUTH is ready

 
        
       // self.delegate?.didReceiveTernioAccount(account: account)
    }
     
    //MARK: Card VC Methods
    
    @objc func switchToCardViewController() {
        if let cardVC = UIStoryboard.init(name: "Spend", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            print("Switch to CardView")
            addChildViewController(cardVC)
            view.addSubview(cardVC.view)
            didMove(toParentViewController: self)
         }
    }
     
    //MARK: UI Keyboard Methods
    
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
        okButton.tintColor = .liteWalletBlue
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
 
        if self.kycIDTypeTextField.isFirstResponder {
            return self.idTypes.count
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        return true
    }
    


}
 
