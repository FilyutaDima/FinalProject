//
//  Constants.swift
//  FinalProject
//
//  Created by Dmitry on 7.04.22.
//

import UIKit

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
    case missingUsername = 18001
    case confirmPassword = 18002
    case userNotFound = 18003
    
    var description: String {
        switch self {
        case .missingUsername: return "Введите имя"
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

enum Gender: String, CaseIterable {
    case unknown = "unknown"
    case male = "male"
    case female = "female"
    
    var description: String {
        switch self {
        case .unknown: return "Неизвестен"
        case .male: return "Мальчик"
        case .female: return "Девочка"
        }
    }
}

enum AnimalType: String, CaseIterable {
    case dog = "dog"
    case cat = "cat"
    
    var silhouette: UIImage {
        switch self {
        case .dog: return #imageLiteral(resourceName: "dog_icon.png")
        case .cat: return #imageLiteral(resourceName: "cat_icon.png")
        }
    }
}


//enum Section: String, CaseIterable {
//    case lost = "Пропали"
//    case notice = "Замечены"
//    case houseSearch = "Ищут дом"
//}

enum Section: CaseIterable {
    case lost
    case notice
    case houseSearch
    
    var title: String {
        switch self {
        case .lost: return "Пропали"
        case .notice: return "Замечены"
        case .houseSearch: return "Ищут дом"
        }
    }
}

enum Status: CaseIterable {
    case neutral
    case notice
    case houseSearch
    case stolen
    case lost
    
    var title: String {
        switch self {
        case .neutral: return "Нейтральный"
        case .notice: return "Замечен"
        case .houseSearch: return "Ищет дом"
        case .stolen: return "Украден"
        case .lost: return "Утерян"
        }
    }
    
    var placeDescription: String {
        switch self {
        case .lost: return "Утерян"
        case .stolen: return "Украден"
        case .notice: return "Обнаружен"
        case .houseSearch: return "Место жительства"
        case .neutral: return "Место жительства"
        }
    }
}

enum UserAction {
    case createNewPost
    case addNewMyPet
}

enum PlaceDescription {
    static let stolen = "Украден"
    static let lost = "Утерян"
    static let notice = "Обнаружен"
}

enum Segue: CaseIterable {
    static let goToGalleryPageVC = "goToGalleryPageVC"
    static let goToHomePageVC = "goToHomePageVC"
}

enum DBCategory {
    static let users = "users"
    static let pets = "pets"
    static let posts = "posts"
    static let photos = "photos"
    static let myPetsId = "myPetsId"
    static let myPostsId = "myPostsId"
    static let petStatus = "status"
    static let contact = "contact"
    static let name = "name"
    static let phoneNumber = "phoneNumber"
}

enum ReuseIdentifierCell {
    static let defaultId = "Cell"
    static let addPet = "AddPetCell"
    static let addPost = "AddPostCell"
    static let myPet = "MyPetCell"
    static let gridItem = "GridItemCell"
}

enum PhotoAction {
    static let openCamera = "Открыть камеру"
    static let openLibrary = "Открыть библиотеку"
}

enum Constants {
    static let cancel = "Отмена"
    static let apply = "Применить"
    static let selectCountryCode = "Выберите код страны"
    static let addPet = "Добавить питомца"
    static let noName = "Без имени"
    static let noBreed = "Без породы"
    static let noAge = "Неизвестен"
    static let downloadError = "Ошибка загрузки"
    static let downloadErrorDescription = "В ходе загрузки данных возникла ошибка"
    static let repeatDownload = "Повторить загрузку"
    static let headerUrlTel = "tel://"
    static let schemeURL = "Petikus"
    static let hostURL = "petinfo"
}

enum NavigationTitle {
    static let registration = "Регистрация"
    static let petStolen = "Украден питомец"
    static let petLost = "Утерян питомец"
    static let petNotice = "Обнаружен питомец"
    static let petHouseSearch = "Питомец ищет дом"
    static let myPet = "Мой питомец"
    static let infoAboutPet = "Информация о питомце"
    static let myPets = "Мои питомцы"
    static let myPosts = "Мои посты"
    static let createPost = "Создание поста"
    static let createPet = "Создание нового питомца"
    static let selectCategory = "Выберите категорию"
    static let settings = "Настройки"
    static let petQRCode = "QR-код питомца"
    static let myData = "Мои данные"
}

enum Menu: String {
    case petQRCode = "QR-код питомца"
    case deletePet = "Удалить"
    case reportMissing = "Заявить о пропаже"
    case changeStatus = "Изменить статус"
}

enum Alarm {
    case lost
    case stolen
    
    var title: String {
        switch self {
        case .lost: return "Питомец утерян"
        case .stolen: return "Питомец украден"
        }
    }
    
    var message: String {
        switch self {
        case .lost: return "Помогите утерянному питомцу найти дом. Свяжитесь с хозяином питомца."
        case .stolen: return "Помогите украденному питомцу найти дом. Свяжитесь с хозяином питомца."
        }
    }
}

enum InfoAboutQRCode {
    static let message = """
    Используйте QR-код как адресник на шее у питомца. Медальон с нанесённым QR-кодом необходим для быстрой связи с хозяином в случае потери. Подробная информация о питомце и контактные данные хозяина покажутся при сканировании QR-кода.
    """
    static let title = "Для чего необходим QR-код?"
}

