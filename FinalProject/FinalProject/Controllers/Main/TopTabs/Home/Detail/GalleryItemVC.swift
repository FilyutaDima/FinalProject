//
//  GalleryItemVC.swift
//  FinalProject
//
//  Created by Dmitry on 3.05.22.
//

import UIKit

class GalleryItemVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimatingIndicatorView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        showNavigationBar(animated: false, translucent: true)
//    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    private func configureImageViews(with photo: UIImage) {
        
        photoImageView.image = photo
        backgroundImageView.image = photo
    }
    
    func fetchPetPhoto(with photoUrl: String) {
       
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
    
    private func startAnimatingIndicatorView() {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
    }
    
    private func stopAnimatingIndicatorView() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }

}
