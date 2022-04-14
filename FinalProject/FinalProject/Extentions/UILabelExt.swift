//
//  UILabelExt.swift
//  FinalProject
//
//  Created by Dmitry on 12.04.22.
//

import UIKit

extension UILabel {
    func resetError() {
        self.text = ""
        self.isHidden = true
    }
    
    func setError(with errorCode: CustomAuthErrorCode) {
        self.isHidden = false
        self.text = errorCode.description
    }
}
