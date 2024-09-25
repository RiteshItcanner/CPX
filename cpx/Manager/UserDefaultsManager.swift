//
//  UserDefaultsManager.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    
    // Save any Codable object
    func save<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(object)
            userDefaults.set(jsonData, forKey: key)
        } catch {
            print("Failed to encode \(T.self): \(error)")
        }
    }
    
    // Load any Codable object
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let jsonData = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(T.self, from: jsonData)
                return object
            } catch {
                print("Failed to decode \(T.self): \(error)")
            }
        }
        return nil
    }
    
    // Remove object
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

/*
 // Define a custom struct
 struct UserProfile: Codable {
     let username: String
     let email: String
 }

 // Initialize UserDefaultsManager
 let userDefaultsManager = UserDefaultsManager()

 // Save a UserProfile object
 let userProfile = UserProfile(username: "JohnDoe", email: "john@example.com")
 userDefaultsManager.save(userProfile, forKey: "userProfile")

 // Load a UserProfile object
 if let loadedProfile: UserProfile = userDefaultsManager.load(UserProfile.self, forKey: "userProfile") {
     print("Username: \(loadedProfile.username), Email: \(loadedProfile.email)")
 }

 */
