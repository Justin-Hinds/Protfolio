//
//  CharacterSelect.swift
//  
///  Created by Justin Hinds on 7/20/16.
//
//

import Foundation
import UIKit
protocol CharacterDelegate {
    func setUpCurrentCharacter(_ selectedCharacter: Int)
}

class CharacterSelect: UIViewController {
    var CurrentCharacter = 0
    var delegate : CharacterDelegate! = nil

    
    @IBAction func C1(_ sender: AnyObject) {
        delegate.setUpCurrentCharacter(0)
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    @IBAction func C2(_ sender: AnyObject) {
        delegate.setUpCurrentCharacter(1)
        self.navigationController?.popToRootViewController(animated: true)

    }
    @IBAction func C3(_ sender: AnyObject) {
        delegate.setUpCurrentCharacter(2)
        self.navigationController?.popToRootViewController(animated: true)


    }
    
    override func viewDidLoad() {
        let divc = DestinyInfo() as DestinyInfo
        divc.currentCharacter = self.CurrentCharacter

    }
}
