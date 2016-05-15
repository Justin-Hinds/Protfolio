//
//  ViewController.swift
//  Recipe Builder
//
//  Created by Justin Hinds on 5/4/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //FACEBOOK
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view!.addSubview(loginView)
            loginView.center = self.view!.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            //loginView.delegate = self
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

