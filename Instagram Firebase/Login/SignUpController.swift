//
//  ViewController.swift
//  Instagram Firebase
//
//  Created by max on 31.03.2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.gray.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignIn() {
        
        guard let email = emailTextField.text, email.count > 0, email.contains("@") else { return }
        guard let userName = userNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        

        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print ("Failed to create user: \(error)")
            }
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let imageData = image.pngData() else { return }
            
            let storage = Storage.storage().reference()
            
            let fileName = NSUUID().uuidString
            
            print ("Starting upload")
            
            storage.child("profile_images").child(fileName).putData(imageData, metadata: nil) { _, error in
                guard error == nil else {
                    print ("Failed to upload")
                    return
                }
                
                print ("Downloading url")
                storage.child("profile_images").child(fileName).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    print ("Success in download")
                    let urlString = url.absoluteString
                    print ("Download url: \(urlString)")
                    
                    print ("succesfully created user: \(user?.user.uid ?? "")")

                    guard let uid = user?.user.uid else { return }

                    let usernameValues = ["username" : userName,
                                          "profileImageUrl" : urlString]
                    let values = [uid: usernameValues]

                    Database.database().reference().child("users").updateChildValues(values) { error, reference in
                        if let error = error {
                            print ("Failed to save user info into DB: \(error)")
                        }
                        print ("Sucessfully saved")
                        
                        guard let window = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
                        
                        window.setupViewControllers()

                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.backgroundColor = .white
        
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

