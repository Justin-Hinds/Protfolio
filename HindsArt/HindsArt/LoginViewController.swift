//
//  LoginViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/2/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    var ref = FIRDatabaseReference()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var loginRegisterToggle: UISegmentedControl!
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBAction func loginOrRegister(_ sender: UIButton) {
        handleLoginOrRegister()
    }
    @IBOutlet weak var emailAndPasswordView: UIView!
    @IBAction func loginRegisterAction(_ sender: UISegmentedControl) {
        let title = loginRegisterToggle.titleForSegment(at: loginRegisterToggle.selectedSegmentIndex)

        if loginRegisterToggle.selectedSegmentIndex == 0{
            addressInfoView.isHidden = true
            profileImage.isHidden = true
                    }else{
            profileImage.isHidden = false
            addressInfoView.isHidden = false

        }
        loginRegisterButton.titleLabel?.text = title
    }
    
    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var addressInfoView: UIView!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var stateInput: UITextField!
    @IBOutlet weak var zipInput: UITextField!
    
    @IBOutlet weak var loginInfoView: UIView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    

        override func viewDidLoad() {
        super.viewDidLoad()
            let tap = UITapGestureRecognizer(target: self, action: #selector( profilePicSelector))
            tap.numberOfTapsRequired = 1
            profileImage.isUserInteractionEnabled = true
            profileImage.addGestureRecognizer(tap)

        ref = FIRDatabase.database().reference(fromURL: "https://hindsart-2a003.firebaseio.com/")


          }

    override func viewDidAppear(_ animated: Bool) {
        if loginRegisterToggle.selectedSegmentIndex == 0{
            addressInfoView.isHidden = true
            profileImage.isHidden = true
            emailAndPasswordView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailAndPasswordView.centerYAnchor.constraint(equalTo:  view.centerYAnchor).isActive = true
            
        }else{
            addressInfoView.isHidden = false
            profileImage.isHidden = false
        }
    }
//        func handleLoginOrRegisterChange() {
//        let title = loginRegisterToggle.titleForSegment(at: loginRegisterToggle.selectedSegmentIndex)
//        if loginRegisterToggle.selectedSegmentIndex == 0{
//        }else{
//            
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleLoginOrRegister()
        return true
    }
}


extension UIColor{
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat){
        self.init(red: R/255, green : G/255, blue: B/255, alpha: A)
    }
}
