//
//  UITextViewExt.swift
//  FinalProject
//
//  Created by Dmitry on 19.05.22.
//

import UIKit

extension UITextView {
    
    func setLightTheme() {
        self.backgroundColor = TextFieldAppearance.backgroundColor
        self.textColor = TextFieldAppearance.textColor
        self.layer.borderColor = TextFieldAppearance.borderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.font = SystemFont.bodyRegular
    }
}
