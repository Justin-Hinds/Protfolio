//
//  LoginViewHandles.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/12/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

extension LoginView : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    enum errorCode: Int {
        case badEmailFormat = 17008
        case emailAlreadyInUse = 17007
        case badPassword = 17026
        
    }
    func handleRegister(){
        guard let email = emailInput.text, password = passwordInput.text, name = nameInput.text else{
            print("email or password error before register")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user , error) in
            if error != nil{
                switch error!.code {
                case errorCode.badEmailFormat.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: " Invalid Email", preferredStyle: UIAlertControllerStyle.Alert)
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.presentViewController(registerFail, animated: true, completion: nil)
                    //adding action to alert
                    registerFail.addAction(ok)
                    

                case errorCode.badPassword.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: " Invalid Password must be atleast 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.presentViewController(registerFail, animated: true, completion: nil)
                    //adding action to alert
                    registerFail.addAction(ok)
                    
                case errorCode.emailAlreadyInUse.rawValue:
                    let registerFail : UIAlertController = UIAlertController(title: "Sorry", message: "Email already in use please try again", preferredStyle: UIAlertControllerStyle.Alert)
                    //action for said controller
                    let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
                    })
                    
                    //casting the alert
                    self.presentViewController(registerFail, animated: true, completion: nil)
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
            let profilePicName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("Profile_Pic").child("\(profilePicName).png")
            if let profilePic = self.profileImage.image, uploadData = UIImageJPEGRepresentation(profilePic, 0.1){
                storageRef.putData(uploadData, metadata: nil
                    , completion: { (metadata, error) in
                        if error != nil{
                            print(error)
                            return
                        }
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                            let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                            self.registerUserIntoDatabase(uid, values: values)

                        }
                })
            }
       
                    })
    }
    
    func registerUserIntoDatabase(uid: String, values: [String:AnyObject]){
        // reference to firebase database
        let usersReference = self.ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print("Saving Error = \(err)")
            }
            // User saved into database
            self.navigationController?.pushViewController(FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        })
        

        
    }
    
    func handleLogin(){
        guard let email = emailInput.text, password = passwordInput.text else{
            print("error error")
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if  error != nil {
                print("Sign in error = \(error)")
                let loginFail : UIAlertController = UIAlertController(title: "Sorry", message: " There was a problem loging in please check your email and password", preferredStyle: UIAlertControllerStyle.Alert)
                //action for said controller
                let ok : UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
                })
                
                //casting the alert
                self.presentViewController(loginFail, animated: true, completion: nil)
                //adding action to alert
                loginFail.addAction(ok)

                return
            }
            // login was sucessful
            self.navigationController?.pushViewController(FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true) })
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
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {    var selectedImage = UIImage?()
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            selectedImage = (originalImage as! UIImage)
        }
        if let profilePic = selectedImage{
            profileImage.image = profilePic
        }
    }
}
