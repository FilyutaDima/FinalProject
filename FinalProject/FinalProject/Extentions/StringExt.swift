//
//  StringExt.swift
//  FinalProject
//
//  Created by Dmitry on 11.04.22.
//

import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func encode<T: Codable>(object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(object) else { return nil }
        return String(data: data, encoding: .utf8)!
    }
    
    func decode<T: Codable>(to type: T.Type) -> T? {
        let jsonData = self.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: jsonData)
    }
    
    func qrImage(using color: UIColor) -> CIImage? {
        return qrImage?.tinted(using: color)
    }

    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        let qrData = self.data(using: .utf8)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        let qrTransform = CGAffineTransform(scaleX: 300, y: 300)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
}
