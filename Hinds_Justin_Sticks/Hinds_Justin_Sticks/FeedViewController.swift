//
//  FeedViewController.swift
//  
//
//  Created by Justin Hinds on 8/9/16.
//
//

import UIKit
import Firebase

class FeedViewController: UICollectionViewController {
    let queryURLString: String = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)"
    
    override func viewDidLoad() {
        let queryURL: NSURL = NSURL(string: queryURLString)!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: queryURL)
        collectionView?.backgroundColor = UIColor.whiteColor()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dictionary["name"] as? String
                print(snapshot)
            }
            
            
            }, withCancelBlock: nil)
        handleLogout()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else{
                    return
            }
            
            do{
                //parsing api feed
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let feedEntry = response.objectForKey("posts") as! NSArray
                for entry in feedEntry{
                    let thread = entry.objectForKey("thread") as! NSDictionary
                    let entryTitle  = thread.objectForKey("title") as! String
                    let entryURL = thread.objectForKey("url") as! String
                   // let image = thread.objectForKey("main_image") as! String
                    
                    
                    print(entryTitle)

                }
            }catch{
                
            }
        }
        task.resume()
    }

    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
