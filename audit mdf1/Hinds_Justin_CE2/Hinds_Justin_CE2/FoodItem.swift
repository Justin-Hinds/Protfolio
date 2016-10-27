//
//  FoodItem.swift
//  Hinds_Justin_CE2
//
//  Created by Justin Hinds on 10/2/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class FoodItem {
    var title : String?
    var price : Int?
    
    init(name: String, cost: Int) {
        title = name
        price = cost
    }
}
