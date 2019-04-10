//
//  Convertion.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

//Protocols for convertions of models between Realm Model and Model.

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType
    
    func asRealm() -> RealmType
}

protocol DomainConvertibleType {
    associatedtype DomainType
    
    func asDomain() -> DomainType
}
