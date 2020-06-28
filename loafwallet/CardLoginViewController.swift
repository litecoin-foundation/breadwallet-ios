import UIKit

@objc protocol LitecoinCardLoginViewDelegate {
    func shouldShowRegistrationView()
    func shouldShowLoginView()
    func didLoginLitecoinCardAccount()
    func didForgetPassword()
}

class CardLoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, LFAlertViewDelegate {
    func alertViewCancelButtonTapped() {}

    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var placerholderImageView: UIImageView!

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var secureEntryToggleButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registrationButton: UIButton!

    @IBOutlet var emailUnderlineView: UIView!
    @IBOutlet var passwordUnderlineView: UIView!

    var currentTextField: UITextField?
    var isShowingPassword = false
    var loginFailMessage: String?
    var delegate: LitecoinCardLoginViewDelegate?

    var alertModal: LFAlertViewController?

    @IBAction func toggleSecureEntry(_: Any) {
        passwordTextField.isSecureTextEntry = isShowingPassword
        if isShowingPassword {
            secureEntryToggleButton.setImage(UIImage(named: "noshowpassword"), for: .normal)
        } else {
            secureEntryToggleButton.setImage(UIImage(named: "showpassword"), for: .normal)
        }
        isShowingPassword = !isShowingPassword
    }

    @IBAction func forgotPasswordAction(_: Any) {
        // TODO: Show Username/Email field and OK ...check for email acccount
        delegate?.didForgetPassword()
    }

    @IBAction func loginAction(_: Any) {
        // Mock Login Success
        delegate?.didLoginLitecoinCardAccount()

//        do {
//         let email = try emailTextField.validatedText(validationType: ValidatorType.email)
//         let password = try passwordTextField.validatedText(validationType: ValidatorType.password)
//            print(email)
//            print(password)
//
//        } catch ValidationError {
//
//        }

//       self.alertModal = UIStoryboard.init(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LFAlertViewController") as? LFAlertViewController
//
//       guard let alertModal = self.alertModal else {
//            NSLog("ERROR: Alert object not initialized")
//            return
//
//       }
//        alertModal.providesPresentationContextTransitionStyle = true
//        alertModal.definesPresentationContext = true
//        alertModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        alertModal.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        if self.loginFailMessage != nil,
//             let message = loginFailMessage {
//            alertModal.dynamicLabel.text =  message
//        } else {
//           alertModal.dynamicLabel.text = ""
//
//        }
//        alertModal.delegate = self
//        self.present(alertModal, animated: true)
    }

    @IBAction func registrationAction(_: Any) {
        // Mock New User no LitecoinCard  - Show Registration View
        delegate?.shouldShowRegistrationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupSubviews() {
        secureEntryToggleButton.setImage(UIImage(named: "noshowpassword"), for: .normal)

        // Corners

        loginButton.layer.cornerRadius = 5.0
        loginButton.clipsToBounds = true

        registrationButton.layer.cornerRadius = 5.0
        registrationButton.clipsToBounds = true

        // Borders

        registrationButton.layer.borderColor = #colorLiteral(red: 0.2053973377, green: 0.3632233143, blue: 0.6166344285, alpha: 1)
        registrationButton.layer.borderWidth = 1.0

        // Setup Scrollview
        automaticallyAdjustsScrollViewInsets = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
    }

    // MARK: UI Keyboard Methods

    @objc func dismissKeyboard() {
        currentTextField?.resignFirstResponder()
    }

    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        var insetConstant: CGFloat = 0
        var insetBottom: CGFloat = 0
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            insetConstant = 0
            insetBottom = 0
        case UIResponder.keyboardWillShowNotification:
            insetConstant = -100
            insetBottom = keyboardViewEndFrame.height - view.frame.height
        default:
            insetConstant = 0
        }

        // TODO: Adjust keyboard dismissal. Currently is does not reset
        scrollView.contentInset = UIEdgeInsets(top: insetConstant, left: 0, bottom: insetBottom, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    // MARK: AlertView

    // MARK: UITextField Delegate & Setup

    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField

        if textField == emailTextField {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)

        } else if textField == passwordTextField {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let passwordText = passwordTextField.text,
            let emailText = emailTextField.text else {
            return
        }

        if textField == emailTextField, passwordText.isEmpty {
            emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
            passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2222260833, green: 0.7466222048, blue: 0.415411979, alpha: 1)
            passwordTextField.becomeFirstResponder()
        }

        emailUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
        passwordUnderlineView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.3647058824, blue: 0.6156862745, alpha: 1)
        currentTextField?.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
