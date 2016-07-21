//
//  API.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/13/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit

class LoginView: UIViewController{
    var characterArray : [DestinyCharacter] = [DestinyCharacter]()
    var array1  = [DestinyCharacter]()
    var gamingPlatform : Int = 0

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tagID: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func platformChoice(sender: AnyObject) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            gamingPlatform = 2
        case 1:
            gamingPlatform = 1
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
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
                    let BGImage = UIImage(data: NSData(contentsOfURL: backgroundURL!)!)
                    let emblem = UIImage(data: NSData(contentsOfURL: emblemURL!)!)
                    let myCharacter : DestinyCharacter = DestinyCharacter(background: BGImage!, emblem: emblem!, level: baseCharacterLevel, light: lightLevel, strength: strengthLevel, discipline: disciplineLevel, intellect: intellectLevel, characterClass: classHash)
                    self.array1.append(myCharacter)

                }
                self.performSelectorOnMainThread( #selector(LoginView.arrayMaker),  withObject: nil, waitUntilDone: true)


            }catch{
                print("bad stuff")
            }
        })

        task.resume()

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // logic for multiple segues
        #selector(prepareForSegue)
        if (segue.identifier == "toView"){
            let detailView : DestinyViewController = segue.destinationViewController as! DestinyViewController
            detailView.myArray = characterArray
            
        }
    }
    func arrayMaker(){
        #selector(self.arrayMaker)
        self.characterArray = array1
    }
}