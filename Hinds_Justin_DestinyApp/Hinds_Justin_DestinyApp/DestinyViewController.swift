//
//  ViewController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 6/29/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class DestinyViewController: UITabBarController {
     var myArray = [DestinyCharacter]()
    var memberID : String?
     var currentCharacter = 0
     var currentUser = FIRAuth.auth()?.currentUser
    var activityArray = [Activity]()
    override func viewDidLoad() {
        getActivityList()
        super.viewDidLoad()
        let host = "http://www.bungie.net/Platform/Destiny"
        let myID = "4611686018428897716"
        let characterId = "2305843009215786186"
        let inventory = "/2/Account/\(myID)/Character/\(characterId)/Inventory/Summary/"
        let sonyAuth = "https://auth.api.sonyentertainmentnetwork.com/login.jsp"
        let destinyAPI : String = "http://www.bungie.net/Platform/Destiny/2/Account/\(myID)/Summary/"
        let inventoryURL = NSURL(string: host + inventory)
        let sonyLoginUrl = NSURL(string: sonyAuth)
        let idURLString = "http://www.bungie.net/Platform/Destiny/2/Stats/GetMembershipIdByDisplayName/cakepimp101/"
        let idURL = NSURL(string: idURLString)
        let destiny = NSURL(string: destinyAPI)
        let session = NSURLSession.sharedSession()
        let inventoryRequest = NSMutableURLRequest(URL: inventoryURL!)
        let request = NSMutableURLRequest(URL: destiny!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        inventoryRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        request.HTTPMethod = "GET"
        inventoryRequest.HTTPMethod = "GET"

        let inventoryTask = session.dataTaskWithRequest(inventoryRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response  \(inventoryRequest) ")
                    return
            }
            do{
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let info = response.objectForKey("Response") as! NSDictionary
                let infoData = info.objectForKey("data") as! NSDictionary
                let inventoryArray = infoData.objectForKey("items") as! NSArray
                for item in inventoryArray{
                    let hash = item.objectForKey("bucketHash") as! Int
                    let manifestURL = NSURL(string: "http://www.bungie.net/Platform/Destiny/Manifest/5/\(hash)/")
                    let manifestRequest = NSMutableURLRequest(URL: manifestURL!)
                    manifestRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
                    let manifestTask = session.dataTaskWithRequest(manifestRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
                        
                        guard let realResponse = response as? NSHTTPURLResponse where
                            realResponse.statusCode == 200 else {
                                print("Not a 200 response  \(inventoryRequest) ")
                                return
                        }
                        do{
                            let manifestResponse = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            //print(manifestResponse)

                            
                        }catch{
                    }
                        })
                    manifestTask.resume()
                    
                }
       
            }catch{
                print(response)
            }
            
        })
inventoryTask.resume()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // logic for multiple segues
        if (segue.identifier == "toDestiny"){
            let detailView : DestinyInfo = segue.destinationViewController as! DestinyInfo
            detailView.myArray = self.myArray
        } else if(segue.identifier == "toChat"){
            let detailView : ChatView = segue.destinationViewController as! ChatView
            detailView.handleChatTable()
        }
    }
    func getActivityList() {
        let activityString = "http://www.bungie.net/Platform/Destiny/2/Account/\(memberID!)/Character/\(myArray[currentCharacter].characterID!)/Activities/"
        let activityURL = NSURL(string: activityString)
        let request = NSMutableURLRequest(URL: activityURL!)
        let session = NSURLSession.sharedSession()
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else{
                    print("not 200 response")
                    return
            }
            do{
                let activityResponse = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let activitydata = activityResponse.objectForKey("Response") as! NSDictionary
                let dataResponse = activitydata.objectForKey("data") as! NSDictionary
                let availableActivities = dataResponse.objectForKey("available") as! NSArray
                var activityDictionary : [ Int : Int] = [:]
                for activities in availableActivities{
                    let activityHash = activities.objectForKey("activityHash") as! Int
                   // print(activities)
                    let activityComplete = activities.objectForKey("isCompleted") as! Int
                    activityDictionary[activityHash] = activityComplete
                    //print(activityDictionary)
                    let manifestURL = NSURL(string: "http://www.bungie.net/Platform/Destiny/Manifest/1/\(activityHash)/")
                    let manifestRequest = NSMutableURLRequest(URL: manifestURL!)
                    manifestRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
                    let manifestTask = session.dataTaskWithRequest(manifestRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
                        
                        guard let realResponse = response as? NSHTTPURLResponse where
                            realResponse.statusCode == 200 else {
                                print("Not a 200 response  ")
                                return
                        }
                        do{
                            let activityManifestResponse = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            var newDictionary : [String: [Int:Int]] = [:]
                            let activityDataManifest = activityManifestResponse.objectForKey("Response") as! NSDictionary
                            let activityData2Manifest = activityDataManifest.objectForKey("data") as! NSDictionary
                            let activity = activityData2Manifest.objectForKey("activity") as! NSDictionary
                            let activityName  = activity.objectForKey("activityName") as! String
                            let activitiyCompletion = activity.objectForKey("completionFlagHash") as! Int
                            let activityDesc = activity.objectForKey("activityDescription") as! String
                            let act: Activity = Activity(name: activityName, desc: activityDesc, complete: activitiyCompletion)
                            self.activityArray.append(act)
                            //print(activityData2Manifest)
                            
                            
                        }catch{
                        }
                    })
                    manifestTask.resume()
                    
                }
                
                //print(activityResponse)
            }catch{
                print(error)
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// function to switch keys for dictionary
    func switchKey<T, U>(inout myDict: [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValueForKey(fromKey) {
            myDict[toKey] = entry
        }
    }
}

