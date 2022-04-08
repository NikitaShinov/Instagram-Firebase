//
//  Comment.swift
//  Instagram Firebase
//
//  Created by max on 08.04.2022.
//

import Foundation


struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
