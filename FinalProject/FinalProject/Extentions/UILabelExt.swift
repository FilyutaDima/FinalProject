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
    
    func setLightTheme(viewStyle: ViewStyle, fontStyle: FontStyle) {
        
        switch viewStyle {
        case .auxiliary:
            self.textColor = LabelAppearance.placeholderColor
        case .basic:
            self.textColor = LabelAppearance.textColorBlack
        case .color:
            self.textColor = LabelAppearance.textColorOrange
        case .white:
            self.textColor = LabelAppearance.textColorWhite
        }
        
        switch fontStyle {
        case .bodyRegular:
            self.font = SystemFont.bodyRegular
        case .bodySemiBold:
            self.font = SystemFont.bodySemiBold
        case .titleRegular:
            self.font = SystemFont.titleRegular
        case .titleSemiBold:
            self.font = SystemFont.titleSemiBold
        case .headerRegular:
            self.font = SystemFont.headerRegular
        case .headerSemiBold:
            self.font = SystemFont.headerSemiBold
        case .littleBodySemiBold:
            self.font = SystemFont.littleBodySemiBold
        case .littleBodyRegular:
            self.font = SystemFont.littleBodyRegular
        }
    }
}
