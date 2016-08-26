//
//  imageExtention.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache()

extension UIImageView {
    
    func loadImageUsingCache(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImg = UIImage(data: data!) {
                    imageCache.setObject(downloadedImg, forKey: urlString)
                    
                    self.image = downloadedImg
                }
            })
            
        }).resume()
    }
    
}
