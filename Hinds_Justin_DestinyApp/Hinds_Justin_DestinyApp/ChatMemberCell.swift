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
                let timeDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                time.text = dateFormatter.string(from: timeDate)

                
            }
            lastMessage.text = message!.text! as String
            
        }
    }
    fileprivate func setupName(){
                if let id = message?.chatBuddy(){
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    self.name .text = dict["name"] as? String
                    
                    
                }
                }, withCancel: nil)
        }

    }
}
