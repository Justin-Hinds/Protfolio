//
//  Settings.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
protocol FeedDelegate {
    func setUpFeed(feedPref: String)

}


class Settings: UIViewController {
    var feedPref = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
    
    var delegate: FeedDelegate! = nil
    
    lazy var mobileTech: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Mobile Tech", forState: .Normal)
        button.userInteractionEnabled = true
        button.addTarget(self, action: #selector(techPref), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var science: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Science", forState: .Normal)
        button.userInteractionEnabled = true
        button.addTarget(self, action: #selector(sciencePref), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var fashion: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Fashion", forState: .Normal)
        button.userInteractionEnabled = true
        button.addTarget(self, action: #selector(fashionPref), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var food: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Food", forState: .Normal)
        button.userInteractionEnabled = true
        button.addTarget(self, action: #selector(foodPref), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        let feedView = FeedViewController() as FeedViewController
        //feedView.newsPref = self.feedPref
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(food)
        view.addSubview(mobileTech)
        view.addSubview(fashion)
        view.addSubview(science)
        setUpButtons()
        
        dismissSettings()
    }
    func dismissSettings() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeRightAction() {
        self.dismissViewControllerAnimated(true, completion:  nil)
    }

    func setUpButtons() {
        food.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        food.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        food.widthAnchor.constraintEqualToConstant(100).active = true
        food.heightAnchor.constraintEqualToConstant(50).active = true
        
        mobileTech.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mobileTech.topAnchor.constraintEqualToAnchor(food.bottomAnchor, constant: 8).active = true
        mobileTech.widthAnchor.constraintEqualToConstant(100).active = true
        mobileTech.heightAnchor.constraintEqualToConstant(50).active = true
        
        fashion.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        fashion.bottomAnchor.constraintEqualToAnchor(food.topAnchor, constant: -8).active = true
        fashion.widthAnchor.constraintEqualToConstant(100).active = true
        fashion.heightAnchor.constraintEqualToConstant(50).active = true
        
        science.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        science.topAnchor.constraintEqualToAnchor(mobileTech.bottomAnchor, constant: 8).active = true
        science.widthAnchor.constraintEqualToConstant(100).active = true
        science.heightAnchor.constraintEqualToConstant(50).active = true
    }
    func techPref() {
        let feedPref1 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
        delegate.setUpFeed(feedPref1)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func sciencePref() {
        let feedPref2 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=science%20language%3A(english)%20site_category%3Aeducation%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088279615"
        delegate.setUpFeed(feedPref2)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func fashionPref() {
        let feedPref3 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=fashion%20latest%20language%3A(english)%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088429690"
        delegate.setUpFeed(feedPref3)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func foodPref() {
        let feedPref4 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=language%3A(english)%20site_category%3Afood%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088607185"
        delegate.setUpFeed(feedPref4)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
