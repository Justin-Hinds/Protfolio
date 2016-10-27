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
    @IBAction func sendButton(_ sender: AnyObject) {
        handleSend()
    }
    
    override func viewDidLoad() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
   func handleSend(){
     let ref = FIRDatabase.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    guard let messageText = messageTextField.text else{
        return
    }
    let toId = self.user!.id!
    let senderId = FIRAuth.auth()!.currentUser!.uid
    let time: NSNumber = NSNumber(Int(Date().timeIntervalSince1970))
    let values = ["text": messageText, "toId": toId, "senderId": senderId, "time": time] as [String : Any]
    childRef.updateChildValues(values) { (error, ref) in
        if error != nil{
            print(error)
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user_messages").child(senderId)
        let messageID = childRef.key
        
        userMessagesRef.updateChildValues([messageID : 1])
        let recipientMessageRef = FIRDatabase.database().reference().child("user_messages").child(toId)
        recipientMessageRef.updateChildValues([messageID : 1])
    }
    
    }
}
