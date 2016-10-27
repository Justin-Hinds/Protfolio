//
//  newMessageController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/22/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class newMessageController: UITableViewController {
    var usersArray = [User]()
    
    override func viewDidLoad() {
        grabUser()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return usersArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = usersArray[(indexPath as NSIndexPath).row]
       let cell =  tableView.dequeueReusableCell(withIdentifier: "memberCell")
        cell!.textLabel?.text = user.name
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage"{
         let messageView = segue.destination as! ChatLog
            let indexPath = self.tableView.indexPathForSelectedRow
            let user = usersArray[((indexPath as NSIndexPath?)?.row)!]
        messageView.user = user
        }
    }
}
