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
    
    @IBAction func loginRegisterToggleAction(_ sender: AnyObject) {
        let title = loginRegisterToggle.titleForSegment(at: loginRegisterToggle.selectedSegmentIndex)
        if title == "Login"{
            tagID.isHidden = true
             
        }else{
            tagID.isHidden = false
        }
        loginRegisterButton.titleLabel?.text = title
    }
    
    
    @IBOutlet weak var loginRegisterButton: UIButton!

    @IBAction func registerButton(_ sender: AnyObject) {
        handleLoginOrRegister()
        
    }
    @IBAction func platformChoice(_ sender: AnyObject) {
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
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("error error")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if  error != nil {
                print("Sign in error = \(error)")
                return
            }
            // login was sucessful

        })
    }
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = tagID.text else{
            print("email or password error before register")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user , error) in
            if error != nil{
                print("create user error = \(error)")
                return
            }
            // Successful authentication
            guard let uid = user?.uid else{
                return
            }
            // reference to firebase database
            let ref = FIRDatabase.database().reference(fromURL: "https://destiny-app-83ada.firebaseio.com/")
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
        let idURL = URL(string: idURLString)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: idURL!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else{
                    print("not 200")
                   return
            }
            do{
                //parsing destiny api info
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                 let myID = response.object(forKey: "Response") as! String
                self.myId = myID
                print(myID)
                self.performSelector( onMainThread: #selector(self.setMyID),  with: nil, waitUntilDone: true)

            }catch{
                print("bad stuff happened")
            }
        }) 
        task.resume()
    }
    // function to get character information
    func getCharacterInfo(){
        
        // Variables for destiny api request for character info
        let host = "http://www.bungie.net"
        let myID = "4611686018428897716"
        let destinyAPI : String = "http://www.bungie.net/Platform/Destiny/2/Account/\(myID)/Summary/"
        let destiny = URL(string: destinyAPI)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: destiny!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        // request to api
        let task = session.dataTask(with: request, completionHandler:  {(data: Data?, response: URLResponse?, error: NSError?)   in
            
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response ")
                    return
            }
            do{
                //parsing destiny api info
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let info = response.object(forKey: "Response") as! NSDictionary
                let infoData = info.object(forKey: "data") as! NSDictionary
                let infoCharacters = infoData.object(forKey: "characters") as! NSArray
                // Looping through characters
                for character in infoCharacters {
                    let characterBase = character.object(forKey: "characterBase") as! NSDictionary
                    let characterStats = characterBase.object(forKey: "stats") as! NSDictionary
                    let classHash =  characterBase.object(forKey: "classHash") as! Int
                    let powerLevel = characterBase.object(forKey: "powerLevel") as! Int
                    let raceHash = characterBase.object(forKey: "raceHash") as! Int
                    let characterID = characterBase.object(forKey: "characterId") as! String
                    let strength = characterStats.object(forKey: "STAT_STRENGTH") as! NSDictionary
                    let strengthLevel = strength.object(forKey: "value") as! Int
                    let intellect = characterStats.object(forKey: "STAT_INTELLECT") as! NSDictionary
                    let intellectLevel = intellect.object(forKey: "value") as! Int
                    let discipline = characterStats.object(forKey: "STAT_DISCIPLINE") as! NSDictionary
                    let disciplineLevel = discipline.object(forKey: "value") as! Int
                    let light = characterStats.object(forKey: "STAT_LIGHT") as! NSDictionary
                    let lightLevel = light.object(forKey: "value") as! Int
                    let emblemPath = character.object(forKey: "emblemPath") as! String
                    let emblemURL = URL(string: host + emblemPath)
                    let backgroundPath = character.object(forKey: "backgroundPath") as! String
                    let backgroundURL = URL(string: host + backgroundPath)
                    let baseCharacterLevel = character.object(forKey: "baseCharacterLevel") as! Int
                    let BGImage = UIImage(data: try! Data(contentsOf: backgroundURL!))
                    let emblem = UIImage(data: try! Data(contentsOf: emblemURL!))
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
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.setValue( "784bdaa4cf8146b89b7b0e66af487b9f", forHTTPHeaderField: "X-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response ")
                    return
            }
            print(realResponse)
            do{
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary

            }catch{
                
            }

            
        }) 
        task.resume()
    }
    // segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // logic for multiple segues
        #selector(prepare(`for`:sender:))
        if (segue.identifier == "toView"){
            let detailView : DestinyViewController = segue.destination as! DestinyViewController
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
