//
//  ViewController.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

class SignViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: ValidableTextField!
    @IBOutlet weak var passwordTextField: ValidableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.isAvailable(RToken.self) {
            self.performSegue(withIdentifier: "show_detail_controller", sender: nil)
        }
    }
    
    // MARK:- Buttons action
    
    @IBAction func didTapSignIn(_ sender: Any) {
        if dataIsFilled() {
            self.showHUD()
            loginUser(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        showAlertView()
    }
    
    // MARK:- Other functions
    
    /// Api call for login
    
    func loginUser(email: String, password: String) {
        log.info("Register new user")
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
                    UserManager.shared.save(token.asRealm())
                    self.performSegue(withIdentifier: "show_detail_controller", sender: nil)
                    log.info("got token")
                }
                self.dismissHUD()
            }
        } as (APIResponse<Token>) -> Void)
    }
    
    ///Shows AlertView with Register fields.
    
    private func showAlertView() {
        guard let alertVC = UIStoryboard(name: "AlertView", bundle: nil).instantiateViewController(withIdentifier: "AlertViewID") as? AlertViewController else { return }
        alertVC.delegate = self
        present(alertVC, animated: true, completion: nil)
    }
    
    /// This function is going to shake first field, which is not filled. 
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
        return true
    }
    
    /// Checks for which fields are field.
    /// - returns: Bool with information if all fields are valid, and array of invalid fields
    
    fileprivate func validateFields() -> (areValid: Bool, invalidFields: [ValidableTextField]) {
        emailTextField.validateIfIsNotEmpty()
        passwordTextField.validateIfIsNotEmpty()
        
        let  areValid = emailTextField.valid && passwordTextField.valid
        
        let invalidFields: [ValidableTextField] = [emailTextField, passwordTextField].compactMap { field in
            if !(field?.valid)! {
                return field
            } else {
                return nil
            }
        }
        return (areValid: areValid, invalidFields: invalidFields)
    }
}

extension SignViewController: AlertViewDelegate {
    func loggedIn() {
        dismissHUD()
        self.performSegue(withIdentifier: "show_detail_controller", sender: nil)
    }
}
