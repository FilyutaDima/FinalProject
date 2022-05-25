//
//  UITextFieldExt.swift
//  FinalProject
//
//  Created by Dmitry on 12.04.22.
//

import UIKit

extension UITextField {
    func resetError() {
        self.layer.borderColor = TextFieldAppearance.borderColor.cgColor
    }
    
    func setError() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func setLightTheme() {
        self.backgroundColor = TextFieldAppearance.backgroundColor
        self.textColor = TextFieldAppearance.textColor
        let placeholder = self.placeholder ?? ""
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: TextFieldAppearance.placeholderColor])
        self.layer.borderColor = TextFieldAppearance.borderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.font = SystemFont.bodyRegular
    }
}
