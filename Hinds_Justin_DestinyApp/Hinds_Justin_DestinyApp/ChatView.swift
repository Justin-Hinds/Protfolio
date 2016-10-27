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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ChatView: UITableViewController {
   // log out button
    @IBAction func logoutButton(_ sender: AnyObject) {
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
        print(FIRAuth.auth()?.currentUser)
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.titleView.title = dictionary["name"] as? String
             
            }
            
            
            }, withCancel: nil)
        
        observeUserMessages()

    }
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user_messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageID)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let message = Messages()
                    message.setValuesForKeys(dict)
                    //self.messageArray.append(message)
                    if let buddyId = message.chatBuddy(){
                        self.messageDict[buddyId] = message
                        self.messageArray = Array(self.messageDict.values)
                        self.messageArray.sort(by: { (m1, m2) -> Bool in
                            return m1.time?.int32Value > m2.time?.int32Value
                        })
                    }
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }

                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    func observeMessages(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]{
                let message = Messages()
                message.setValuesForKeys(dict)
                //self.messageArray.append(message)
                if let toId = message.toId{
                    self.messageDict[toId] = message
                    self.messageArray = Array(self.messageDict.values)
                    self.messageArray.sort(by: { (m1, m2) -> Bool in
                        return m1.time?.int32Value > m2.time?.int32Value
                    })
                }
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
            }
            
            }, withCancel: nil)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.messageArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = (indexPath as NSIndexPath).row
        let message = messageArray[indexPath]
        guard let chatBuddy = message.chatBuddy() else{
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(chatBuddy)
        ref.observe(.value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:AnyObject] else{
                return
            }
            let user = User()
            user.setValuesForKeys(dict)
            let newView = ChatLog() as ChatLog
            newView.user = user
            self.currentUser = user
            //self.presentChatLog(user)

            }, withCancel: nil)
       // self.performSegueWithIdentifier("message", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageArray[(indexPath as NSIndexPath).row]
        let cell : ChatMemberCell = tableView.dequeueReusableCell(withIdentifier: "chatter") as! ChatMemberCell
              cell.message = message
        
        
        return cell
    }
// function to present chat log
    func presentChatLog(_ user: User){
        let chatLog = ChatLog() as ChatLog
        chatLog.user = user
        navigationController?.pushViewController(chatLog, animated: true)
    }
    // Function for loging out
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }        
        self.dismiss(animated: true, completion: nil)

    }
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        while self.currentUser.id == nil {
//            if identifier == "message"{
//                if self.currentUser.id != nil{
//                    return true
//                }else{
//                    return false
//                }
//            }else{
//                return false
//            }
//
//        }
//        return true
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "message"{
            let messageView = segue.destination as! ChatLog
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
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.usersArray.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            }, withCancel: nil)
    }


}
