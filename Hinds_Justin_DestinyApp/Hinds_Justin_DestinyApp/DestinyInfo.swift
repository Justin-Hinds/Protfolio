//
//  DestinyInfo.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/11/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation

class DestinyInfo {
    var characterArray : [DestinyCharacter] = [DestinyCharacter]()
   
    init(){
        
    }
    func getDestinyInfo() -> [DestinyCharacter]{
                let array1  = DestinyInfo()
                let host = "http://www.bungie.net"
                let myID = "4611686018428897716"
                let sonyAuth = "https://auth.api.sonyentertainmentnetwork.com/login.jsp"
                let destinyAPI : String = "http://www.bungie.net/Platform/Destiny/2/Account/\(myID)/Summary/"
                let sonyLoginUrl = NSURL(string: sonyAuth)
                let idURLString = "http://www.bungie.net/Platform/Destiny/2/Stats/GetMembershipIdByDisplayName/cakepimp101/"
                let idURL = NSURL(string: idURLString)
                let destiny = NSURL(string: destinyAPI)
                let session = NSURLSession.sharedSession()
                let request = NSMutableURLRequest(URL: destiny!)
                request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
                request.HTTPMethod = "GET"
               let task = session.dataTaskWithRequest(request, completionHandler:  {(data: NSData?, response: NSURLResponse?, error: NSError?)   in
        
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
                        for character in infoCharacters {
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
                            let baseCharacterLevel = character.objectForKey("baseCharacterLevel") as! Int
                            //print(powerLevel)
                            let myCharacter : DestinyCharacter = DestinyCharacter(level: powerLevel, light: lightLevel, strength: strengthLevel, discipline: disciplineLevel, intellect: intellectLevel, characterClass: classHash)
                            array1.characterArray.append(myCharacter)
                        }
                        print("\(array1.characterArray) 3")
                        //print(infoCharacters)
                    }catch{
                        print("bad stuff")
                    }
                self.characterArray = array1.characterArray
                print("\(array1.characterArray) 4")
                })
        print("\(self.characterArray) 5")

                task.resume()
        print("\(array1.characterArray) 6")

        return array1.characterArray
    }

}