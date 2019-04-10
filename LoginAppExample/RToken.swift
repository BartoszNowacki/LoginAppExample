//
//  RToken.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RealmSwift

class RToken: UserData {
    @objc dynamic var token: String?
    
    convenience init(token: String) {
        self.init()
        self.token = token
    }
}

extension RToken: DomainConvertibleType {
    
    ///Convertion of Realm object RToken to Token
    func asDomain() -> Token {
        return Token(token: self.token!)
    }
}


    ///Convertion of Token to Realm object RToken

extension Token: RealmRepresentable {
    func asRealm() -> RToken {
        return RToken.build { object in
            object.token = token
        }
    }
}
