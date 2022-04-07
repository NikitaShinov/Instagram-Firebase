//
//  SharePhotoController.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageTextView()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 3
        return image
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    fileprivate func setupImageTextView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleShare() {
        
        guard let caption = textView.text, caption.count > 0 else { return }
        
        guard let image = selectedImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { url, error in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print ("failed to upload image:\(error)")
            }
            
            Storage.storage().reference().child("posts").child(filename).downloadURL { url, error in
                guard let url = url, error == nil else { return }
                
                let urlString = url.absoluteString
                
                print ("Success upload:\(urlString)")
                
                self.saveToDatabaseWithImageUrl(imageUrl: urlString)
            }
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        guard let postImage = selectedImage else { return }
        
        guard let text = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostReference = Database.database().reference().child("posts").child(uid)
        
        let reference = userPostReference.childByAutoId()
        
        let values = ["imageUrl": imageUrl,
                      "caption": text,
                      "imageWidth": postImage.size.width,
                      "imageHeight": postImage.size.height,
                      "creationDate": Date().timeIntervalSince1970] as [String : Any]
        reference.updateChildValues(values) { error, reference in
            if let error = error {
                print ("Failed to save post to DB: \(error)")
            }
            print ("success saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
            let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
            
            NotificationCenter.default.post(name: updateFeedNotificationName, object: nil)
        }
        
    }
}
