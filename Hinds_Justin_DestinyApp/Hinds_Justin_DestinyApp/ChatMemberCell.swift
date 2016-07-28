//
//  ChatMemberCell.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/22/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatMemberCell : UITableViewCell{
        @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    var message : Messages?{
        didSet{
            setupName()
                if let seconds = message?.time?.doubleValue{
                let timeDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                time.text = dateFormatter.stringFromDate(timeDate)

                
            }
            lastMessage.text = message!.text! as String
            
        }
    }
    private func setupName(){
                if let id = message?.chatBuddy(){
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    self.name .text = dict["name"] as? String
                    
                    
                }
                }, withCancelBlock: nil)
        }

    }
}
