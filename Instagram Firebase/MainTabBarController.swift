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
        //home
        let homeNavController = templateNavController(unselectedImage: "home_unselected", selectedImage: "home_selected", rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavController = templateNavController(unselectedImage: "search_unselected", selectedImage: "search_selected")
        
        //plus
        let plusNavController = templateNavController(unselectedImage: "plus_unselected", selectedImage: "plus_selected")
        
        //likes
        let likeNavController = templateNavController(unselectedImage: "like_unselected", selectedImage: "like_selected")
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileVC)
        userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           likeNavController,
                           plusNavController,
                           userProfileNavController,
                           searchNavController]
        
        //modify tab bar insets
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
//        viewControllers = [navVC]
        
    }
    
    fileprivate func templateNavController(unselectedImage: String, selectedImage: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedImage)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        return navController
    }
}
