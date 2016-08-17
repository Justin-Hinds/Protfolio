//
//  ViewController.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/8/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class LoginView: UIViewController , UITextFieldDelegate{
    
    let ref = FIRDatabase.database().referenceFromURL("https://sticks-12d93.firebaseio.com/")
    lazy var loginRegisterToggle: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginOrRegisterChange), forControlEvents: .ValueChanged)
        return sc
    }()
    var profileImageHeightAnchor: NSLayoutConstraint?
    lazy var profileImage: UIImageView = {
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.image = UIImage(named: "Profile_Pic")
        pi.userInteractionEnabled = true
        pi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePicSelector)))
        return pi
    }()
    var inputContainerHeightAnchor: NSLayoutConstraint?
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(R: 200, G: 200, B: 200, A: 1)
        button.setTitle("Register", forState: .Normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginOrRegister), forControlEvents: .TouchUpInside)
        return button
    }()
    var nameInputHeightAnchor: NSLayoutConstraint?
    let nameInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    var emailInputHeightAnchor: NSLayoutConstraint?
    let emailInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    var passwordInputHeightAnchor: NSLayoutConstraint?
    lazy var passwordInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.secureTextEntry = true
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let appTitle: UILabel = {
        let label = UILabel()
        label.text = "Sticks"
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()
        view.addSubview(inputContainer)
        view.addSubview(loginRegisterButton)
        view.addSubview(appTitle)
        view.addSubview(loginRegisterToggle)
        view.addSubview(profileImage)
        inputsContainerSetup()
        registerButtonSetup()
        titleSetup()
        loginSCSetup()
        profilePicSetup()
           }
    
    func loginSCSetup() {
        // iOS 9+ constraints
        loginRegisterToggle.bottomAnchor.constraintEqualToAnchor(inputContainer.topAnchor, constant: -8).active = true
        loginRegisterToggle.centerXAnchor.constraintEqualToAnchor(inputContainer.centerXAnchor).active = true
        loginRegisterToggle.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor, multiplier: 1/2).active = true
        loginRegisterToggle.heightAnchor.constraintEqualToConstant(20).active = true
        
    }
    func handleLoginOrRegisterChange() {
        let title = loginRegisterToggle.titleForSegmentAtIndex(loginRegisterToggle.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        // modifies the height of the input container
        inputContainerHeightAnchor?.constant =  loginRegisterToggle.selectedSegmentIndex == 0 ? 80 : 120
        // modifies the height of the name input
        nameInputHeightAnchor?.active = false
        nameInputHeightAnchor =  nameInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameInputHeightAnchor?.active = true
        //modifies email height 
        emailInputHeightAnchor?.active = false
        emailInputHeightAnchor =  emailInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailInputHeightAnchor?.active = true
        //modifies password height
        passwordInputHeightAnchor?.active = false
        passwordInputHeightAnchor =  passwordInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordInputHeightAnchor?.active = true
        // profile pic height
        profileImageHeightAnchor?.active = false
        profileImageHeightAnchor = profileImage.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 0 : 5/6)
        profileImageHeightAnchor?.active = true
    }
       func inputsContainerSetup(){
        //iOS 9+ constraints(x,y,width, height) input Container
        inputContainer.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputContainer.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputContainer.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -48).active = true
        inputContainerHeightAnchor =  inputContainer.heightAnchor.constraintEqualToConstant(120)
        inputContainerHeightAnchor!.active = true
        inputContainer.addSubview(nameInput)
        inputContainer.addSubview(emailInput)
        inputContainer.addSubview(passwordInput)
        //iOS 9+ constraints(x,y,width, height) Name
        nameInput.leftAnchor.constraintEqualToAnchor(inputContainer.leftAnchor, constant: 8).active = true
        nameInput.topAnchor.constraintEqualToAnchor(inputContainer.topAnchor).active = true
        nameInput.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor).active = true
        nameInputHeightAnchor =  nameInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: 1/3)
        nameInputHeightAnchor!.active = true
        //iOS 9+ constraints(x,y,width, height) Email
        emailInput.leftAnchor.constraintEqualToAnchor(inputContainer.leftAnchor, constant: 8).active = true
        emailInput.topAnchor.constraintEqualToAnchor(nameInput.bottomAnchor).active = true
        emailInput.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor).active = true
        emailInputHeightAnchor = emailInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: 1/3)
        emailInputHeightAnchor!.active = true

        //iOS 9+ constraints(x,y,width, height) Password
        passwordInput.leftAnchor.constraintEqualToAnchor(inputContainer.leftAnchor, constant: 8).active = true
        passwordInput.topAnchor.constraintEqualToAnchor(emailInput.bottomAnchor).active = true
        passwordInput.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor).active = true
        passwordInputHeightAnchor = passwordInput.heightAnchor.constraintEqualToAnchor(inputContainer.heightAnchor, multiplier: 1/3)
        passwordInputHeightAnchor!.active = true
    }
    
    func titleSetup() {
        appTitle.bottomAnchor.constraintEqualToAnchor(loginRegisterToggle.topAnchor, constant: -12).active = true
        appTitle.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        appTitle.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor, multiplier: 1/4).active = true
        appTitle.heightAnchor.constraintEqualToConstant(20).active = true
    }
    func profilePicSetup() {
        profileImage.bottomAnchor.constraintEqualToAnchor(appTitle.topAnchor, constant: -12).active = true
        profileImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImage.widthAnchor.constraintEqualToConstant(100).active = true
        profileImageHeightAnchor = profileImage.heightAnchor.constraintEqualToConstant(100)
        profileImageHeightAnchor!.active = true
    }
    func registerButtonSetup() {
        //Constraints
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputContainer.bottomAnchor, constant: 8).active = true
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor, constant: -220).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(40).active = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleLoginOrRegister()
        return true
    }
}


extension UIColor{
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat){
        self.init(red: R/255, green : G/255, blue: B/255, alpha: A)
    }
    
}

