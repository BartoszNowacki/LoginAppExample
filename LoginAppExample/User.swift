//
//  User.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct User: Codable, OutputModel {

    let id: Int
    let name: String
    let email: String
    
}
