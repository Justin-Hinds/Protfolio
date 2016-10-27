//
//  Settings.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
protocol FeedDelegate {
    func setUpFeed(_ feedPref: String)

}


class Settings: UIViewController {
    var feedPref = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
    
    var delegate: FeedDelegate! = nil
    
    lazy var mobileTech: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Mobile Tech", for: UIControlState())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(techPref), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var science: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Science", for: UIControlState())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(sciencePref), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var fashion: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Fashion", for: UIControlState())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(fashionPref), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var food: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        button.setTitle("Food", for: UIControlState())
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(foodPref), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        let feedView = FeedViewController() as FeedViewController
        //feedView.newsPref = self.feedPref
        
        view.backgroundColor = UIColor.white
        view.addSubview(food)
        view.addSubview(mobileTech)
        view.addSubview(fashion)
        view.addSubview(science)
        setUpButtons()
        
        dismissSettings()
    }
    func dismissSettings() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeRightAction() {
        self.dismiss(animated: true, completion:  nil)
    }

    func setUpButtons() {
        food.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        food.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        food.widthAnchor.constraint(equalToConstant: 100).isActive = true
        food.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mobileTech.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mobileTech.topAnchor.constraint(equalTo: food.bottomAnchor, constant: 8).isActive = true
        mobileTech.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mobileTech.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fashion.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fashion.bottomAnchor.constraint(equalTo: food.topAnchor, constant: -8).isActive = true
        fashion.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fashion.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        science.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        science.topAnchor.constraint(equalTo: mobileTech.bottomAnchor, constant: 8).isActive = true
        science.widthAnchor.constraint(equalToConstant: 100).isActive = true
        science.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func techPref() {
        let feedPref1 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
        delegate.setUpFeed(feedPref1)
        self.dismiss(animated: true, completion: nil)
    }
    func sciencePref() {
        let feedPref2 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=science%20language%3A(english)%20site_category%3Aeducation%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088279615"
        delegate.setUpFeed(feedPref2)
        self.dismiss(animated: true, completion: nil)
    }
    func fashionPref() {
        let feedPref3 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=fashion%20latest%20language%3A(english)%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088429690"
        delegate.setUpFeed(feedPref3)
        self.dismiss(animated: true, completion: nil)
    }
    func foodPref() {
        let feedPref4 = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=language%3A(english)%20site_category%3Afood%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472088607185"
        delegate.setUpFeed(feedPref4)

        self.dismiss(animated: true, completion: nil)
    }

}
