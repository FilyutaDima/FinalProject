//
//  SignUpVC.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import Firebase
import FirebaseAuth
import UIKit
import FirebaseSharedSwift

class SignUpVC: BaseVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startKeyboardObserver()
        hideKeyboardWhenTappedAround()
        setNavigationTitle()
        setLightTheme()
    }
    
    private var userName: String = ""
    private var email: String = ""
    private var password: String = ""
    private var phoneCode: String = ""
    private var phoneNumber: String = ""

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet private final var rootScrollView: UIScrollView!
    @IBOutlet private final var userNameTextField: UITextField!
    @IBOutlet private final var emailTextField: UITextField!
    @IBOutlet private final var countryDataStackView: UIStackView!
    @IBOutlet private final var countryFlagImageView: UIImageView!
    @IBOutlet private final var countryCodeLabel: UILabel!
    @IBOutlet private final var phoneTextField: UITextField!
    @IBOutlet private final var passwordTextField: UITextField!
    @IBOutlet private final var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet private final var errorLabel: UILabel!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    @IBAction func userNameTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    @IBAction func phoneTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        confirmPasswordTextField.resetError()
        sender.resetError()
        errorLabel.resetError()
    }
    @IBAction func confirmPasswordTextFieldChanged(_ sender: UITextField) {
        passwordTextField.resetError()
        sender.resetError()
        errorLabel.resetError()
    }
    
    @IBAction func addNewUserAction() {
        
        if isVerificateData() {
            Reference.auth.createUser(withEmail: email.trim(), password: password) { [weak self] result, error in
                if let error = error {
                    self?.showError(error)
                }
                
                if let result = result,
                   let self = self {
                    let phoneNumber = PhoneNumber(code: self.phoneCode, number: self.phoneNumber)
                    let contact = Contact(name: self.userName, phoneNumber: phoneNumber)
                    let user = User(uid: result.user.uid, contact: contact/*, myPetsId: [], myPostsId: []*/)
                    let userDict = try? FirebaseDataEncoder().encode(user)
                
                    Reference.users.child(result.user.uid).setValue(userDict)
                }
            }
        }
    }
    
    private func setNavigationTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = NavigationTitle.registration
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func setLightTheme() {
        textFieldCollection.forEach { $0.setLightTheme() }
        countryCodeLabel.setLightTheme(viewStyle: .basic, fontStyle: .bodyRegular)
        saveButton.setLightTheme(style: .basic)
        infoLabel.setLightTheme(viewStyle: .basic, fontStyle: .littleBodyRegular)
    }
    
    private func isVerificateData() -> Bool {
        guard let userName = userNameTextField.text,
              let phoneCode = countryCodeLabel.text,
              let phoneNumber = phoneTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return false }
        
        if userName.isEmpty {
            showError(NSError(domain: "", code: CustomAuthErrorCode.missingUsername.rawValue, userInfo: nil))
            return false
        }
        
        if password != confirmPassword {
            showError(NSError(domain: "", code: CustomAuthErrorCode.confirmPassword.rawValue, userInfo: nil))
            return false
        }
        
        self.userName = userName
        self.email = email
        self.password = password
        self.phoneCode = phoneCode
        self.phoneNumber = phoneNumber
        
        return true
    }
    
    private func showError(_ error: Error) {
        if let errorCode = CustomAuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .missingEmail:
                self.emailTextField.setError()
                self.errorLabel.setError(with: .missingEmail)
            case .invalidEmail:
                self.emailTextField.setError()
                self.errorLabel.setError(with: .invalidEmail)
            case .emailAlreadyInUse:
                self.emailTextField.setError()
                self.errorLabel.setError(with: .emailAlreadyInUse)
            case .weakPassword:
                self.passwordTextField.setError()
                self.errorLabel.setError(with: .weakPassword)
            case .missingUsername:
                self.userNameTextField.setError()
                self.errorLabel.setError(with: .missingUsername)
            case .confirmPassword:
                self.passwordTextField.setError()
                self.errorLabel.setError(with: .confirmPassword)
                self.confirmPasswordTextField.setError()
                self.errorLabel.setError(with: .confirmPassword)
            default:
                print(error)
            }
        }
    }
    
    private func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func showCountryCodeSelectionTapAction(_ sender: Any) {
        showAlertForSelectCountry(handler: { currentRow in
            
            let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
            let countryPhoneCode = countryPhoneCodes[currentRow]
            self.countryCodeLabel.text = countryPhoneCode.rawValue
            self.countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        })
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide() {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        print("\(SignUpVC.description()) closed")
    }
}
