//
//  LoginViewController.swift
//  Diary
//
//  Created by Tim Bausch on 10/24/21.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    //MARK: - Local Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginErrorLabel: UITextView!
    
    //MARK: - IBAction
    
    @IBAction private func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.loginErrorLabel.text = "Incorrect email or password."
                    print(e)
                } else {
                    self.handle = Auth.auth().addStateDidChangeListener { _, user in
                        guard let user = user else { return }
                        print(user)
                    }
                    self.performSegue(withIdentifier: "LoginToDiary", sender: self)
                }
            }
        }
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
}

//MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
