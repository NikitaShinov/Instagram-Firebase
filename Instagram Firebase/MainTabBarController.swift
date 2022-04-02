//
//  MainTabBarController.swift
//  Instagram Firebase
//
//  Created by max on 02.04.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileController(collectionViewLayout: layout)
        
        let navVC = UINavigationController(rootViewController: userProfileVC)
        navVC.tabBarItem.image = UIImage(named: "profile_unselected")
        navVC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navVC]
    }
}
