//
//  GridItemCell.swift
//  FinalProject
//
//  Created by Dmitry on 13.05.22.
//

import UIKit

class GridItemCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setLightTheme()
        startAnimatingIndicatorView()
    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet weak var infoView: UIVisualEffectView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with post: Entry) {
        
        addressLabel.text = post.address.addressString
        dateLabel.text = post.date.convertToString()
        
        guard let photoUrl = post.arrayPhotoUrl.first else { return }
        
        fetchPetPhoto(with: photoUrl)
        
    }
    
    private func setLightTheme() {
        addressLabel.setLightTheme(viewStyle: .white, fontStyle: .littleBodyRegular)
        dateLabel.setLightTheme(viewStyle: .white, fontStyle: .littleBodyRegular)
        backgroundImageView.backgroundColor = SystemColor.lightOrange
        indicatorView.color = SystemColor.tint
    }
    
    private func fetchPetPhoto(with photoUrl: String) {
        
        NetworkManager.downloadPhoto(with: photoUrl) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(let photo):
                self?.stopAnimatingIndicatorView()
                self?.configureImageViews(with: photo)
            }
        }
    }
    
    private func configureImageViews(with photo: UIImage) {
        photoImageView.image = photo
        backgroundImageView.image = photo
    }
    
    private func startAnimatingIndicatorView() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        infoView.isHidden = true
    }
    
    private func stopAnimatingIndicatorView() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        infoView.isHidden = false
    }

}
