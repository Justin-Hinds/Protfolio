//
//  Messages.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/27/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class Messages: NSObject {
    
    var toId : String?
    var senderId : String?
    var time : NSNumber?
    var text : String?

    func chatBuddy() -> String?{
        return senderId == FIRAuth.auth()?.currentUser?.uid ? toId : senderId

    }
}
