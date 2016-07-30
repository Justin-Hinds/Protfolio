//
//  ChatLog.swift
//  
//
//  Created by Justin Hinds on 7/23/16.
//
//

import Foundation
import UIKit
import Firebase

class ChatLog: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var messageCollectionView: UICollectionView!
    var user : User?{
        didSet{
           // print(navigationItem.title)
            navigationItem.title = user!.name
            dispatch_async(dispatch_get_main_queue()) { 
                //self.messageCollectionView.reloadData()
            }
        }
    }
    var messageArray = [Messages]()
    var messageDict = [String:Messages]()
    var num = 0
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        for _ in 1...5{
            print(user?.name)

        }
        messageCollectionView.backgroundColor = UIColor.whiteColor()
        observeMessages()
        messageCollectionView.reloadData()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : MessageCell = messageCollectionView.dequeueReusableCellWithReuseIdentifier("message", forIndexPath: indexPath) as! MessageCell
        cell.message.text = messageArray[indexPath.row].text
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
                    let message = Messages()
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
                            self.messageCollectionView.reloadData()
                        })

                    }
                                   }
                
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
    }
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "textInput"){
            let detailView : TextInput = segue.destinationViewController as! TextInput
            detailView.user = self.user
        }
    
    }
}