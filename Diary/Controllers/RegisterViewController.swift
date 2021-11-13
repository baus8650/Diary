//
//  RegisterViewController.swift
//  Diary
//
//  Created by Tim Bausch on 10/24/21.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {
    
    //MARK: - Local Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var passWordWarning: UILabel!
    @IBOutlet private weak var registrationWarning: UITextView!
    
    //MARK: - IBActions
    
    @IBAction private func registerButtonPressed(_ sender: UIButton) {
            if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
                if password == confirmPassword {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            self.registrationWarning.text = e.localizedDescription + " Please choose a different email address or login with your account."
                        } else {
                            self.handle = Auth.auth().addStateDidChangeListener { _, user in
                                guard let user = user else { return }
                                print(user)
                            }
                            self.performSegue(withIdentifier: "RegisterToDiary", sender: self)
                        }
                    }
                } else {
                    registrationWarning.text = "Passwords do not match."
                }
            }
            
        }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
}

//MARK: - Extensions

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}
