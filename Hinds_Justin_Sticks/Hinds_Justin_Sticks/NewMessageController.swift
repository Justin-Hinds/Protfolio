//
//  NewMessageController.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    var stickUsersArray = [StickUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grabUser()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        tableView.register(StickUserCell.self, forCellReuseIdentifier: "cellID")

    }
    func grabUser() {

        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = StickUser()
                print(snapshot)
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                if FIRAuth.auth()?.currentUser?.uid != user.id{
                self.stickUsersArray.append(user)
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            }, withCancel: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatLog = ChatLog(collectionViewLayout: UICollectionViewFlowLayout())
        let user = stickUsersArray[(indexPath as NSIndexPath).row]
        chatLog.user = user
        navigationController?.pushViewController(chatLog, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return stickUsersArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = stickUsersArray[(indexPath as NSIndexPath).row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellID")
        cell!.textLabel!.text = user.name
        return cell!
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toMessage"{
//            let messageView = segue.destinationViewController as! ChatLog
//            let indexPath = self.tableView.indexPathForSelectedRow
//            let user = usersArray[(indexPath?.row)!]
//            messageView.user = user
//        }
//    }

}

class StickUserCell: UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
