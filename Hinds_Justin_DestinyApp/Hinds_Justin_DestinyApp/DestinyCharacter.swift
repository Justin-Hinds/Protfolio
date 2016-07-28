//
//  DestinyCharacter.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/13/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit

class DestinyCharacter  {
    var myArray: [DestinyCharacter] = [DestinyCharacter]()
    var background : UIImage?
    var emblem : UIImage?
    var level : Int?
    var light : Int?
    var strength : Int?
    var discipline : Int?
    var intellect : Int?
    var characterClass : Int?
    var characterID: String?
    
    init(background: UIImage, emblem : UIImage, level : Int, light : Int, strength : Int, discipline : Int, intellect : Int, characterClass : Int, characterID : String) {
        self.level = level
        self.light = light
        self.strength = strength
        self.discipline = discipline
        self.intellect = intellect
        self.characterClass = characterClass
        self.characterID = characterID
    }
}