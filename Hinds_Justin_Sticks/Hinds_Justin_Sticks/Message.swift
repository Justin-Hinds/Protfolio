//
//  Message.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var toId : String?
    var senderId : String?
    var time : NSNumber?
    var text : String?
    
    func chatBuddy() -> String?{
        return senderId == FIRAuth.auth()?.currentUser?.uid ? toId : senderId
        
    }

}
