//
//  ImageViewExt.swift
//  FinalProject
//
//  Created by Dmitry on 15.04.22.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageUsingCacheWithUrlString(urlString: String) {
    
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }).resume() }
}
