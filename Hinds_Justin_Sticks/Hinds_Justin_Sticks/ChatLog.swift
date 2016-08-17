//
//  ChatLog.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class ChatLog: UICollectionViewController, UITextFieldDelegate{
    var user : StickUser?{
        didSet{
            // print(navigationItem.title)
            navigationItem.title = user!.name
            dispatch_async(dispatch_get_main_queue()) {
                //self.collectionView!.reloadData()
            }
        }
    }
    lazy var messageTextField: UITextField = {
        let messageTextfield = UITextField()
        messageTextfield.translatesAutoresizingMaskIntoConstraints = false
        messageTextfield.placeholder = "Send Message..."
        messageTextfield.delegate = self
        return messageTextfield
    }()

    var messageArray = [Message]()
    var messageDict = [String:Message]()
    var num = 0
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        collectionView!.backgroundColor = UIColor.whiteColor()
        observeMessages()
        collectionView!.reloadData()
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messageArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : MessageCell = collectionView.dequeueReusableCellWithReuseIdentifier("message", forIndexPath: indexPath) as! MessageCell
        cell.messageLabel.text = messageArray[indexPath.row].text
        return cell
    }
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user_messages").child(uid)
        userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let messageID = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageID)
            messageRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let message = Message()
                    message.setValuesForKeysWithDictionary(dict)
                    
                    
                    if message.chatBuddy() == self.user?.id{
                        self.messageArray.append(message)
                        if let toId = message.toId{
                            self.messageDict[toId] = message
                            self.messageArray = Array(self.messageDict.values)
                            self.messageArray.sortInPlace({ (m1, m2) -> Bool in
                                return m1.time?.intValue > m2.time?.intValue
                            })
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.collectionView!.reloadData()
                        })
                        
                    }
                }
                
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
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
        containerView.addSubview(messageTextField)
        //iOS 9 Constraints
        messageTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8)
        messageTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor)
        messageTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor)
        messageTextField.widthAnchor.constraintEqualToAnchor(sendButton.leftAnchor)
        
    }

    
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let messageText = messageTextField.text else{
            return
        }
        let toId = self.user!.id!
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let time: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": messageText, "toId": toId, "senderId": senderId, "time": time]
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
