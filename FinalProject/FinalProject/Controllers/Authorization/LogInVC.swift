//
//  SignInVC.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import UIKit
import FirebaseAuth

class LogInVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startKeyboardObserver()
        hideKeyboardWhenTappedAround()
        setLightTheme()
    }
    
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        Reference.auth.signIn(withEmail: email.trim(), password: password) { result, error in
        
            if let error = error {
                self.showError(error)
            }
        }
    }
    
    private func setLightTheme() {
        textFieldCollection.forEach { $0.setLightTheme() }
        logInButton.setLightTheme(style: .basic)
        registrationLabel.setLightTheme(viewStyle: .color, fontStyle: .littleBodySemiBold)
        forgotPasswordLabel.setLightTheme(viewStyle: .basic, fontStyle: .littleBodyRegular)
        loginTitleLabel.setLightTheme(viewStyle: .basic, fontStyle: .headerSemiBold)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Функция в разработке", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
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
            case .wrongPassword:
                self.passwordTextField.setError()
                self.errorLabel.setError(with: .wrongPassword)
            case .userNotFound:
                self.emailTextField.setError()
                self.errorLabel.setError(with: .userNotFound)
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
        print("\(LogInVC.description()) closed")
    }
}
