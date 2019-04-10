//
//  AlertViewController.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: class {
    func loggedIn()
}

class AlertViewController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameField: ValidableTextField!
    @IBOutlet weak var emailField: ValidableTextField!
    @IBOutlet weak var passField: ValidableTextField!
    @IBOutlet weak var repassField: ValidableTextField!
    @IBOutlet weak var background: UIView!
    
    weak var delegate: AlertViewDelegate?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        setup()
    }

    // MARK: - Setup

    private func setup() {
        background.layer.cornerRadius = 11
        background.addShadow(offset: 12, color: .black, radius: 22, alpha: 0.22)

        registerButton.setup(title: NSLocalizedString("Login: Register", comment: "").uppercase)
        registerButton.addShadow(offset: 5, color: .white, radius: 10)
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
        
        cancelButton.setup(title: NSLocalizedString("Login: Cancel", comment: "").uppercase)
        cancelButton.addShadow(offset: 3, color: .white, radius: 5)
        cancelButton.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)
    }

    // MARK: - Tap Button Actions
    
    @objc func registerTap() {
        if dataIsFilled() {
            showHUD()
            registerUser(profile: generateProfile())
        }
    }

    @objc func cancelTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API Calls
    
    func registerUser(profile: Profile) {
        log.info("Register new user")
        APIClient.shared.makeCall(type: APIType.register, for: profile, complete: { response in
            switch response.type {
            case .failure, .serverError:
                log.error("Something bad happend in register")
                if let error = response.content.first as! Error? {
                    self.showErrorHUD(with: error.reason)
                }
            case .success:
                if (response.content.first as! User?) != nil {
                    self.loginUser(email: profile.email, password: profile.password)
                } else {
                    self.dismissHUD()
                }
            }
        } as (APIResponse<User>) -> Void)
    }
    
    func loginUser(email: String, password: String) {
        log.info("Login user with \(email) and \(password)")
        let login = Login(email: email, password: password)
        APIClient.shared.makeCall(type: APIType.login, for: login, complete: { response in
            switch response.type {
            case .failure, .serverError:
                log.error("Something bad happend in login")
                if let error = response.content.first as! Error? {
                    self.showErrorHUD(with: error.reason)
                }
            case .success:
                if let token = response.content.first as! Token? {
                    self.saveToken(token.token)
                    self.dismissHUD()
                    self.dismiss(animated: false, completion: nil)
                    self.delegate?.loggedIn()
                }
            }
        } as (APIResponse<Token>) -> Void)
    }
    
    
     // MARK: - Other functions
    
     /// Generate User Object
    
    fileprivate func generateProfile() -> Profile {
        return Profile(name: nameField.text!,
            email: emailField.text!,
            password: passField.text!)
    }
    
    /// This function is going to shake first field, which is not filled. If every field is filled, then it checks for passwords if they are the same (if not, error will show)
    /// - returns: Bool with information, if fields are filled correctly.
    
    private func dataIsFilled() -> Bool {
        let fields = validateFields()
        guard fields.areValid else {
            log.warning("Not all field are filed")
            resignFirstResponder()
            if let firstInvalidField = fields.invalidFields.first {
                firstInvalidField.shake()
            }
            return false
        }
        repassField.validateIfTextEqual(to: passField.text)
        guard repassField.valid else {
            log.info("Passwords are not the same")
            showErrorHUD(with: NSLocalizedString("Login: Passwords match", comment: ""))
            return false
        }
        return true
    }
    
    /// Checks for which fields are field.
    /// - returns: Bool with information if all fields are valid, and array of invalid fields
    
    fileprivate func validateFields() -> (areValid: Bool, invalidFields: [ValidableTextField]) {
        nameField.validateIfIsNotEmpty()
        emailField.validateIfIsNotEmpty()
        passField.validateIfIsNotEmpty()
        repassField.validateIfIsNotEmpty()
        
        let  areValid = nameField.valid && emailField.valid && passField.valid && repassField.valid
        
        let invalidFields: [ValidableTextField] = [nameField, emailField, passField, repassField].compactMap { field in
            if !(field?.valid)! {
                return field
            } else {
                return nil
            }
        }
        return (areValid: areValid, invalidFields: invalidFields)
    }
    
}
