//
//  ViewController.swift
//  Instagram Firebase
//
//  Created by max on 31.03.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Email"
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
        userNameTextField.text?.count ?? 0 > 0 &&
        passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 236)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    let userNameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Username"
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Password"
        text.isSecureTextEntry = true
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignIn() {
        
        guard let email = emailTextField.text, email.count > 0, email.contains("@") else { return }
        guard let userName = userNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        

        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print ("Failed to create user: \(error)")
            }
            
            print ("succesfully created user: \(user?.user.uid ?? "")")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         
        setupInputField()

        
        
    }
    
    fileprivate func setupInputField() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       userNameTextField,
                                                       passwordTextField,
                                                       signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }


}

