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
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        let ref = FIRDatabase.database().referenceFromURL("https://destiny-app-83ada.firebaseio.com/")
    }
    func handleLogout(){
        let loginView = LoginView()
        presentViewController(loginView, animated: true, completion: nil)
        
    }
}
