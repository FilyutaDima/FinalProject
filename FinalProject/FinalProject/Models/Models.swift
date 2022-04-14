//
//  Pet.swift
//  FinalProject
//
//  Created by Dmitry on 24.03.22.
//

import Foundation
import UIKit

enum Gender: Codable {
    case male
    case female
}

enum Section: Codable {
    case lost
    case found
    case houseSearch
}

struct Notice: Codable {
    let petID: String
    let user: User
    var date = Date()
    let address: Address
    let comments: [Comment]
    let section: Section
}

struct Pet: Codable {
    let id: String
    let name: String
    let breed: String
    let photos: [Image]
    let gender: Gender
    let info: String?
    let specialSigns: String?
}

struct Image: Codable {
    let url: String
    let uid: String
}

struct Address: Codable {
    let latitude: String
    let longitude: String
    let street: String
    let house: Int
    let sity: String
}

struct Comment: Codable {
    let user: User
    let title: String?
    let text: String
}

struct User: Codable {
    var firstname: String
    var lastname: String
    var phoneNumber: String
    var email: String
    let petsID: [String]?
}
