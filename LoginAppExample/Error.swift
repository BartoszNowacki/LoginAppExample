//
//  Error.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct Error: Codable, OutputModel  {
    
    let error: Bool
    let reason: String
    
}
