//
//  PostView.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

protocol PostDelegate {
    func sendPost()}

class PostView: UIViewController, UITextFieldDelegate{
    lazy var postTextfield: UITextField = {
        let postTextfield = UITextField()
        postTextfield.translatesAutoresizingMaskIntoConstraints = false
        postTextfield.placeholder = "Share your experience"
        postTextfield.delegate = self
        return postTextfield
    }()
    
    override func viewDidLoad() {
        inputComponetsSetUp()
    }
    
    func inputComponetsSetUp() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.grayColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        // iOS9 constraints
        containerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(40).active = true
        
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        //iOS( Constraints
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor, constant: -8).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(60).active = true
        containerView.addSubview(postTextfield)
        //iOS 9 Constraints
        postTextfield.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8)
        postTextfield.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor)
        postTextfield.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor)
        postTextfield.widthAnchor.constraintEqualToAnchor(sendButton.leftAnchor)

    }
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("posts")
        let childRef = ref.childByAutoId()
        guard let postText = postTextfield.text else{
            return
        }
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let time: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": postText,"senderId": senderId, "time": time]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            let userPostRef = FIRDatabase.database().reference().child("user_Posts").child(senderId)
            let messageID = childRef.key
            
            userPostRef.updateChildValues([messageID : 1])
//            let recipientMessageRef = FIRDatabase.database().reference().child("user_messages").child(toId)
//            recipientMessageRef.updateChildValues([messageID : 1])
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
