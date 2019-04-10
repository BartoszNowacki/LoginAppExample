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
    
    // MARK: - Public methods
    
    /// Checks if field is not empty
    
    func isNotEmpty() -> Bool {
        if (self.text?.isEmpty) != nil && (self.text!.isEmpty) == true {
           return false
        } else {
            return true
        }
    }
    
    /// Checks if String in field is equal to given String
    
    func textIsEqual(to text: String?) -> Bool {
        return (isNotEmpty() && self.text == text)
    }
}
