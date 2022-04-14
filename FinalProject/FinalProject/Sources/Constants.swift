//
//  Constants.swift
//  FinalProject
//
//  Created by Dmitry on 7.04.22.
//

import Foundation

enum CountryPhoneCode: String, CaseIterable {
    case by = "+375"
    case ru = "+7"
    case uk = "+380"
    case pl = "+48"
    case jm = "+1876"
    case ca = "+1"
    case de = "+49"
    
    var countryCode: String {
        switch self {
        case .by: return "by"
        case .ru: return "ru"
        case .uk: return "uk"
        case .pl: return "pl"
        case .jm: return "jm"
        case .ca: return "ca"
        case .de: return "de"
        }
    }
    
    var description: String {
        switch self {
        case .by: return "Беларусь +375"
        case .ru: return "Россия +7"
        case .uk: return "Украина +380"
        case .pl: return "Польша +48"
        case .jm: return "Ямайка +1876"
        case .ca: return "Канада +1"
        case .de: return "Германия +49"
        }
    }
}

enum CustomAuthErrorCode: Int {
    case emailAlreadyInUse = 17007
    case invalidEmail = 17008
    case wrongPassword = 17009
    case weakPassword = 17026
    case missingEmail = 17034
    case missingFirstname = 18001
    case missingLastname = 18002
    case confirmPassword = 18003
    case userNotFound = 18004
    
    var description: String {
        switch self {
        case .missingFirstname: return "Введите имя"
        case .missingLastname: return "Введите фамилию"
        case .wrongPassword: return "Пароль недействителен"
        case .missingEmail: return "Введите email"
        case .emailAlreadyInUse: return "Аккаунт с данным email уже существует"
        case .invalidEmail: return "Введите корректный email"
        case .weakPassword: return "Пароль слишком слабый. Введите пароль, который содержит не менее 6 символов"
        case .confirmPassword: return "Пароли не совпадают"
        case .userNotFound: return "Пользователь с введёнными данными не найден"
        }
    }
}

class Constants {
    static let cancel = "Отмена"
    static let apply = "Применить"
    static let selectCountryCode = "Выберите код страны"
    
    static let databaseUserTable = "users"
    
    static let goToMain = "goToMain"
    static let goToDetail = "goToDetail"
}

