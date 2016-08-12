//
//  ViewController.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/8/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class LoginView: UIViewController {
    
    let ref = FIRDatabase.database().referenceFromURL("https://sticks-12d93.firebaseio.com/")
    lazy var loginRegisterToggle: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginOrRegisterChange), forControlEvents: .ValueChanged)
        return sc
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
    let passwordInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.secureTextEntry = true
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
            // reference to firebase database
            let usersReference = self.ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print("Saving Error = \(err)")
                }
                // User saved into database
                self.navigationController?.presentViewController(FeedViewController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true, completion: nil)
            })
            
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
    



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()
        view.addSubview(inputContainer)
        view.addSubview(loginRegisterButton)
        view.addSubview(appTitle)
        view.addSubview(loginRegisterToggle)
        inputsContainerSetup()
        registerButtonSetup()
        titleSetup()
        loginSCSetup()
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
    }
    func handleLoginOrRegister(){
        if loginRegisterToggle.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }

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
    
    func registerButtonSetup() {
        //Constraints
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputContainer.bottomAnchor, constant: 8).active = true
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputContainer.widthAnchor, constant: -220).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(40).active = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension UIColor{
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat){
        self.init(red: R/255, green : G/255, blue: B/255, alpha: A)
    }
    
}

