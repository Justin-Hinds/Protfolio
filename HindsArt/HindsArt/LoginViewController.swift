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
    @IBAction func loginRegisterAction(_ sender: UISegmentedControl) {
        let title = loginRegisterToggle.titleForSegment(at: loginRegisterToggle.selectedSegmentIndex)

        if loginRegisterToggle.selectedSegmentIndex == 0{
            addressInfoView.isHidden = true
        }else{
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
    

//    lazy var loginRegisterToggle: UISegmentedControl = {
//        let sc = UISegmentedControl(items: ["Login", "Register"])
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.tintColor = UIColor.white
//        sc.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
//        sc.selectedSegmentIndex = 1
//        sc.addTarget(self, action: #selector(handleLoginOrRegisterChange), for: .valueChanged)
//        return sc
//    }()
        override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(R: 239 , G: 248, B: 226, A: 1)
        ref = FIRDatabase.database().reference(fromURL: "https://hindsart-2a003.firebaseio.com/")
            if loginRegisterToggle.selectedSegmentIndex == 0{
                addressInfoView.isHidden = true
            }else{
                addressInfoView.isHidden = false
                
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
