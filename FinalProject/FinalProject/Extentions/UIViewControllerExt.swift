//
//  UIViewControllerExt.swift
//  FinalProject
//
//  Created by Dmitry on 8.04.22.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideViews(_ views: [UIView]) {
        for view in views {
            view.isHidden = true
        }
    }
    
    func insertText(_ text: String?, into label: UILabel, andShow view: UIView) {
        
        guard let text = text,
              !text.trim().isEmpty else {
            view.isHidden = true
            return
        }
        
        label.text = text
        view.isHidden = false
    }
}
