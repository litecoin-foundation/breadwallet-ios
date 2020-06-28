import LitewalletPartnerAPI
import Security
import UIKit

@objc protocol LitecoinCardRegistrationViewDelegate {
    func didReceiveOpenLitecoinCardAccount(account: Data)
    func litecoinCardAccountExists(error: Error)
    func floatingRegistrationHeader(shouldHide: Bool)
    func shouldReturnToLoginView()
}

class SpendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, LFAlertViewDelegate {
    static let serviceName = "com.litewallet.litecoincard.service"
    let rand = Int.random(in: 10000 ..< 20099)
    let emailRand = "kwashingt+" + "3" + "@gmail.com"
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var headerLabel: UILabel!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var postalCodeTextField: UITextField!
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var kycSSNTextField: UITextField!
    @IBOutlet var kycCustomerIDTextField: UITextField!
    @IBOutlet var kycIDTypeTextField: UITextField!

    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!

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

    var manager = PartnerAPIManager()

    override func viewDidLoad() {
        setupModelData()
        super.viewDidLoad()
        setupSubViews()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchToCardViewController), name: kDidReceiveNewLitecoinCardData, object: nil)
    }

    override func viewWillLayoutSubviews() {}

    override func viewWillAppear(_: Bool) {}

    private func setupModelData() {
        // Phase 0 only supports US transactions on LitecoinCard
        countries.append(Country.unitedStates.name)
    }

    private func setupSubViews() {
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self

        automaticallyAdjustsScrollViewInsets = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true

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
        textFields.forEach { textField in
            textField?.inputAccessoryView = okToolbar()
        }
        kycIDTypeTextField.inputView = pickerView
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

    @IBAction func registerAction(_: Any) {
        // Validate registration data
        let registeredData = didValidateRegistrationData

        // Mock Data
        let mockRegisteredData = Data()

        /// Fake setting the UserDefaults
        let timestampString = "FAKE-DATE"
        UserDefaults.standard.set(timestampString, forKey: timeSinceLastLitecoinCardRequest)
        UserDefaults.standard.synchronize()

        // Send the data to make the REST API
        delegate?.didReceiveOpenLitecoinCardAccount(account: mockRegisteredData)

        // showRegistrationAlertView(data: mockedData)
    }

    @IBAction func returnToLoginView(_: Any) {
        delegate?.shouldReturnToLoginView()
    }

    private func didValidateRegistrationData() -> (Data?) {
        // TODO: Refactor whenTernio OAUTH is ready

        let mockUser: [String: Any] = ["firstname": "Test", "lastname": "User", "email": emailRand, "address1": "123 Main", "city": "Sat", "country": "US", "phone": "1234567890", "zip_code": "95014", "username": "test"]

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

        let jsonData = try? JSONSerialization.data(withJSONObject: mockUser)

        return jsonData
    }

    func showErrorAlert(for alert: String) {
        // TODO: Refactor whenTernio OAUTH is ready

        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    func showRegistrationAlertView(data _: LitecoinCardAccountData) {
        // TODO: Refactor whenTernio OAUTH is ready
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

    private func createUser(registrationData _: Data) {
        // TODO: Refactor whenTernio OAUTH is ready
//        manager.createUser(userDataParams: <#T##[String : Any]#>, completion: <#T##(User?) -> Void#>)
//
//            var timestampString = ""
//
//            if user != nil,
//                let jsonObject = try? JSONSerialization.data(withJSONObject: user, options: []) {
//
//                timestampString = "lastTimeReachedTimestamp" ///stripped from user timestamp
//                UserDefaults.standard.set(timestampString, forKey: timeSinceLastLitecoinCardRequest)
//                UserDefaults.standard.synchronize()
//                self.delegate?.didReceiveOpenLitecoinCardAccount(account: jsonObject)
//            }
//        }
    }

    private func createLitecoinCardWallet(cardAccountData _: LitecoinCardAccountData) {
        // TODO: Refactor whenTernio OAUTH is ready

        // self.delegate?.didReceiveTernioAccount(account: account)
    }

    // MARK: Card VC Methods

    @objc func switchToCardViewController() {
        if let cardVC = UIStoryboard(name: "Spend", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            print("Switch to CardView")
            addChild(cardVC)
            view.addSubview(cardVC.view)
            didMove(toParent: self)
        }
    }

    // MARK: UI Keyboard Methods

    @objc func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
        resignFirstResponder()
    }

    func alertViewCancelButtonTapped() {
        dismiss(animated: true) {
            NSLog("Cancel Alert")
        }
    }

    @objc func dismissAlertView(notification _: Notification) {
        dismiss(animated: true) {
            NSLog("Dismissed Spend View Controller")
        }
    }

    func okToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 88))
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        okButton.tintColor = .liteWalletBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, okButton, flexibleSpace], animated: true)
        toolbar.tintColor = .litecoinDarkSilver
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }

    @objc private func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            guard let yPosition = currentTextField?.frame.origin.y else {
                NSLog("ERROR:  - Could not get y position")
                return
            }

            scrollView.contentInset = UIEdgeInsets(top: 0 - yPosition, left: 0, bottom: keyboardViewEndFrame.height - view.frame.height, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }

    // MARK: UIPickerView Delegate & Setup

    func numberOfComponents(in _: UIPickerView) -> Int { return 1 }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        if kycIDTypeTextField.isFirstResponder {
            return idTypes.count
        }
        return 0
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        if kycIDTypeTextField.isFirstResponder {
            return idTypes[row]
        }

        return ""
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if countryTextField.isFirstResponder {
            countryTextField.text = countries[row]
        }

        if kycIDTypeTextField.isFirstResponder {
            kycIDTypeTextField.text = idTypes[row]
        }
    }

    // MARK: UITextField Delegate & Setup

    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        return true
    }
}
