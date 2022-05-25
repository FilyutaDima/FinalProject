//
//  UISwitchExt.swift
//  FinalProject
//
//  Created by Dmitry on 20.05.22.
//

import UIKit

extension UISwitch {
    
    func setLightTheme() {
        self.tintColor = SwitchApperearance.tintColor
        self.onTintColor = SwitchApperearance.onTintColor
    }
}
