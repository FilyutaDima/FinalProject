//
//  UserSingleton.swift
//  FinalProject
//
//  Created by Dmitry on 6.05.22.
//

import Foundation

class UserSingleton {
    
    private static var userSingleton: UserSingleton!
    private var userId: String!

    static func user() -> UserSingleton {
        guard let instance = userSingleton else {
            userSingleton = UserSingleton()
            return userSingleton
        }
        return instance
    }
    
    func setId(_ userId: String) {
        self.userId = userId
    }
    
    func getId() -> String {
        return self.userId
    }
    
    private init() {}
}
