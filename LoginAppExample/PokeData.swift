//
//  PokeData.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 09/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import UIKit
import RealmSwift

class PokeData: Object {
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
