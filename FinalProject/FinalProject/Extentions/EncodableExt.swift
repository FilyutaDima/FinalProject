//
//  EncodableExt.swift
//  FinalProject
//
//  Created by Dmitry on 3.04.22.
//

import Foundation

extension Encodable {
  var toDictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
  }
}
