//
//  MyPetCell.swift
//  FinalProject
//
//  Created by Dmitry on 4.05.22.
//

import UIKit

class MyPetCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setLightTheme()
    }
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var petStatusView: UIView!
    @IBOutlet weak var petStatusLabel: UILabel!
    @IBOutlet weak var petStatusTitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    
    weak var delegate: MyPetMenuActionDelegare?
    
    func setup(with pet: Pet) {
        self.configureCell(with: pet)
        self.setupMenu(with: pet)
        let arrayPhotoUrl = pet.arrayPhotoUrl
        guard let photoUrl = arrayPhotoUrl.first else { return }
        self.fetchPetPhoto(with: photoUrl)
    }
    
    private func setLightTheme() {
        rootView.backgroundColor = #colorLiteral(red: 0.9725491405, green: 0.9725490212, blue: 0.9725490212, alpha: 1)
        petNameLabel.setLightTheme(viewStyle: .basic, fontStyle: .titleSemiBold)
        petBreedLabel.setLightTheme(viewStyle: .auxiliary, fontStyle: .bodyRegular)
        petStatusView.backgroundColor = SystemColor.lightOrange
        petStatusLabel.setLightTheme(viewStyle: .color, fontStyle: .bodySemiBold)
        petStatusTitleLabel.setLightTheme(viewStyle: .auxiliary, fontStyle: .bodyRegular)
        activityIndicator.color = SystemColor.tint
        backgroundImageView.backgroundColor = SystemColor.lightOrange
    }
    
    private func setupMenu(with pet: Pet) {
        
        guard let delegate = delegate else { return }

        let petQRCodeAction = UIAction(title: Menu.petQRCode.rawValue) { _ in
            delegate.showPetQRCode(pet)
        }
        
        let deletePetAction = UIAction(title: Menu.deletePet.rawValue) { [weak self] _ in
            guard let self = self else { return }
            delegate.deletePet(at: self.tag)
        }
        let reportMissingAction = UIAction(title: Menu.reportMissing.rawValue) { _ in
            delegate.reportMissing(pet)
        }
        
        let setNormalStatusAction = UIAction(title: PetStatus.normal) { [weak self] _ in
            guard let self = self else { return }
            delegate.changePetStatus(pet, PetStatus.normal, self.tag)
        }
        let setStolenStatusAction = UIAction(title: PetStatus.stolen) { _ in
            delegate.changePetStatus(pet, PetStatus.stolen, self.tag)
        }
        
        let setLostStatusAction = UIAction(title: PetStatus.lost) { _ in
            delegate.changePetStatus(pet, PetStatus.lost, self.tag)
        }
        
        let changeStatusMenu = UIMenu(title: "Изменить статус питомца", children: [setNormalStatusAction, setLostStatusAction, setStolenStatusAction])
        
        
        let menu = UIMenu(title: "Настройки", children: [petQRCodeAction, changeStatusMenu, reportMissingAction, deletePetAction])
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        
    }
    
    private func configureCell(with pet: Pet) {
        
        petNameLabel.text = pet.name
        petStatusLabel.text = pet.status
        petBreedLabel.text = pet.breed
    }
    
    private func fetchPetPhoto(with photoUrl: String) {
        onStartDownloading()
        
        NetworkManager.downloadPhoto(with: photoUrl) { [weak self] result in
            
            switch result {
            case .failure(let error):
                print("Function: \(#function), line: \(#line), error: \(error.localizedDescription)")
            case .success(let photo):
                self?.onStopDownloading()
                self?.configureImageViews(with: photo)
            }
        }
    }
    
    private func configureImageViews(with photo: UIImage) {
        backgroundImageView.image = photo
        photoImageView.image = photo
    }
    
    private func onStartDownloading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func onStopDownloading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
