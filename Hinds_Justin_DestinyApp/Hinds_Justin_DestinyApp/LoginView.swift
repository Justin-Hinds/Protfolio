//
//  API.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/13/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginView: UIViewController{
    var characterArray : [DestinyCharacter] = [DestinyCharacter]()
    var array1  = [DestinyCharacter]()
    var gamingPlatform : Int = 0
    var ID: String?
    var  myId: String?
    var gamerTag: String?
    
    

    //current user variable
    var currentUser = FIRAuth.auth()?.currentUser
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tagID: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterToggle: UISegmentedControl!
    
    @IBAction func loginRegisterToggleAction(sender: AnyObject) {
        let title = loginRegisterToggle.titleForSegmentAtIndex(loginRegisterToggle.selectedSegmentIndex)
        if title == "Login"{
            tagID.hidden = true
             
        }else{
            tagID.hidden = false
        }
        loginRegisterButton.titleLabel?.text = title
    }
    
    
    @IBOutlet weak var loginRegisterButton: UIButton!

    @IBAction func registerButton(sender: AnyObject) {
        handleLoginOrRegister()
        
    }
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
    func handleLoginOrRegister(){
        if loginRegisterToggle.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    func handleLogin(){
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("error error")
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if  error != nil {
                print("Sign in error = \(error)")
                return
            }
            // login was sucessful

        })
    }
    func handleRegister(){
        guard let email = emailTextField.text, password = passwordTextField.text, name = tagID.text else{
            print("email or password error before register")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user , error) in
            if error != nil{
                print("create user error = \(error)")
                return
            }
            // Successful authentication
            guard let uid = user?.uid else{
                return
            }
            // reference to firebase database
            let ref = FIRDatabase.database().referenceFromURL("https://destiny-app-83ada.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print("Saving Error = \(err)")
                }
                // User saved into database
                
            })
            
        })
    }
    override func viewDidLoad() {
        getCharacterInfo()
        getMyID()
        
          }
    func getMyID(){
        let idURLString = "http://www.bungie.net/Platform/Destiny/2/Stats/GetMembershipIdByDisplayName/cakepimp101/"
        let idURL = NSURL(string: idURLString)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: idURL!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else{
                    print("not 200")
                   return
            }
            do{
                //parsing destiny api info
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                 let myID = response.objectForKey("Response") as! String
                self.myId = myID
                print(myID)
                self.performSelectorOnMainThread( #selector(self.setMyID),  withObject: nil, waitUntilDone: true)

            }catch{
                print("bad stuff happened")
            }
        }
        task.resume()
    }
    // function to get character information
    func getCharacterInfo(){
        
        // Variables for destiny api request for character info
        let host = "http://www.bungie.net"
        let myID = "4611686018428897716"
        let destinyAPI : String = "http://www.bungie.net/Platform/Destiny/2/Account/\(myID)/Summary/"
        let destiny = NSURL(string: destinyAPI)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: destiny!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        request.HTTPMethod = "GET"
        // request to api
        let task = session.dataTaskWithRequest(request, completionHandler:  {(data: NSData?, response: NSURLResponse?, error: NSError?)   in
            
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response ")
                    return
            }
            do{
                //parsing destiny api info
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let info = response.objectForKey("Response") as! NSDictionary
                let infoData = info.objectForKey("data") as! NSDictionary
                let infoCharacters = infoData.objectForKey("characters") as! NSArray
                // Looping through characters
                for character in infoCharacters {
                    let characterBase = character.objectForKey("characterBase") as! NSDictionary
                    let characterStats = characterBase.objectForKey("stats") as! NSDictionary
                    let classHash =  characterBase.objectForKey("classHash") as! Int
                    let powerLevel = characterBase.objectForKey("powerLevel") as! Int
                    let raceHash = characterBase.objectForKey("raceHash") as! Int
                    let characterID = characterBase.objectForKey("characterId") as! String
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
                    // Initializing character objects
                    let myCharacter : DestinyCharacter = DestinyCharacter(background: BGImage!, emblem: emblem!, level: baseCharacterLevel, light: lightLevel, strength: strengthLevel, discipline: disciplineLevel, intellect: intellectLevel, characterClass: classHash, characterID: characterID)
                    // Adding characters to array
                    self.characterArray.append(myCharacter)
                }
                // performing selector to transfer array to tabView
                //self.performSelectorOnMainThread( #selector(LoginView.arrayMaker),  withObject: nil, waitUntilDone: true)
                
                
            }catch{
                print("bad stuff")
            }
//            print(self.array1.count)
            self.dummy()

        })
        // resumes task(nothing happens without this)
        task.resume()
    }
    func getId(){
        let urlString = "http://www.bungie.net/platform/User/GetBungieAccount/lunch-box_223/254/"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
                guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response ")
                    return
            }
            print(realResponse)
            do{
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary

            }catch{
                
            }

            
        }
        task.resume()
    }
    // segue function
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // logic for multiple segues
        #selector(prepareForSegue)
        if (segue.identifier == "toView"){
            let detailView : DestinyViewController = segue.destinationViewController as! DestinyViewController
            detailView.myArray = characterArray
            detailView.memberID = ID
        }
    }
    func dummy(){
        print(characterArray.count)
    }
    func setMyID(){
        #selector(self.setMyID)
        self.ID = myId
    }
    // function for populating character array from inside the do catch
    func arrayMaker(){
        #selector(self.arrayMaker)
        self.characterArray = array1
    }
}