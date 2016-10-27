//
//  ActivityController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ActivityController: UITableViewController {
    var activityArray = [Activity]()
    
    override func viewDidLoad() {
//        let divc = DestinyInfo as! DestinyInfo()
//        self.activityArray = divc.activityArray
        
//print(activityArray.count)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return activityArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activ = activityArray[(indexPath as NSIndexPath).row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "activityCell")
        cell!.textLabel?.text = activ.activityName
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            
        }
    }
}
