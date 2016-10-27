//
//  Legislator.swift
//  Hinds_Justin_CE10
//
//  Created by Justin Hinds on 10/20/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class Legislator: NSObject {
    var name : String?
    var title : String?
    var party : String?
    var image : UIImage?
    var state : String?
    
    init(fullNam: String, jobTitle: String, affliation: String, img: UIImage, st: String) {
        name = fullNam
        title = jobTitle
        party = affliation
        image = img
        state = st
    }
}
