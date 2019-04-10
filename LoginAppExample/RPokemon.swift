//
//  RPokemon.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import UIKit

class RPokemon: PokeData {
    @objc dynamic var pokeID: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var name: String = ""
    
    
    convenience init(id: Int, weight: Int, type: String, photo: String, name: String) {
        self.init()
        self.pokeID = id
        self.weight = weight
        self.type = type
        self.photo = photo
        self.name = name
    }
}

extension RPokemon: DomainConvertibleType {
    
    ///Convertion of Realm object RToken to Token
    func asDomain() -> Pokemon {
        return Pokemon(id: self.pokeID, weight: self.weight, type: self.type, photo: self.photo, name: self.name)
    }
}


///Convertion of Token to Realm object RToken

extension Pokemon: RealmRepresentable {
    func asRealm() -> RPokemon {
        return RPokemon.build { object in
            object.pokeID = id
            object.id = id
            object.weight = weight
            object.type = type
            object.photo = photo
            object.name = name
        }
    }
}
