//
//  ChatLog.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class ChatLog: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    var user : StickUser?{
        didSet{
            navigationItem.title = user!.name
            dispatch_async(dispatch_get_main_queue()) {
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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
        observeMessages()
        collectionView?.registerClass(MessageCell.self, forCellWithReuseIdentifier: "message")
        collectionView!.reloadData()
        collectionView?.keyboardDismissMode = .Interactive
    }

//    func bottomOfView() {
//       let NSIntegerSection =  numberOfSectionsInCollectionView(self.collectionView!) - 1;
//        let NSIntegerItem =   collectionView(self.collectionView!, numberOfItemsInSection: NSIntegerSection) - 1;
//        let lastIndexPath: NSIndexPath =  NSIndexPath(forItem: NSIntegerItem, inSection: NSIntegerSection)
//        
//            func scrollToItemAtIndexPath(indexPath: lastIndexPath, atScrollPosition scrollPosition: UICollectionViewScrollPositionBottom, animated: true)
//
//    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override var inputAccessoryView: UIView?{
        get{
            return inputComponetsSetUp
        }
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messageArray.count
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height: CGFloat = 60
        if let text = messageArray[indexPath.item].text{
            height = textFrameEstimate(text).height + 16
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    func textFrameEstimate(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1200)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
     return  NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
        
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : MessageCell = collectionView.dequeueReusableCellWithReuseIdentifier("message", forIndexPath: indexPath) as! MessageCell
        let message = messageArray[indexPath.row]
        cellSetUp(cell, message: message)
        cell.messageLabel.text = message.text
        if let text  = message.text{
            cell.bubbleWidthAnchor?.constant = textFrameEstimate(text).width + 32

        }
        return cell
    }
    private func cellSetUp(cell: MessageCell, message: Message){
        if message.senderId == FIRAuth.auth()?.currentUser?.uid{
            cell.bubbleView.backgroundColor = MessageCell.yourBubbleViewBackgroundColor
            cell.messageLabel.textColor = UIColor.whiteColor()
            cell.bubbleViewRightAnchor?.active = true
            cell.bubbleViewLeftAnchor?.active = false
        }else{
            cell.bubbleView.backgroundColor = MessageCell.theirBubbleViewBackgroundColor
            cell.messageLabel.textColor = UIColor.blackColor()
            cell.bubbleViewRightAnchor?.active = false
            cell.bubbleViewLeftAnchor?.active = true
        }

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
//                        if let toId = message.toId{
//                            self.messageDict[toId] = message
//                            self.messageArray = Array(self.messageDict.values)
//                            self.messageArray.sortInPlace({ (m1, m2) -> Bool in
//                                return m1.time?.intValue > m2.time?.intValue
//                            })
                        //}
                        dispatch_async(dispatch_get_main_queue(), {
                            self.collectionView!.reloadData()
                        })
                        
                    }
                }
                
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
    }
    
    func setupKeyboard(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillHide(notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        containerViewBottomAnchor?.constant = 0
        UIView.animateWithDuration(keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }

    }
    func keyboardWillShow(notification: NSNotification){
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardAnimationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        containerViewBottomAnchor?.constant = keyboardFrame!.height
        UIView.animateWithDuration(keyboardAnimationDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    var containerViewBottomAnchor: NSLayoutConstraint?

   lazy var inputComponetsSetUp: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(R: 240, G: 240, B: 240, A: 1)
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.setTitleColor(UIColor(R: 255, G: 133, B: 55, A: 1), forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        //iOS( Constraints
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor, constant: -8).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(60).active = true
        containerView.addSubview(self.messageTextField)
        //iOS 9 Constraints
        self.messageTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        self.messageTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        self.messageTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        self.messageTextField.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, multiplier: 4/5).active = true
        return containerView
    }()

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let messageText = messageTextField.text else{
            return
        }
        let toId = self.user!.id!
        print(FIRAuth.auth()?.currentUser)
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let time: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": messageText, "toId": toId, "senderId": senderId, "time": time]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            self.messageTextField.text = nil
            let userMessagesRef = FIRDatabase.database().reference().child("user_messages").child(senderId)
            let messageID = childRef.key
            
            userMessagesRef.updateChildValues([messageID : 1])
            let recipientMessageRef = FIRDatabase.database().reference().child("user_messages").child(toId)
            recipientMessageRef.updateChildValues([messageID : 1])
        }
        
    }


}
