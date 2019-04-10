//
//  Pokemon.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct Pokemon: Codable, OutputModel {
    
    let id: Int
    let weight: Int
    let type: String
    let photo: String
    let name: String

}
