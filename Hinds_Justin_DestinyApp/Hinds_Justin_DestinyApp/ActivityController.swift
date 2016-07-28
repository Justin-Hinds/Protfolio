//
//  ActivityController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ActivityController: UITableViewController {
    var activityArray : [Activity]?

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return activityArray!.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activ = activityArray![indexPath.row]
        let cell =  tableView.dequeueReusableCellWithIdentifier("activityCell")
        cell!.textLabel?.text = activ.activityName
        return cell!
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "" {
            
        }
    }
}
