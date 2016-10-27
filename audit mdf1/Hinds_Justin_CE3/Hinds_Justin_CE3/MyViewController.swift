//
//  ViewController.swift
//  Hinds_Justin_CE3
//
//  Created by Justin Hinds on 10/7/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    //outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // image
        let dogImg = UIImage(named: "dog")
        //model
        let newView = ViewObject(name: "Wishbone", image: dogImg!)
        name.text = newView.title
        image.image = newView.img
        print()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

