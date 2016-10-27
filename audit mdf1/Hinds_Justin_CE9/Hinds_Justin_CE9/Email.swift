//
//  email.swift
//  Hinds_Justin_CE9
//
//  Created by Justin Hinds on 10/19/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class Email: NSObject {
    var recipient : String?
    var time : String?
    
    init(toAddress: String, currentTime: Date) {
        recipient = toAddress
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.string(from: currentTime)
        
        time = formatter.string(from: currentTime)
    }

}
