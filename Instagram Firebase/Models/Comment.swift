//
//  Comment.swift
//  Instagram Firebase
//
//  Created by max on 08.04.2022.
//

import Foundation


struct Comment {
    
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
