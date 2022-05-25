//
//  AddPetCell.swift
//  FinalProject
//
//  Created by Dmitry on 5.05.22.
//

import UIKit

class AddPetCell: UICollectionViewCell {

    @IBOutlet weak var addPetLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners()
        rootView.backgroundColor = SystemColor.tint
        plusImageView.tintColor = SystemColor.white
        addPetLabel.textColor = SystemColor.white
    }
}
