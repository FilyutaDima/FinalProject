//
//  TabViewCell.swift
//  FinalProject
//
//  Created by Dmitry on 18.05.22.
//

import UIKit
import SwiftUI

class TabViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontTitle()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    private func setupFontTitle() {
        titleLabel.font = SystemFont.titleRegular
    }
    
    private func animateTextColor(to color: UIColor) {

        let changeColor = CATransition()
        changeColor.type = CATransitionType.fade
        changeColor.duration = 0.2

        CATransaction.begin()

        self.titleLabel.textColor = color
        self.titleLabel.layer.add(changeColor, forKey: nil)

        CATransaction.commit()
    }
    
    func setSelection() {
        animateTextColor(to: SystemColor.tint)
        indicatorView.isHidden = false
        indicatorView.backgroundColor = SystemColor.tint
        titleLabel.font = SystemFont.titleSemiBold
    }
    
    func resetSelection() {
        animateTextColor(to: SystemColor.darkGray)
        indicatorView.isHidden = true
        titleLabel.font = SystemFont.titleRegular
    }
    
    func configure(with pageIndex: Int) {
    
        titleLabel.text = Section.allCases[pageIndex].rawValue
    }

}
