//
//  ViewController.swift
//  Instagram Firebase
//
//  Created by max on 31.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Email"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let userNameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Username"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Password"
        text.isSecureTextEntry = true
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor(white: 0, alpha: 0.03)
        text.borderStyle = .roundedRect
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 201/255, blue: 244/255, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
         
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
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }


}

