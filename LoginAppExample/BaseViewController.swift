//
//  BaseViewController.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 09/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class BaseViewController: UIViewController {
    
    let tokenKey = "Token"
    
    // MARK: - Token stored in Keychain methods
    
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
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: "myKey")
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
    
    // MARK: - Progress HUD methods
    
    func showErrorHUD(with msg: String?) {
        if let msg = msg {
            SVProgressHUD.showError(withStatus: msg)
        } else {
            SVProgressHUD.showError(withStatus: "")
        }
    }
    
    func showSuccessHUD(with msg: String?) {
        if let msg = msg {
            SVProgressHUD.showSuccess(withStatus: msg)
        } else {
            SVProgressHUD.showSuccess(withStatus: "")
        }
    }
    
    func showHUD() {
        SVProgressHUD.show()
    }
    
    func dismissHUD() {
        SVProgressHUD.dismiss()
    }
    
    func showInfoHud(with msg: String) {
        SVProgressHUD.showInfo(withStatus: msg)
    }
}
