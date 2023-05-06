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

    private let userDefaults = UserDefaults.standard

    var organizationId: String {
        get {
            return userDefaults.string(forKey: "OpenAI.organizationId") ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: "OpenAI.organizationId")
        }
    }

    var apiKey: String {
        get {
            return userDefaults.string(forKey: "OpenAI.apiKey") ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: "OpenAI.apiKey")
        }
    }
    
    var model: String {
        get {
            return userDefaults.string(forKey: "OpenAI.model") ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: "OpenAI.model")
        }
    }
}
