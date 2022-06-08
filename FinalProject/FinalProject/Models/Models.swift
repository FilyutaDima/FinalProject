//
//  Pet.swift
//  FinalProject
//
//  Created by Dmitry on 24.03.22.
//

import Foundation
import UIKit

struct User: Codable {
    let uid: String
    let contact: Contact
    var myPetsId: [String: String]?
    var myPostsId: [String: String]?
}

struct Entry: Codable {
    let uid: String
    let ownerId: String?
    let type: String
    let name: String?
    let breed: String?
    let gender: String
    let age: String?
    let specialSigns: String?
    let history: String?
    let character: String?
    let arrayPhotoUrl: [String]
    let contact: Contact
    var status: String = Status.neutral.title
    var date = Date()
    let address: Address
}

struct Address: Codable {
    let latitude: Double
    let longitude: Double
    let addressString: String 
}

struct Contact: Codable {
    let name: String
    let phoneNumber: PhoneNumber
}

struct PhoneNumber: Codable {
    let code: String
    let number: String
}
