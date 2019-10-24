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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        registerKeyboardNotification()
        //scrollView.contentOffset = CGPoint(x: 0, y: 123)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeKeyboardNotification()
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardSize = keyboardFrame.cgRectValue
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: view.bounds.size.height - keyboardSize.height)
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: view.bounds.size.height)
        scrollView.contentOffset = CGPoint.zero
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

