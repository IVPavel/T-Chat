//
//  RegisterViewController.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 21.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user")
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let nameTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 26)
        text.borderStyle = .roundedRect
        text.placeholder = "Name"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let emailTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 26)
        text.borderStyle = .roundedRect
        text.placeholder = "Email"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 26)
        text.borderStyle = .roundedRect
        text.isSecureTextEntry = true
        text.placeholder = "Password"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4797514677, blue: 0.9984372258, alpha: 1)
        button.addTarget(self, action: #selector(registerButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc fileprivate func registerButton(sender: UIButton!) {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text,
            name != "", email != "", password != "" else { return print("Not all fields are completed.")}
        ChatFBServices().createUser(email: email, password: password, username: name) { [weak self] (auth, error)  in
            switch auth {
            case .some(_):
                self?.dismiss(animated: true, completion: nil)
            case .none:
                print(error!)
            }
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(image)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        view.addSubview(stackView)
        view.addSubview(registerButton)
        
        //Setup constraint
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //other settings
        view.backgroundColor = .white
        image.layer.cornerRadius = 75
        registerButton.layer.cornerRadius = 12
    }
}
