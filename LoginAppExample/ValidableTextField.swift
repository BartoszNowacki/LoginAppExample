//
//  ValidableTextField.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit


///Text field with validation functions
class ValidableTextField: UITextField {
   
    var valid: Bool = false
    
    // MARK: - Public methods
    
    /// Checks if field is not empty
    
    func validateIfIsNotEmpty() {
        valid = true
        if let empty = self.text?.isEmpty {
            valid = !empty
        }
    }
    
    /// Checks if String in field is equal to given String
    
    func validateIfTextEqual(to text: String?) {
        valid = self.text == text
    }
}
