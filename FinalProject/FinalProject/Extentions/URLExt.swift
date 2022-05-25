//
//  URLExt.swift
//  FinalProject
//
//  Created by Dmitry on 16.05.22.
//

import UIKit

extension URL {
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }

    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}
