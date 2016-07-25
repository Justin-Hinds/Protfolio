//
//  TextInputViewController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/23/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class TextInput: UIViewController {
    var user : User?

    @IBOutlet weak var messageTextField: UITextField!
    @IBAction func sendButton(sender: AnyObject) {
        handleSend()
    }
    
    override func viewDidLoad() {
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
   func handleSend(){
     let ref = FIRDatabase.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    guard let messageText = messageTextField.text else{
        return
    }
    let toId = self.user!.id!
    let senderId = FIRAuth.auth()!.currentUser!.uid
    let time: NSNumber = NSDate().timeIntervalSince1970
    let values = ["text": messageText, "toId": toId, "senderId": senderId, "time": time]
    childRef.updateChildValues(values)
    }
}
