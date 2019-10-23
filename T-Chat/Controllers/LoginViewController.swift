//
//  ViewController.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 21.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChatFBServices.chakAuth { [weak self] in
            self?.performSegue(withIdentifier: "toUsers", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loginTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text,
            email != "", password != "" else { return }
        
        ChatFBServices().signIn(email: email, password: password)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .automatic
        present(registerVC, animated: true, completion: nil)
    }
}

