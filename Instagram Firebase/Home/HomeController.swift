//
//  HomeController.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        fetchPosts()
        
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let reference = Database.database().reference().child("posts").child(uid)
        
        reference.observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { key, value in
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            }
            
            self.collectionView.reloadData()
            
        } withCancel: { error in
            print (error.localizedDescription)
        }

    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
}
