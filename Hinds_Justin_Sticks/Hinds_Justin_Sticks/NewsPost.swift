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
    var text: String?
    var image: UIImage?
    var approve: Int?
    var disapprove: Int?
    var upVote: Int?
    var downVote: Int?
    var linkUrl: URL?
    
    init(sender: String, title: String, url: URL) {
        senderId = sender
        text = title
        linkUrl = url
    }
    
}
