//
//  RecipeTableView.swift
//  Recipe Builder
//
//  Created by Justin Hinds on 5/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation

class RecipeTableView:UIViewController, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = RecipeCell() as UITableViewCell
        return cell
    }
}