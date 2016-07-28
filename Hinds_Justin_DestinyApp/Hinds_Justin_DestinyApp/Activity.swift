//
//  Activity.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/25/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class Activity: NSObject {
    var activityName: String?
    var activityDesc: String?
    var activityCompletion: Bool?
    
    init(name: String, desc: String, complete: Int) {
        activityName = name
        activityDesc = desc
        if complete == 1 {
            activityCompletion = true
        }else{
            activityCompletion = true
        }
    }
}
