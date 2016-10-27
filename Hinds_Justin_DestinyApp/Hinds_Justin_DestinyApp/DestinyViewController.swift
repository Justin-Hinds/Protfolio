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
    var array1 = [Activity]()
    override func viewDidLoad() {
        getActivityList()
        super.viewDidLoad()
        let host = "http://www.bungie.net/Platform/Destiny"
        let myID = "4611686018428897716"
        let characterId = "2305843009215786186"
        let inventory = "/2/Account/\(myID)/Character/\(characterId)/Inventory/Summary/"
        let sonyAuth = "https://auth.api.sonyentertainmentnetwork.com/login.jsp"
        let destinyAPI : String = "http://www.bungie.net/Platform/Destiny/2/Account/\(myID)/Summary/"
        let inventoryURL = URL(string: host + inventory)
        let sonyLoginUrl = URL(string: sonyAuth)
        let idURLString = "http://www.bungie.net/Platform/Destiny/2/Stats/GetMembershipIdByDisplayName/cakepimp101/"
        let idURL = URL(string: idURLString)
        let destiny = URL(string: destinyAPI)
        let session = URLSession.shared
        let inventoryRequest = NSMutableURLRequest(url: inventoryURL!)
        let request = NSMutableURLRequest(url: destiny!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        inventoryRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        inventoryRequest.httpMethod = "GET"

        let inventoryTask = session.dataTask(with: inventoryRequest, completionHandler: {(data: Data?, response: URLResponse?, error: NSError?) in
            
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response  \(inventoryRequest) ")
                    return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let info = response.object(forKey: "Response") as! NSDictionary
                let infoData = info.object(forKey: "data") as! NSDictionary
                let inventoryArray = infoData.object(forKey: "items") as! NSArray
                for item in inventoryArray{
                    let hash = item.object(forKey: "bucketHash") as! Int
                    let manifestURL = URL(string: "http://www.bungie.net/Platform/Destiny/Manifest/5/\(hash)/")
                    let manifestRequest = NSMutableURLRequest(url: manifestURL!)
                    manifestRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
                    let manifestTask = session.dataTask(with: manifestRequest, completionHandler: {(data: Data?, response: URLResponse?, error: NSError?) in
                        
                        guard let realResponse = response as? HTTPURLResponse ,
                            realResponse.statusCode == 200 else {
                                print("Not a 200 response  \(inventoryRequest) ")
                                return
                        }
                        do{
                            let manifestResponse = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // logic for multiple segues
        if (segue.identifier == "toDestiny"){
            let detailView : DestinyInfo = segue.destination as! DestinyInfo
            detailView.myArray = self.myArray
        } else if(segue.identifier == "toChat"){
            let detailView : ChatView = segue.destination as! ChatView
            detailView.handleChatTable()
        }
    }
    func getActivityList() {
        let activityString = "http://www.bungie.net/Platform/Destiny/2/Account/\(memberID!)/Character/\(myArray[currentCharacter].characterID!)/Activities/"
        let activityURL = URL(string: activityString)
        let request = NSMutableURLRequest(url: activityURL!)
        let session = URLSession.shared
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else{
                    print("not 200 response")
                    return
            }
            do{
                let activityResponse = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let activitydata = activityResponse.object(forKey: "Response") as! NSDictionary
                let dataResponse = activitydata.object(forKey: "data") as! NSDictionary
                let availableActivities = dataResponse.object(forKey: "available") as! NSArray
                var activityDictionary : [ Int : Int] = [:]
                for activities in availableActivities{
                    let activityHash = activities.object(forKey: "activityHash") as! Int
                   // print(activities)
                    let activityComplete = activities.object(forKey: "isCompleted") as! Int
                    activityDictionary[activityHash] = activityComplete
                    //print(activityDictionary)
                    let manifestURL = URL(string: "http://www.bungie.net/Platform/Destiny/Manifest/1/\(activityHash)/")
                    let manifestRequest = NSMutableURLRequest(url: manifestURL!)
                    manifestRequest.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
                    let manifestTask = session.dataTask(with: manifestRequest, completionHandler: {(data: Data?, response: URLResponse?, error: NSError?) in
                        
                        guard let realResponse = response as? HTTPURLResponse ,
                            realResponse.statusCode == 200 else {
                                print("Not a 200 response  ")
                                return
                        }
                        do{
                            let activityManifestResponse = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            var newDictionary : [String: [Int:Int]] = [:]
                            let activityDataManifest = activityManifestResponse.object(forKey: "Response") as! NSDictionary
                            let activityData2Manifest = activityDataManifest.object(forKey: "data") as! NSDictionary
                            let activity = activityData2Manifest.object(forKey: "activity") as! NSDictionary
                            let activityName  = activity.object(forKey: "activityName") as! String
                            let activitiyCompletion = activity.object(forKey: "completionFlagHash") as! Int
                            let activityDesc = activity.object(forKey: "activityDescription") as! String
                            let act: Activity = Activity(name: activityName, desc: activityDesc, complete: activitiyCompletion)
                            self.array1.append(act)
                            //self.performSelectorOnMainThread(#selector(self.arrayMaker), withObject: nil, waitUntilDone: true)
                        }catch{
                        }
                        
                    })
                    manifestTask.resume()

                }
                
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
    func arrayMaker(){
        #selector(self.arrayMaker)
        self.activityArray = array1
    }

// function to switch keys for dictionary
    func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
}

