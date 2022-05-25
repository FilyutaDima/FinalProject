//
//  GalleryPageVC.swift
//  FinalProject
//
//  Created by Dmitry on 3.05.22.
//

import UIKit

class GalleryPageVC: BasePageVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePages()
        self.view.roundCorners()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    var arrayPhotoUrl: [String]?
    
    func configurePages() {
        
        guard let arrayPhotoUrl = arrayPhotoUrl else { return }
        var arrayVC = [UIViewController]()
        
        for (index, url) in arrayPhotoUrl.enumerated() {
            
            let galleryItemVC = storyboard?.instantiateViewController(withIdentifier: "GalleryItemVC") as! GalleryItemVC
            
            galleryItemVC.view.tag = index + 1
            
            galleryItemVC.fetchPetPhoto(with: url)
            
            arrayVC.append(galleryItemVC)
        }
        
        self.setViewControllers(arrayVC) {}
    }
}
