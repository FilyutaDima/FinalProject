//
//  SignUpVC.swift
//  FinalProject
//
//  Created by Dmitry on 19.03.22.
//

import Firebase
import FirebaseAuth
import UIKit

class SignUpVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        startKeyboardObserver()
        hideKeyboardWhenTappedAround()
        changeCountryCodeAction()
    }
    
    private var firstname: String = ""
    private var lastname: String = ""
    private var email: String = ""
    private var phoneNumber: String = ""
    private var password: String = ""

    @IBOutlet private final var rootScrollView: UIScrollView!
    @IBOutlet private final var firstnameTextField: UITextField!
    @IBOutlet private final var lastnameTextField: UITextField!
    @IBOutlet private final var emailTextField: UITextField!
    @IBOutlet private final var countryDataStackView: UIStackView!
    @IBOutlet private final var countryFlagImageView: UIImageView!
    @IBOutlet private final var countryCodeLabel: UILabel!
    @IBOutlet private final var phoneTextField: UITextField!
    @IBOutlet private final var passwordTextField: UITextField!
    @IBOutlet private final var confirmPasswordTextField: UITextField!
    @IBOutlet private final var errorLabel: UILabel!
    
    @IBAction func firstnameTextFieldChanged(_ sender: UITextField) {
        sender.resetError()
        errorLabel.resetError()
    }
    @IBAction func lastnameTextFieldChanged(_ sender: UITextField) {
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
            Auth.auth().createUser(withEmail: email.trim(), password: password) { result, error in
                if let error = error {
                    self.showError(error)
                } else {
                    let user = User(firstname: self.firstname, lastname: self.lastname, phoneNumber: "", email: self.email, petsID: nil)
                    
                    Database.database().reference().child(Constants.databaseUserTable).child(result!.user.uid).setValue(user.toDictionary)
                }
            }
        }
    }
    
    private func isVerificateData() -> Bool {
        guard let firstname = firstnameTextField.text,
              let lastname = lastnameTextField.text,
              let codeCountry = countryCodeLabel.text,
              let phoneNumber = phoneTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return false }
        
        if firstname.isEmpty {
            showError(NSError(domain: "", code: CustomAuthErrorCode.missingFirstname.rawValue, userInfo: nil))
            return false
        }
        
        if lastname.isEmpty {
            showError(NSError(domain: "", code: CustomAuthErrorCode.missingLastname.rawValue, userInfo: nil))
            return false
        }
        
        if password != confirmPassword {
            showError(NSError(domain: "", code: CustomAuthErrorCode.confirmPassword.rawValue, userInfo: nil))
            return false
        }
        
        self.firstname = firstname
        self.lastname = lastname
        self.phoneNumber = "\(codeCountry)\(phoneNumber)"
        self.email = email
        self.password = password
        
        return true
    }
    
    private func showError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            
            default:
                print(error)
            }
        } else if let errorCode = CustomAuthErrorCode(rawValue: error._code) {
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
            case .missingFirstname:
                self.firstnameTextField.setError()
                self.errorLabel.setError(with: .missingFirstname)
            case .missingLastname:
                self.lastnameTextField.setError()
                self.errorLabel.setError(with: .missingLastname)
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
    
    private func changeCountryCodeAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCountryCodeSelection(_:)))
        countryDataStackView.addGestureRecognizer(tap)
    }
    
    private func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func showCountryCodeSelection(_ sender: UITapGestureRecognizer? = nil) {
        let rootVC = UIViewController()
        
        let countryCodesPickerView = UIPickerView()
        
        rootVC.view.addSubview(countryCodesPickerView)
        
        countryCodesPickerView.dataSource = self
        countryCodesPickerView.delegate = self
        
        countryCodesPickerView.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor).isActive = true
        countryCodesPickerView.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: Constants.selectCountryCode, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.apply, style: .default, handler: { _ in
            let currentRaw = countryCodesPickerView.selectedRow(inComponent: 0)
            let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
            let countryPhoneCode = countryPhoneCodes[currentRaw]
            self.countryCodeLabel.text = countryPhoneCode.rawValue
            self.countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
            
        }))
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
        alert.setValue(rootVC, forKey: "contentViewController")
        
        present(alert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
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
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryPhoneCode.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryPhoneCode.allCases[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rootView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        
        let countryFlagImageView = UIImageView(frame: CGRect(x: 40, y: 15, width: 30, height: 30))
        countryFlagImageView.layer.borderWidth = 2
        countryFlagImageView.layer.borderColor = UIColor.gray.cgColor
        countryFlagImageView.layer.cornerRadius = 15
        
        let countryCodeLabel = UILabel(frame: CGRect(x: 100, y: 0, width: pickerView.bounds.width - 90, height: 60))
        countryCodeLabel.textAlignment = .center
        
        let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
        let countryPhoneCode = countryPhoneCodes[row]
        
        countryCodeLabel.text = countryPhoneCode.description
        countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        
        rootView.addSubview(countryCodeLabel)
        rootView.addSubview(countryFlagImageView)
        
        return rootView
    }
}
