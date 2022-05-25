//
//  UIImageExt.swift
//  FinalProject
//
//  Created by Dmitry on 13.05.22.
//

import UIKit

extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
