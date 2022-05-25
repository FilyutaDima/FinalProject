//
//  UISegmentedControlExt.swift
//  FinalProject
//
//  Created by Dmitry on 19.05.22.
//

import UIKit
 
extension UISegmentedControl {
    
    func setLightTheme() {
        self.selectedSegmentTintColor = SegmentedControlAppearance.selectedSegmentTintColor
        self.tintColor = SegmentedControlAppearance.tintColor
        self.backgroundColor = SegmentedControlAppearance.backgroundColor
        self.setTitleTextAttributes([.foregroundColor: SegmentedControlAppearance.selectedTextColor], for: .selected)
        self.setTitleTextAttributes([.foregroundColor: SegmentedControlAppearance.normalTextColor], for: .normal)
        self.layer.cornerRadius = 10
    }
}
