//
//  Pin.swift
//  Hind_Justin_CE6
//
//  Created by Justin Hinds on 10/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject {
    var title: String?
    var detail : String?
    var location : CLLocationCoordinate2D?
    
    init(title: String, detail: String, location: CLLocationCoordinate2D) {
        self.title = title
        self .detail = detail
        self.location = location
    }
}
