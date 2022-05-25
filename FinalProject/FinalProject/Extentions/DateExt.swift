//
//  DateExt.swift
//  FinalProject
//
//  Created by Dmitry on 30.04.22.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
