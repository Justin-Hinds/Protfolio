//
//  PostView.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

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
        view.backgroundColor = UIColor.white
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override var inputAccessoryView: UIView?{
        get{
            return inputComponetsSetUp
        }
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }

func dismissPostView() {
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
    swipeLeft.direction = .left
    view.addGestureRecognizer(swipeLeft)
}
func swipeLeftAction() {
    self.dismiss(animated: true, completion:  nil)
    }
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    func keyboardWillHide(_ notification: Notification) {
        let keyboardAnimationDuration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration!, animations: {
            self.view.layoutIfNeeded()
        }) 
        
    }
    func keyboardWillShow(_ notification: Notification){
        let keyboardFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardAnimationDuration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = keyboardFrame!.height
        UIView.animate(withDuration: keyboardAnimationDuration!, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    lazy var inputComponetsSetUp: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(R: 240, G: 240, B: 240, A: 1)
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.setTitleColor(UIColor(R: 255, G: 133, B: 55, A: 1), for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //iOS( Constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.addSubview(self.postTextfield)
        //iOS 9 Constraints
        self.postTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.postTextfield.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.postTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.postTextfield.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 4/5).isActive = true
        return containerView
    }()
    

    func handleSend(){
        print("send hit")
        let ref = FIRDatabase.database().reference().child("posts")
        let childRef = ref.childByAutoId()
        guard let postText = postTextfield.text else{
            return
        }
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let time = NSNumber(value: Int(Date().timeIntervalSince1970))
        let pID = childRef.key
        let values = ["text": postText,"senderId": senderId, "time": time, "postID": pID] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            let userMessagesRef = FIRDatabase.database().reference().child("posts_approved").child(senderId)
            let messageID = childRef.key
            
            userMessagesRef.updateChildValues([messageID : 1])

            self.postTextfield.text = nil
            self.swipeLeftAction()


        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
