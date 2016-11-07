//
//  Login + Handlers.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/2/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import Firebase

extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    enum errorCode: Int {
        case badEmailFormat = 17008
        case emailAlreadyInUse = 17007
        case badPassword = 17026
    }
    
    func handleRegister(){
        guard let email = emailInput.text,
            let password = passwordInput.text,
            let name = nameInput.text,
            let address = addressInput.text,
            let city = cityInput.text,
            let state = stateInput.text,
            let zip = zipInput.text else{
            print("email or password error before register")
            return
        }

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user , error) in
            //error handling for authentication
            if error != nil{
                print(error!)
                switch error!._code {
                case errorCode.badEmailFormat.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: " Invalid Email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.present(registerFail, animated: true, completion: nil)
                    
                    //adding action to alert
                    registerFail.addAction(ok)
                    
                    
                case errorCode.badPassword.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: " Invalid Password must be atleast 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.present(registerFail, animated: true, completion: nil)
                    //adding action to alert
                    registerFail.addAction(ok)
                    
                case errorCode.emailAlreadyInUse.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: "Email already in use please try again", preferredStyle: UIAlertControllerStyle.alert)
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.present(registerFail, animated: true, completion: nil)
                    //adding action to alert
                    registerFail.addAction(ok)
                default: break
                }
                return
            }
            // Successful authentication
            guard let uid = user?.uid else{
                return
            }
            let profilePicName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("Profile_Pic").child("\(profilePicName).png")
            if let profilePic = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(profilePic, 0.1){
                storageRef.put(uploadData, metadata: nil
                    , completion: { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                            let values = ["name": name, "email": email, "profileImageURL": profileImageURL, "address": address, "city": city, "state": state, "zip": zip]
                            self.registerUserIntoDatabase(uid, values: values as [String : AnyObject])
                            
                        }
                })
            }
            
        })
    }
    
    func registerUserIntoDatabase(_ uid: String, values: [String:AnyObject]){
        // reference to firebase database
        let usersReference = self.ref.child("artists").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print("Saving Error = \(err)")
            }
            // User saved into database
            print("User Registered")
           // self.navigationController?.pushViewController(CustomTabBarController(), animated: true)
        })
        
        
        
    }
    
    func handleLogin(){
        guard let email = emailInput.text, let password = passwordInput.text else{
            print("error error")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if  error != nil {
                print("Sign in error = \(error)")
                let loginFail : UIAlertController = UIAlertController(title: "Sorry", message: " There was a problem loging in please check your email and password", preferredStyle: UIAlertControllerStyle.alert)
                //action for said controller
                let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (ACTION) -> Void in
                })
                
                //casting the alert
                self.present(loginFail, animated: true, completion: nil)
                //adding action to alert
                loginFail.addAction(ok)
                
                return
            }
            // login was sucessful
            self.navigationController?.pushViewController(CustomTabBarController(), animated: true) })
    }
    
    
    
    
    func handleLoginOrRegister(){
        if loginRegisterToggle.selectedSegmentIndex == 0{
            handleLogin()

        }else{
            handleRegister()

        }
        
    }
    
    func profilePicSelector() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {    var selectedImage = UIImage()
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImage = (originalImage as! UIImage)
        }
        let profilePic = selectedImage
        profileImage.image = profilePic
        
    }
}
