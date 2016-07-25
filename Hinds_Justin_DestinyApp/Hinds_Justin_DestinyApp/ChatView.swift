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
    
    override func viewDidLoad() {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        print(FIRAuth.auth()?.currentUser)
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.titleView.title = dictionary["name"] as? String
             
            }
            
            print(snapshot)
            
            }, withCancelBlock: nil)
    }
    func presentChatLog(){
        let chatLog = ChatLog()
        navigationController?.presentViewController(chatLog, animated: true, completion: nil)
    }
    // Function for loging out
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }
        //let loginView = LoginView() as LoginView
        
        self.dismissViewControllerAnimated(true, completion: nil)
        //presentViewController(loginView, animated: true, completion: nil)

    }

}
