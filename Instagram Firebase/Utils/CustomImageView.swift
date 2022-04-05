//
//  CustomImageView.swift
//  Instagram Firebase
//
//  Created by max on 05.04.2022.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        print ("Loading image...")
        
        lastUrlUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print ("error --- \(error)")
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
    
}
