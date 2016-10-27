//
//  MyTableViewController.swift
//  Hinds_Justin_CE5
//
//  Created by Justin Hinds on 10/11/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    let identifier = "cell"
    let contacts = [Contact(name: "Scott" , relationship: "Favorite"),
                    Contact(name: "Ashley", relationship: "Favorite"),
                    Contact(name: "Shawn", relationship: "Family"),
                    Contact(name: "Jessica", relationship: "Family"),
                    Contact(name: "Kristin", relationship: "Favorite"),
                    Contact(name: "Ivan", relationship: "Family"),
                    Contact(name: "Eva", relationship: "Family"),
                    Contact(name: "Filip", relationship: "Favorite")
    ]
    var filteredResults : [Contact] = []
    var searchController = UISearchController(searchResultsController: ResultsViewController())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Everyone", "Family", "Favorite"]
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        

    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        filteredResults = contacts
        guard let scope = searchController.searchBar.scopeButtonTitles?[selectedScope] else{
            return
        }
        print(scope)
        if scope != "Everyone"{
        filteredResults = filteredResults.filter({ (Contact) -> Bool in
            (Contact.relationship?.contains(scope))!
        })
        }
tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let scopeTitles = searchController.searchBar.scopeButtonTitles!
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        searchController.dimsBackgroundDuringPresentation = false
        let currentScope = scopeTitles[selectedIndex]
                filteredResults = contacts
        if searchText.isEmpty == false {
            filteredResults = filteredResults.filter({ (Contact) -> Bool in
                (Contact.name?.lowercased().contains(searchText.lowercased()))!
            })
        }
       
    tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return (filteredResults.count)
        }
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if searchController.isActive{
            cell.textLabel?.text = filteredResults[indexPath.row].name
        }else{
        cell.textLabel?.text = contacts[indexPath.row].name
        }
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
