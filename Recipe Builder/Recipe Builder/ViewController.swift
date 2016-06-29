//
//  ViewController.swift
//  Recipe Builder
//
//  Created by Justin Hinds on 5/4/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

let recipeSearch: String = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?limitLicense=false&number=10&offset=0&query=pasta"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: recipeSearch)!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let connection = NSURLConnection(request: request, delegate: self)!
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response ")
                    return
            }
            do{
                print(response)
            }catch{
                print("bad stuff")
            }
        }
            task.resume()
        // Do any additional s().self.self.selfetup after loading the view, typically from a nib.
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
            //loginView.delegate = sel
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

