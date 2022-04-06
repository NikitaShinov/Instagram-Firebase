//
//  UserProfilePhotoCell.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            guard let imageUrl = post?.imageUrl else { return }
            
            photoImageView.loadImage(urlString: imageUrl)
            
        }
    }
    
    let photoImageView: CustomImageView = {
        
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
