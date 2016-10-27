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


class ChatLog: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var messageCollectionView: UICollectionView!
    var user : User?{
        didSet{
           // print(navigationItem.title)
            navigationItem.title = user!.name
            DispatchQueue.main.async { 
                //self.messageCollectionView.reloadData()
            }
        }
    }
    var messageArray = [Messages]()
    var messageDict = [String:Messages]()
    var num = 0
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        for _ in 1...5{
            print(user?.name)

        }
        messageCollectionView.backgroundColor = UIColor.white
        observeMessages()
        messageCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return messageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : MessageCell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: "message", for: indexPath) as! MessageCell
        cell.message.text = messageArray[(indexPath as NSIndexPath).row].text
return cell
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
                    let message = Messages()
                    message.setValuesForKeys(dict)
                    

                    if message.chatBuddy() == self.user?.id{
                        self.messageArray.append(message)
                        if let toId = message.senderId{
                            self.messageDict[toId] = message
                            self.messageArray = Array(self.messageDict.values)
                            self.messageArray.sort(by: { (m1, m2) -> Bool in
                                return m1.time?.int32Value > m2.time?.int32Value
                            })
                        }
                        DispatchQueue.main.async(execute: {
                            self.messageCollectionView.reloadData()
                        })

                    }
                                   }
                
                }, withCancel: nil)
            }, withCancel: nil)
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "textInput"){
            let detailView : TextInput = segue.destination as! TextInput
            detailView.user = self.user
        }
    
    }
}
