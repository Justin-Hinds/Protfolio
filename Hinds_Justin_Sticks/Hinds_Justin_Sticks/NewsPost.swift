//
//  NewsPost.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/10/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class NewsPost: NSObject {
    
    var senderId: String?
    var time: NSNumber?
    var text: String?
    var image: UIImage?
    var approve: Int?
    var disapprove: Int?
    var upVote: Int?
    var downVote: Int?
    var linkUrl: NSURL?
    
    init(sender: String, timeStamp: NSNumber, title: String, mainImage: UIImage, url: NSURL) {
        senderId = sender
        time = timeStamp
        text = title
        image = mainImage
        linkUrl = url
    }
    
}
