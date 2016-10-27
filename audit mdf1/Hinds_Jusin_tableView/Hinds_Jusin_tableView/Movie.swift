//
//  movie.swift
//  Hinds_Jusin_tableView
//
//  Created by Justin Hinds on 9/30/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var movieTitle: String?
    var moviePopularity: Int?
    var moviePoster : UIImage?
    var releaseDate: String?
    var movieDesc: String?
    var movieGenre: String?
    init(title: String, pop: Int, poster: UIImage, release: String, desc: String) {
        movieTitle = title
        moviePopularity = pop
        moviePoster = poster
        movieDesc = desc
        releaseDate = release
        
    }
}
