//
//  Pet.swift
//  FinalProject
//
//  Created by Dmitry on 24.03.22.
//

import Foundation
import UIKit

protocol Entry {}

struct Pet: Entry, Codable {
    let uid: String
    let type: String
    let name: String?
    let breed: String?
    let gender: String
    let age: String?
    let specialSigns: String?
    let history: String?
    let character: String?
    let arrayPhotoUrl: [String]
    let petOwnerContact: Contact?
    var status: String = PetStatus.normal
}

struct Post: Entry, Codable {
    let uid: String
    let pet: Pet
    var date = Date()
    let address: Address
    let contact: Contact
    let isStolen: Bool
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

struct User: Codable {
    let uid: String
    let contact: Contact
    var myPets: [String: Pet]?
    var myPosts: [String: Post]?
}
