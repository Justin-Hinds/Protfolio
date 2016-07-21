//
//  CharacterSelect.swift
//  
///  Created by Justin Hinds on 7/20/16.
//
//

import Foundation
import UIKit

class CharacterSelect: UIViewController {
    var CurrentCharacter = 0
    
    @IBAction func C1(sender: AnyObject) {
        self.CurrentCharacter = 0
        let divc = DestinyInfo() as DestinyInfo
        divc.currentCharacter = self.CurrentCharacter
        print(divc.currentCharacter)
        self.dismissViewControllerAnimated(true, completion: {
        })

    }
    
    @IBAction func C2(sender: AnyObject) {
        self.CurrentCharacter = 1
        let divc = DestinyInfo() as DestinyInfo
        divc.currentCharacter = self.CurrentCharacter
        self.dismissViewControllerAnimated(true, completion: {
            print(divc.currentCharacter)
        })

    }
    @IBAction func C3(sender: AnyObject) {
        self.CurrentCharacter = 2
        let divc = DestinyInfo() as DestinyInfo
        divc.currentCharacter = self.CurrentCharacter
        self.dismissViewControllerAnimated(true, completion: {
        print(divc.currentCharacter)
        })


    }
    
    override func viewDidLoad() {
        let divc = DestinyInfo() as DestinyInfo
        divc.currentCharacter = self.CurrentCharacter

    }
}