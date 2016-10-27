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
    
    let ref = FIRDatabase.database().reference(fromURL: "https://sticks-12d93.firebaseio.com/")
    lazy var loginRegisterToggle: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginOrRegisterChange), for: .valueChanged)
        return sc
    }()
    var profileImageHeightAnchor: NSLayoutConstraint?
    lazy var profileImage: UIImageView = {
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.image = UIImage(named: "Profile_Pic")
        pi.isUserInteractionEnabled = true
        pi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePicSelector)))
        return pi
    }()
    var inputContainerHeightAnchor: NSLayoutConstraint?
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Register", for: UIControlState())
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
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
        tf.isSecureTextEntry = true
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let appTitle: UILabel = {
        let label = UILabel()
        label.text = "Sticks"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(R: 239 , G: 248, B: 226, A: 1)
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
        navigationItem.hidesBackButton = true
           }
    
    func loginSCSetup() {
        // iOS 9+ constraints
        loginRegisterToggle.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -8).isActive = true
        loginRegisterToggle.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        loginRegisterToggle.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, multiplier: 1/2).isActive = true
        loginRegisterToggle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    func handleLoginOrRegisterChange() {
        let title = loginRegisterToggle.titleForSegment(at: loginRegisterToggle.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        // modifies the height of the input container
        inputContainerHeightAnchor?.constant =  loginRegisterToggle.selectedSegmentIndex == 0 ? 80 : 120
        // modifies the height of the name input
        nameInputHeightAnchor?.isActive = false
        nameInputHeightAnchor =  nameInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameInputHeightAnchor?.isActive = true
        //modifies email height 
        emailInputHeightAnchor?.isActive = false
        emailInputHeightAnchor =  emailInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailInputHeightAnchor?.isActive = true
        //modifies password height
        passwordInputHeightAnchor?.isActive = false
        passwordInputHeightAnchor =  passwordInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordInputHeightAnchor?.isActive = true
        // profile pic height
        profileImageHeightAnchor?.isActive = false
        profileImageHeightAnchor = profileImage.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterToggle.selectedSegmentIndex == 0 ? 0 : 5/6)
        profileImageHeightAnchor?.isActive = true
    }
       func inputsContainerSetup(){
        //iOS 9+ constraints(x,y,width, height) input Container
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputContainerHeightAnchor =  inputContainer.heightAnchor.constraint(equalToConstant: 120)
        inputContainerHeightAnchor!.isActive = true
        inputContainer.addSubview(nameInput)
        inputContainer.addSubview(emailInput)
        inputContainer.addSubview(passwordInput)
        //iOS 9+ constraints(x,y,width, height) Name
        nameInput.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 8).isActive = true
        nameInput.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        nameInput.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        nameInputHeightAnchor =  nameInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        nameInputHeightAnchor!.isActive = true
        //iOS 9+ constraints(x,y,width, height) Email
        emailInput.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 8).isActive = true
        emailInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor).isActive = true
        emailInput.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailInputHeightAnchor = emailInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        emailInputHeightAnchor!.isActive = true

        //iOS 9+ constraints(x,y,width, height) Password
        passwordInput.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 8).isActive = true
        passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor).isActive = true
        passwordInput.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        passwordInputHeightAnchor = passwordInput.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        passwordInputHeightAnchor!.isActive = true
    }
    
    func titleSetup() {
        appTitle.bottomAnchor.constraint(equalTo: loginRegisterToggle.topAnchor, constant: -12).isActive = true
        appTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appTitle.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, multiplier: 1/4).isActive = true
        appTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func profilePicSetup() {
        profileImage.bottomAnchor.constraint(equalTo: appTitle.topAnchor, constant: -12).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageHeightAnchor = profileImage.heightAnchor.constraint(equalToConstant: 100)
        profileImageHeightAnchor!.isActive = true
    }
    func registerButtonSetup() {
        //Constraints
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 8).isActive = true
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -220).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
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

