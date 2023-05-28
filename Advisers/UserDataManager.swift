//
//  UserDataManager.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()

    private init() {}
    
    enum Keys: String {
        case organizationId = "OpenAI.organizationId"
        case apiKey = "OpenAI.apiKey"
        case model = "OpenAI.model"
        case userName = "User.name"
        case summarizingRoom = "Room.summrizing"
    }

    private let userDefaults = UserDefaults.standard

    var organizationId: String {
        get {
            return userDefaults.string(forKey: Keys.organizationId.rawValue) ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.organizationId.rawValue)
        }
    }

    var apiKey: String {
        get {
            return userDefaults.string(forKey: Keys.apiKey.rawValue) ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.apiKey.rawValue)
        }
    }
    
    var model: String {
        get {
            return userDefaults.string(forKey: Keys.model.rawValue) ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.model.rawValue)
        }
    }
    
    var userName: String {
        get {
            return userDefaults.string(forKey: Keys.userName.rawValue) ?? "Human"
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.userName.rawValue)
        }
    }
}
