//
//  RealmBaseModel.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import RealmSwift

class UserData: Object {
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
