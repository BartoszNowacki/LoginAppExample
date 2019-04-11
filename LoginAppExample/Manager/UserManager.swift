//
//  UserManager.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 10/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class UserManager {
    static let shared: UserManager = UserManager()
    let tokenKey = "Token"
    
    func saveToken(_ token: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: tokenKey)
        log.info("Save was successful: \(saveSuccessful)")
    }
    
    func getToken() -> String {
        let token = KeychainWrapper.standard.string(forKey: tokenKey)
        if token != nil {
            return KeychainWrapper.standard.string(forKey: tokenKey)!
        } else {
            fatalError()
        }
    }
    
    func removeUserData() {
        PokeManager.shared.deleteAll()
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: tokenKey)
        log.info("Token was deleted: \(removeSuccessful)")
    }
    
    func isUserLogged() -> Bool {
        let token = KeychainWrapper.standard.string(forKey: tokenKey)
        if token != nil {
            return true
        } else {
            return false
        }
    }
    
}
