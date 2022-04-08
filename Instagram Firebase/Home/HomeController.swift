//
//  HomeController.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    
    let cellId = "cellId"
    
    var posts = [Post]()
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()

        
    }
    
    @objc private func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc private func handleRefresh() {
        print ("refresh")
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach { key, value in
                Database.fetchUserWithUID(uid: key) { user in
                    self.fetchPostsWithUser(user: user)
                }
            }
        } withCancel: { error in
            print ("Failed to fetch following user uids: \(error)")
        }
    }
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }

    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        let reference = Database.database().reference().child("posts").child(user.uid)
        reference.observeSingleEvent(of: .value) { snapshot in
            
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value) { snapshot in
                    print (snapshot)
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort { post1, post2 in
                        return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                    }
                    self.collectionView.reloadData()
                } withCancel: { error in
                    print ("Failed to fetch likes: \(error)")
                }

                
            }
            
            
        } withCancel: { error in
            print ("Failed to fetch user's posts: \(error)")
        }

    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc private func handleCamera() {
        print ("Camera")
        let cameraController = CameraController()
//        let cameraNavController = UINavigationController(rootViewController: cameraController)
        cameraController.modalPresentationStyle = .fullScreen
//        present(cameraController, animated: true, completion: nil)
        present(cameraController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username = userprofile imageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.delegate = self
        
        if let post = post {
            cell.post = post
        } else {
            print("posts \(posts.count)")
            if posts.count > 0{
                cell.post = posts[indexPath.row]
            }
        }
        
        return cell
    }
    
    func didTapComment(post: Post) {
        print ("Message coming from homecontroller")
        print (post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        print ("handlig like inside")
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        print(post.caption)
        
        guard let postId = post.id else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid : post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { error, reference in
            if let error = error {
                print ("Fail to like post \(error)")
            }
            
            print ("Successfully liked post")
            
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
}
