//
//  BaseViewController.swift
//  FinalProject
//
//  Created by Dmitry on 30.03.22.
//

import Firebase
import UIKit

class BaseVC: UIViewController {
    
    func showAlertDownloadError(handler: @escaping ((UIAlertAction) -> ())) {
        let alert = UIAlertController(title: Constants.downloadError, message: Constants.downloadErrorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.repeatDownload, style: .default, handler: { action in
            handler(action)
        }))
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
    }
    
    func showAlertForSelectCountry(handler: @escaping ((Int) -> ())) {
        
        let rootVC = UIViewController()
        
        let countryCodesPickerView = UIPickerView()
        
        rootVC.view.addSubview(countryCodesPickerView)
        
        countryCodesPickerView.dataSource = self
        countryCodesPickerView.delegate = self
        
        countryCodesPickerView.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor).isActive = true
        countryCodesPickerView.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: Constants.selectCountryCode, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.apply, style: .default, handler: { _ in
            handler(countryCodesPickerView.selectedRow(inComponent: 0))
        }))
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
        alert.setValue(rootVC, forKey: "contentViewController")
        
        present(alert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    func takePhotoAction(handler: @escaping ((UIAlertAction) -> ())) {
        let alert = UIAlertController(title: "Добавить  питомца",
                                      message: "Вы можете сделать фото или добавить его из библиотеки.",
                                      preferredStyle: UIAlertController.Style.alert)
                
        alert.addAction(UIAlertAction(title: PhotoAction.openCamera, style: UIAlertAction.Style.default, handler: { action in
            handler(action)
        }))
        alert.addAction(UIAlertAction(title: PhotoAction.openLibrary, style: UIAlertAction.Style.default, handler: { action in
            handler(action)
        }))
        alert.addAction(UIAlertAction(title: Constants.cancel, style: UIAlertAction.Style.cancel, handler: nil))
                
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension BaseVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
