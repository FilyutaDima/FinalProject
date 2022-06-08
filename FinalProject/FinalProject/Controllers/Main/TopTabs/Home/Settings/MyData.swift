//
//  SettingsVC.swift
//  FinalProject
//
//  Created by Dmitry on 22.05.22.
//

import UIKit

class MyDataVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle()
        startKeyboardObserver()
        setLightTheme()
        uploadEmail()
    }
    
    var user: User?
    var email: String?
    
    @IBOutlet var imageButtonsCollection: [UIButton]!
    @IBOutlet var textFieldsCollection: [UITextField]!
    
    @IBOutlet weak var countryFlagImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var enterOldPasswordTextField: UITextField!
    @IBOutlet weak var enterNewPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var passwordsStackView: UIStackView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func unlockNameTextField(_ sender: Any) {
        
        if nameTextField.isEnabled {
            nameTextField.alpha = 0.5
            nameTextField.isEnabled = false
        } else {
            nameTextField.alpha = 1
            nameTextField.isEnabled = true
        }
    }
    @IBAction func unlockEmailTextField(_ sender: Any) {
        if emailTextField.isEnabled {
            emailTextField.alpha = 0.5
            emailTextField.isEnabled = false
        } else {
            emailTextField.alpha = 1
            emailTextField.isEnabled = true
        }
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        passwordsStackView.isHidden.toggle()
    }
    @IBAction func showOldPassword(_ sender: Any) {
        enterOldPasswordTextField.isSecureTextEntry.toggle()
    }
    @IBAction func showNewPassword(_ sender: Any) {
        enterNewPasswordTextField.isSecureTextEntry.toggle()
    }
    @IBAction func showConfirmPassword(_ sender: Any) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    @IBAction func saveAction(_ sender: Any) {
        guard let user = user,
              let newName = nameTextField.text,
              let oldEmail = email,
              let newEmail = emailTextField.text,
              let newCountryCode = countryCodeLabel.text,
              let newNumber = phoneNumberTextField.text /*,
              let oldPassword = enterOldPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              let newPassword = enterNewPasswordTextField.text*/ else { return }
        
        if isDataChanged(oldData: user.contact.name, newData: newName) {
            changeName(user: user, to: newName)
        }
        
        if isDataChanged(oldData: oldEmail, newData: newEmail) {
            changeEmail(to: newEmail)
        }
        
        if isDataChanged(oldData: user.contact.phoneNumber.code, newData: newCountryCode) ||
            isDataChanged(oldData: user.contact.phoneNumber.number, newData: newNumber) {
            changePhoneNumber(user: user, newNumber: newNumber, newCountryCode: newCountryCode)
        }
    }
    
    @IBAction func showCountryCodeSelectionTapAction(_ sender: Any) {
        showAlertForSelectCountry(handler: { currentRow in
            
            let countryPhoneCodes = CountryPhoneCode.allCases.sorted(by: { $0.description < $1.description })
            let countryPhoneCode = countryPhoneCodes[currentRow]
            self.countryCodeLabel.text = countryPhoneCode.rawValue
            self.countryFlagImageView.image = UIImage(named: countryPhoneCode.countryCode)
        })
    }
    
    private func setNavigationTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 42) )
        titleLabel.text = NavigationTitle.myData
        titleLabel.textColor = SystemColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = SystemFont.titleSemiBold
        self.navigationController?.visibleViewController?.navigationItem.titleView = titleLabel
    }
    
    private func setLightTheme() {
        imageButtonsCollection.forEach { $0.setLightTheme(style: .color)}
        textFieldsCollection.forEach { textField in
            textField.setLightTheme()
            textField.alpha = 0.5
        }
        changePasswordLabel.setLightTheme(viewStyle: .color, fontStyle: .bodyRegular)
        saveButton.setLightTheme(style: .basic)
        countryCodeLabel.setLightTheme(viewStyle: .basic, fontStyle: .titleRegular)
    }
    
    private func uploadEmail() {
        email = NetworkManager.uploadEmail()
    }
    
    private func isDataChanged(oldData: String, newData: String) -> Bool{
        return oldData != newData
    }
    
    private func changeName(user: User, to newName: String) {
        NetworkManager.updateData(reference: Reference.users.child(user.uid).child(DBCategory.contact),
                                  key: DBCategory.name,
                                  object: newName) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(_):
                self?.nameTextField.text = newName
            }
        }
    }
    
    private func changeEmail(to newEmail: String) {
        NetworkManager.changeEmail(to: newEmail) { [weak self] error in
            if let error = error {
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
                return
            }
            self?.emailTextField.text = newEmail
        }
    }
    
    private func changePhoneNumber(user: User, newNumber: String, newCountryCode: String) {
        
        let phoneNumber = PhoneNumber(code: newCountryCode, number: newNumber)
        
        NetworkManager.updateData(reference: Reference.users.child(user.uid).child(DBCategory.contact),
                                  key: DBCategory.phoneNumber,
                                  object: phoneNumber) { [weak self] result in
            switch result {
            case .success(_):
                self?.countryCodeLabel.text = newCountryCode
                self?.phoneNumberTextField.text = newNumber
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
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
}
