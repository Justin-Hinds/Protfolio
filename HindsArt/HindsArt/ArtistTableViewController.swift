//
//  ArtistTableViewController.swift
//  
//
//  Created by Justin Hinds on 11/5/16.
//
//

import UIKit
import Firebase

class ArtistTableViewController: UITableViewController {

    var artistArray = [Artist]()
    var currentUser = Artist()
    override func viewDidLoad() {
        super.viewDidLoad()
        getArtists()
         }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return artistArray.count
    }
    func getArtists() {
        
        FIRDatabase.database().reference().child("artists").observe(.childAdded, with: { (snapshot) in
          //  print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let artist = Artist()
                print(snapshot)
                artist.id = snapshot.key
                artist.setValuesForKeys(dictionary)
                if FIRAuth.auth()?.currentUser?.uid != artist.id{
                    self.artistArray.append(artist)
                }else if FIRAuth.auth()?.currentUser?.uid == artist.id{
                    self.currentUser = artist
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = artistArray[indexPath.row].name
        // Configure the cell...

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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! ArtistViewController
        let indexPath = tableView.indexPathForSelectedRow
               if segue.identifier == "showArtist" {
                let artist = artistArray[(indexPath?.row)!]
                detail.artist = artist
        }else if segue.identifier == "showUser"{
                detail.artist = currentUser
        }


    }

}
