//
//  UITextFieldExt.swift
//  FinalProject
//
//  Created by Dmitry on 12.04.22.
//

import UIKit

extension UITextField {
    func resetError() {
        self.layer.borderWidth = 0
    }
    
    func setError() {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
    }
}
