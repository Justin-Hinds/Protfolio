//
//  PurchaseViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/11/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Braintree

class PurchaseViewController: UIViewController {
    
    
    @IBAction func confirmButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
