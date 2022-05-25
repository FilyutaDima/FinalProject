//
//  PhotoViewCell.swift
//  FinalProject
//
//  Created by Dmitry on 28.04.22.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundCorners()
        
        setupBackgroundImageView()
        setupBackgroundBlurView()
        setupPhotoImageView()
        setupDeleteButton()
    }

    weak var delegate: DeletePhotoDelegate?
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        return view
    }()

    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    let backgroundBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    private func setupBackgroundImageView() {
        self.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupBackgroundBlurView() {
        self.addSubview(backgroundBlurView)
        backgroundBlurView.effect = UIBlurEffect(style: .regular)
        backgroundBlurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundBlurView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundBlurView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundBlurView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupPhotoImageView() {
        self.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupDeleteButton() {
        self.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletePhotoAction)))
    }
    
    func configure(with image: UIImage) {
        backgroundImageView.image = image
        photoImageView.image = image
    }
    
    @objc private func deletePhotoAction() {
        guard let delegate = delegate else { return }
        delegate.deletePhoto(at: tag)
    }
}
