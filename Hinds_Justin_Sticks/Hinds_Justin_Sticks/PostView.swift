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
    func sendPost()
}

class PostView: UIViewController, UITextFieldDelegate{
    lazy var postTextfield: UITextField = {
        let postTextfield = UITextField()
        postTextfield.translatesAutoresizingMaskIntoConstraints = false
        postTextfield.placeholder = "Share your experience"
        postTextfield.delegate = self
        return postTextfield
    }()
    
    override func viewDidLoad() {
        //inputComponetsSetUp()
        dismissPostView()
        view.backgroundColor = UIColor.whiteColor()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override var inputAccessoryView: UIView?{
        get{
            return inputComponetsSetUp
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

func dismissPostView() {
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
    swipeLeft.direction = .Left
    view.addGestureRecognizer(swipeLeft)
}
func swipeLeftAction() {
    self.dismissViewControllerAnimated(true, completion:  nil)
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
        containerView.backgroundColor = UIColor.grayColor()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
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
        containerView.addSubview(self.postTextfield)
        //iOS 9 Constraints
        self.postTextfield.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        self.postTextfield.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        self.postTextfield.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        self.postTextfield.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, multiplier: 4/5).active = true
        return containerView
    }()
    

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
