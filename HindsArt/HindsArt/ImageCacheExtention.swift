//
//  ImageCacheExtention.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/6/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCache(_ urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImg = UIImage(data: data!) {
                    imageCache.setObject(downloadedImg, forKey: urlString as NSString)
                    
                    self.image = downloadedImg
                }
            })
            
        }).resume()
    }
    
}

