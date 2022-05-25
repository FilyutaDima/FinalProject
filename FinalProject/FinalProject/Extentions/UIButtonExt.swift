//
//  UIButtonExt.swift
//  FinalProject
//
//  Created by Dmitry on 19.05.22.
//

import UIKit

extension UIButton {
    func setLightTheme(style: ViewStyle) {
        switch style {
        case .auxiliary:
            self.backgroundColor = ButtonAppearance.auxiliaryBackgroundColor
            self.titleLabel?.textColor = ButtonAppearance.auxiliaryTextColor
        case .basic:
            self.backgroundColor = ButtonAppearance.basicBackgroundColor
            self.titleLabel?.textColor = ButtonAppearance.basicTextColor
            self.layer.cornerRadius = 10
        case .color:
            self.backgroundColor = ButtonAppearance.whiteBackgroundColor
            self.titleLabel?.textColor = ButtonAppearance.coloredTextColor
        default: return
        }
    }
}
