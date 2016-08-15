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
    func handleRegister(){
        guard let email = emailInput.text, password = passwordInput.text, name = nameInput.text else{
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
            self.navigationController?.presentViewController(FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true, completion: nil)
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
            selectedImage = originalImage as! UIImage
        }
        if let profilePic = selectedImage{
            profileImage.image = profilePic
        }
    }
}
