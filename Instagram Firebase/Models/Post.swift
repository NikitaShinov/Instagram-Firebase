//
//  Post.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import Foundation

struct Post {
    
    let imageUrl: String
    let user: User
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
