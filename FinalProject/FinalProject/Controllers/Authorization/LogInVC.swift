//
//  SignInVC.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LogInVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.backgroundColor = UIColor(white: 0, alpha: 0.5)

        startKeyboardObserver()
        hideKeyboardWhenTappedAround()
    }
    
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email.trim(), password: password) { result, error in
            
            if let error = error {
                self.showError(error)
            } else {
                
            }
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
