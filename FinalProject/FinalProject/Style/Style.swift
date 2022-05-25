//
//  Colors.swift
//  FinalProject
//
//  Created by Dmitry on 19.05.22.
//

import UIKit

enum ViewStyle {
    case basic
    case auxiliary
    case color
    case white
}

enum FontStyle {
    case titleRegular
    case titleSemiBold
    case bodyRegular
    case bodySemiBold
    case headerRegular
    case headerSemiBold
    case littleBodySemiBold
    case littleBodyRegular
}

enum SystemFont {
    static let headerSemiBold = UIFont(name: "Rubik-SemiBold", size: 25)
    static let headerRegular = UIFont(name: "Rubik-Regular", size: 25)
    static let titleSemiBold = UIFont(name: "Rubik-SemiBold", size: 19)
    static let titleRegular = UIFont(name: "Rubik-Regular", size: 19)
    static let bodySemiBold = UIFont(name: "Rubik-SemiBold", size: 16)
    static let bodyRegular = UIFont(name: "Rubik-Regular", size: 16)
    static let littleBodySemiBold = UIFont(name: "Rubik-SemiBold", size: 14)
    static let littleBodyRegular = UIFont(name: "Rubik-Regular", size: 14)
}

enum ColorStyle {
    case white
    case black
    case lightGray
    case darkGray
    case lightOrange
    case darkOrange
    case tint
}

enum SystemColor {
    static let white = UIColor.white
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let lightGray = #colorLiteral(red: 0.917666316, green: 0.9176353216, blue: 0.9257736802, alpha: 1)
    static let darkGray = #colorLiteral(red: 0.5960699916, green: 0.5921155214, blue: 0.6205770373, alpha: 1)
    static let lightOrange = #colorLiteral(red: 0.9987308383, green: 0.9648659193, blue: 0.9049871031, alpha: 1)
    static let darkOrange = #colorLiteral(red: 0.842566371, green: 0.5727981925, blue: 0.4210541248, alpha: 1)
    static let tint = #colorLiteral(red: 0.8875657916, green: 0.4042612314, blue: 0.2477021813, alpha: 1)
}

enum ButtonAppearance {
    static let basicBackgroundColor = SystemColor.tint
    static let auxiliaryBackgroundColor = SystemColor.lightGray
    static let basicTextColor = SystemColor.white
    static let auxiliaryTextColor = SystemColor.tint
    static let coloredTextColor = SystemColor.tint
    static let whiteBackgroundColor = SystemColor.white
}

enum TextFieldAppearance {
    static let placeholderColor = SystemColor.darkGray
    static let backgroundColor = SystemColor.white
    static let textColor = SystemColor.black
    static let borderColor = SystemColor.lightGray
}

enum LabelAppearance {
    static let textColorBlack = SystemColor.black
    static let textColorOrange = SystemColor.tint
    static let backgroundColor = SystemColor.white
    static let placeholderColor = SystemColor.darkGray
    static let textColorWhite = SystemColor.white
}

enum ViewAppearance {
    static let backgroundColor = SystemColor.white
}

enum SegmentedControlAppearance {
    static let selectedSegmentTintColor = SystemColor.tint
    static let tintColor = SystemColor.darkGray
    static let selectedTextColor = SystemColor.white
    static let normalTextColor = SystemColor.tint
    static let backgroundColor = SystemColor.white
}

enum ImageViewAppearance {
    static let tintColor = SystemColor.tint
}

enum SwitchApperearance {
    static let onTintColor = SystemColor.tint
    static let tintColor = SystemColor.white
}
