//
//  DetailViewController.swift
//  Hinds_Jusin_tableView
//
//  Created by Justin Hinds on 10/2/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var currentMovie : Movie?
    
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        overview.text = currentMovie?.movieDesc
        posterImage.image = currentMovie?.moviePoster
        movieTitle.text = currentMovie?.movieTitle
        popularity.text = "\(currentMovie?.moviePopularity)"
        releaseDate.text = currentMovie?.releaseDate
        overview.isEditable = false
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
