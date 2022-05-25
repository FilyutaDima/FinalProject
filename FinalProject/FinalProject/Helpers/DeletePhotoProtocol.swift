//
//  DeletePhotoProtocol.swift
//  FinalProject
//
//  Created by Dmitry on 11.05.22.
//

import Foundation

protocol DeletePhotoDelegate: AnyObject {
    func deletePhoto(at tag: Int)
}
