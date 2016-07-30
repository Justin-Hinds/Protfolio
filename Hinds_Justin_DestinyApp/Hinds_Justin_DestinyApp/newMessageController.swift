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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return usersArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = usersArray[indexPath.row]
       let cell =  tableView.dequeueReusableCellWithIdentifier("memberCell")
        cell!.textLabel?.text = user.name
        return cell!
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMessage"{
         let messageView = segue.destinationViewController as! ChatLog
            let indexPath = self.tableView.indexPathForSelectedRow
            let user = usersArray[(indexPath?.row)!]
        messageView.user = user
        }
    }
}