//
//  Post.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import Foundation

struct Post {
    
    let imageUrl: String
    
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? "" 
    }
}
