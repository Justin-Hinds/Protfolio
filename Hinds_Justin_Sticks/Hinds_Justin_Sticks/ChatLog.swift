//
//  ChatLog.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class ChatLog: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var user : StickUser?{
        didSet{
            navigationItem.title = user!.name
            DispatchQueue.main.async {
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
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        collectionView!.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
        observeMessages()
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: "message")
        collectionView!.reloadData()
        collectionView?.keyboardDismissMode = .interactive
    }

//    func bottomOfView() {
//       let NSIntegerSection =  numberOfSectionsInCollectionView(self.collectionView!) - 1;
//        let NSIntegerItem =   collectionView(self.collectionView!, numberOfItemsInSection: NSIntegerSection) - 1;
//        let lastIndexPath: NSIndexPath =  NSIndexPath(forItem: NSIntegerItem, inSection: NSIntegerSection)
//        
//            func scrollToItemAtIndexPath(indexPath: lastIndexPath, atScrollPosition scrollPosition: UICollectionViewScrollPositionBottom, animated: true)
//
//    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override var inputAccessoryView: UIView?{
        get{
            return inputComponetsSetUp
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messageArray.count
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 60
        let message =  messageArray[(indexPath as NSIndexPath).item]
        if let text = message.text{
            height = textFrameEstimate(text).height + 16
        }else if let imageWidth = message.imgWidth?.floatValue, let imageHeight = message.imgHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    func textFrameEstimate(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1200)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
     return  NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : MessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as! MessageCell
        let message = messageArray[(indexPath as NSIndexPath).row]
        cellSetUp(cell, message: message)
        cell.messageLabel.text = message.text
        if let text  = message.text{
            cell.bubbleWidthAnchor?.constant = textFrameEstimate(text).width + 32

        }else if message.imgURL != nil{
            cell.bubbleWidthAnchor?.constant = 200
        }
        return cell
    }
    fileprivate func cellSetUp(_ cell: MessageCell, message: Message){
        if let messageImage = message.imgURL {
            cell.messageImage.loadImageUsingCache(messageImage)
            cell.messageImage.isHidden = false
        }else{
            cell.messageImage.isHidden = true
        }
        
        if message.senderId == FIRAuth.auth()?.currentUser?.uid{
            cell.bubbleView.backgroundColor = MessageCell.yourBubbleViewBackgroundColor
            cell.messageLabel.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = MessageCell.theirBubbleViewBackgroundColor
            cell.messageLabel.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }

    }
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user_messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageID)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let message = Message()
                    message.setValuesForKeys(dict)
                    
                    
                    if message.chatBuddy() == self.user?.id{
                        self.messageArray.append(message)
//                        if let toId = message.toId{
//                            self.messageDict[toId] = message
//                            self.messageArray = Array(self.messageDict.values)
//                            self.messageArray.sortInPlace({ (m1, m2) -> Bool in
//                                return m1.time?.intValue > m2.time?.intValue
//                            })
                        //}
                        DispatchQueue.main.async(execute: {
                            self.collectionView!.reloadData()
                        })
                        
                    }
                }
                
                }, withCancel: nil)
            }, withCancel: nil)
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
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.setTitleColor(UIColor(R: 255, G: 133, B: 55, A: 1), for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
    let uplaodImage = UIImageView()
    uplaodImage.image = UIImage(named: "pic_icon")
    uplaodImage.translatesAutoresizingMaskIntoConstraints = false
    uplaodImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUpload)))
    uplaodImage.isUserInteractionEnabled = true
    containerView.addSubview(uplaodImage)
    

    //
    uplaodImage.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    uplaodImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    uplaodImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
    uplaodImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        //iOS( Constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.addSubview(self.messageTextField)
        //iOS 9 Constraints
        self.messageTextField.leftAnchor.constraint(equalTo: uplaodImage.rightAnchor, constant: 8).isActive = true
        self.messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.messageTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 4/5).isActive = true
        return containerView
    }()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    func handleUpload(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker = UIImage()
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImageFromPicker = (originalImage as! UIImage)
        }
         let selectedImage = selectedImageFromPicker
            uploadImageToFirebase(selectedImage )
            dismiss(animated: true, completion: nil)
        
        
    }
    fileprivate func uploadImageToFirebase(_ img: UIImage){
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("message_images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(img, 0.3){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    self.sendImageMessage(imageUrl, img: img)
                }
            })

        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    fileprivate func sendImageMessage(_ imgURL: String, img: UIImage){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()

        let toId = self.user!.id!
        print(FIRAuth.auth()?.currentUser)
        let senderId = FIRAuth.auth()!.currentUser!.uid
        //let time: NSNumber = NSNumber(Int(Date().timeIntervalSince1970))
        let values = ["imgURL": imgURL, "imgHeight": img.size.height, "imgWidth": img.size.width, "toId": toId, "senderId": senderId, "time": time] as [String : Any]
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
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let messageText = messageTextField.text else{
            return
        }
        let toId = self.user!.id!
        print(FIRAuth.auth()?.currentUser)
        let senderId = FIRAuth.auth()!.currentUser!.uid
        let time = NSNumber(value: Int(Date().timeIntervalSince1970))
        let values = ["text": messageText, "toId": toId, "senderId": senderId, "time": time] as [String : Any]
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
