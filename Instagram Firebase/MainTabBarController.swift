//
//  MainTabBarController.swift
//  Instagram Firebase
//
//  Created by max on 02.04.2022.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                //showing if not logged in
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        setupViewControllers()
        
        
    }
    
    func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileController(collectionViewLayout: layout)
        
        let navVC = UINavigationController(rootViewController: userProfileVC)
        navVC.tabBarItem.image = UIImage(named: "profile_unselected")
        navVC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navVC]
        
    }
}
