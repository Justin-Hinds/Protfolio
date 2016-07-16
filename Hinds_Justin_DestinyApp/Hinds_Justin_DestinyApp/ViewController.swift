//
//  ViewController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 6/29/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let destinyInfo = DestinyInfo()
        //destinyInfo.getDestinyInfo()
        print("\(destinyInfo.getDestinyInfo()) - view")
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
        var myArray: [DestinyCharacter] = [DestinyCharacter]()

       let task = session.dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in

            guard let realResponse = response as? NSHTTPURLResponse where
            realResponse.statusCode == 200 else {
                print("Not a 200 response ")
                return
            }
            do{
           let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
            let info = response.objectForKey("Response") as! NSDictionary
            let infoData = info.objectForKey("data") as! NSDictionary
            let infoCharacters = infoData.objectForKey("characters") as! NSArray
                var characterArray = [DestinyCharacter]()
                for character in infoCharacters{
                    let characterBase = character.objectForKey("characterBase") as! NSDictionary
                    let characterStats = characterBase.objectForKey("stats") as! NSDictionary
                    let classHash =  characterBase.objectForKey("classHash") as! Int
                    let powerLevel = characterBase.objectForKey("powerLevel") as! Int
                    let raceHash = characterBase.objectForKey("raceHash") as! Int
                    let characterID = characterBase.objectForKey("characterId")
                    let strength = characterStats.objectForKey("STAT_STRENGTH") as! NSDictionary
                    let strengthLevel = strength.objectForKey("value") as! Int
                    let intellect = characterStats.objectForKey("STAT_INTELLECT") as! NSDictionary
                    let intellectLevel = intellect.objectForKey("value") as! Int
                    let discipline = characterStats.objectForKey("STAT_DISCIPLINE") as! NSDictionary
                    let disciplineLevel = discipline.objectForKey("value") as! Int
                    let light = characterStats.objectForKey("STAT_LIGHT") as! NSDictionary
                    let lightLevel = light.objectForKey("value") as! Int
                    let emblemPath = character.objectForKey("emblemPath") as! String
                    let emblemURL = NSURL(string: host + emblemPath)
                    let backgroundPath = character.objectForKey("backgroundPath") as! String
                    let backgroundURL = NSURL(string: host + backgroundPath)
//                    let baseCharacterLevel = character.objectForKey("baseCharacterLevel") as! Int
//                    var character = DestinyCharacter(level: powerLevel, light: lightLevel, strength: strengthLevel, discipline: disciplineLevel, intellect: intellectLevel, characterClass: classHash)
//                    characterArray.append(character)
                }
            }catch{
                print("bad stuff")
            }
        
        })
        task.resume()
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
                            
//                        print(manifestResponse)
                        }catch{
                        //print(response)
                    }
                        })
                    manifestTask.resume()
                    //print(item)
                    
                }
                //let infoCharacters = infoData.objectForKey("characters") as! NSArray
//                for character in infoCharacters{
//                    let characterBase = character.objectForKey("characterBase") as! NSDictionary
//                    let characterStats = characterBase.objectForKey("stats") as! NSDictionary
//                    let classHash =  characterBase.objectForKey("classHash") as! Int
//                    let powerLevel = characterBase.objectForKey("powerLevel") as! Int
//                    let raceHash = characterBase.objectForKey("raceHash") as! Int
//                    let characterID = characterBase.objectForKey("characterId")
//                    let strength = characterStats.objectForKey("STAT_STRENGTH") as! NSDictionary
//                    let strengthLevel = strength.objectForKey("value") as! Int
//                    let intellect = characterStats.objectForKey("STAT_INTELLECT") as! NSDictionary
//                    let intellectLevel = intellect.objectForKey("value") as! Int
//                    let discipline = characterStats.objectForKey("STAT_DISCIPLINE") as! NSDictionary
//                    let disciplineLevel = discipline.objectForKey("value") as! Int
//                    let light = characterStats.objectForKey("STAT_LIGHT") as! NSDictionary
//                    let lightLevel = light.objectForKey("value") as! Int
//                    let emblemPath = character.objectForKey("emblemPath") as! String
//                    let emblemURL = NSURL(string: host + emblemPath)
//                    let backgroundPath = character.objectForKey("backgroundPath") as! String
//                    let backgroundURL = NSURL(string: host + backgroundPath)
//                    let baseCharacterLevel = character.objectForKey("baseCharacterLevel") as! Int
//                    print(response)
//                }
            }catch{
                print(response)
            }
            
        })
inventoryTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

