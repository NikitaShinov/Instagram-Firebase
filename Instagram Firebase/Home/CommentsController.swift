//
//  CommentsController.swift
//  Instagram Firebase
//
//  Created by max on 08.04.2022.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .red
        
        tabBarController?.tabBar.isHidden = true 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter comment"
        return text
    }()
    
    @objc private func submitComment() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print ("submitting comment: \(commentTextField.text ?? "")")
        
        let postId = post?.id ?? ""
        
        let values = ["text": commentTextField.text ?? "",
                      "creationDate": Date().timeIntervalSince1970,
                      "uid": uid] as [String: Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { error, reference in
            if let error = error {
                print ("failed to insert comment:\(error)")
                return
            }
            
            print ("successfully entered comment")
        }
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
