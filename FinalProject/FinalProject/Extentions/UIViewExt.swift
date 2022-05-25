//
//  UIViewExt.swift
//  FinalProject
//
//  Created by Dmitry on 18.04.22.
//

import Foundation
import UIKit
 
extension UIView {
    
    func fadeOut(_ duration: TimeInterval) {
      UIView.animate(withDuration: duration) {
        self.alpha = 0.0
      }
    }
    
    func fadeIn(_ duration: TimeInterval) {
      UIView.animate(withDuration: duration) {
        self.alpha = 1.0
      }
    }
    
    func roundCorners(corners: UIRectCorner,
                      radius: CGFloat = 20) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners(radius: CGFloat = 20) {
        layer.cornerRadius = radius
    }
    
    func setBackgroundColor() {
        self.backgroundColor = SystemColor.white
    }
    
    func setSeparatorStyle() {
        self.backgroundColor = SystemColor.lightGray
    }
}
