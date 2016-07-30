//
//  ChatView.swift
//  
//
//  Created by Justin Hinds on 7/21/16.
//
//

import Foundation
import UIKit
import Firebase

class ChatView: UITableViewController {
   // log out button
    @IBAction func logoutButton(sender: AnyObject) {
        handleLogout()
    }
    @IBOutlet weak var titleView: UINavigationItem!
    var messageArray : [Messages] = [Messages]()
    var messageDict = [String:Messages]()
    var usersArray = [User]()
    var currentUser = User()

    override func viewDidLoad() {
        grabUser()
        let uid = FIRAuth.auth()?.currentUser?.uid
        print(FIRAuth.auth()?.currentUser?.uid)
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.titleView.title = dictionary["name"] as? String
             
            }
            
            
            }, withCancelBlock: nil)
        
        observeUserMessages()

    }
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user_messages").child(uid)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let message = Messages()
                    message.setValuesForKeysWithDictionary(dict)
                    //self.messageArray.append(message)
                    if let buddyId = message.chatBuddy(){
                        self.messageDict[buddyId] = message
                        self.messageArray = Array(self.messageDict.values)
                        self.messageArray.sortInPlace({ (m1, m2) -> Bool in
                            return m1.time?.intValue > m2.time?.intValue
                        })
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }

                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
    }
    
    func observeMessages(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]{
                let message = Messages()
                message.setValuesForKeysWithDictionary(dict)
                //self.messageArray.append(message)
                if let toId = message.toId{
                    self.messageDict[toId] = message
                    self.messageArray = Array(self.messageDict.values)
                    self.messageArray.sortInPlace({ (m1, m2) -> Bool in
                        return m1.time?.intValue > m2.time?.intValue
                    })
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
            
            }, withCancelBlock: nil)
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.messageArray.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = indexPath.row
        let message = messageArray[indexPath]
        guard let chatBuddy = message.chatBuddy() else{
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(chatBuddy)
        ref.observeEventType(.Value, withBlock: { (snapshot) in
            guard let dict = snapshot.value as? [String:AnyObject] else{
                return
            }
            let user = User()
            user.setValuesForKeysWithDictionary(dict)
//            let newView = ChatLog() as ChatLog
//            newView.user = user
            self.currentUser = user
            print(self.currentUser.name)
            }, withCancelBlock: nil)
       print("current user id: \(self.currentUser.id)")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messageArray[indexPath.row]
        let cell : ChatMemberCell = tableView.dequeueReusableCellWithIdentifier("chatter") as! ChatMemberCell
              cell.message = message
        
        
        return cell
    }
    // Function for loging out
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }        
        self.dismissViewControllerAnimated(true, completion: nil)

    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "message"{
            let messageView = segue.destinationViewController as! ChatLog
           // let indexPath = self.tableView.indexPathForSelectedRow
            messageView.user = self.currentUser
        }
    }

    func handleChatTable(){
//        messageArray.removeAll()
//        messageDict.removeAll()
        self.tableView.reloadData()
        observeUserMessages()

    }
    func grabUser() {
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeysWithDictionary(dictionary)
                self.usersArray.append(user)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            }, withCancelBlock: nil)
    }


}
