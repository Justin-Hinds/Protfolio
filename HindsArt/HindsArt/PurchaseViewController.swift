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
    /// Informs the delegate when the user has decided to cancel out of the Drop-in payment form.
    ///
    /// Drop-in handles its own error cases, so this cancelation is user initiated and
    /// irreversable. Upon receiving this message, you should dismiss Drop-in.
    ///
    /// @param viewController The Drop-in view controller informing its delegate of failure or cancelation.

    var braintreeClient: BTAPIClient?
   
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
