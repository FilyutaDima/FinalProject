//
//  StringExt.swift
//  FinalProject
//
//  Created by Dmitry on 11.04.22.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
