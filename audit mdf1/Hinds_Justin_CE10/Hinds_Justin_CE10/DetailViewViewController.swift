//
//  DetailViewViewController.swift
//  Hinds_Justin_CE10
//
//  Created by Justin Hinds on 10/20/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class DetailViewViewController: UIViewController {
    // object for populating view
    var currentLegislator: Legislator?
    //outlets for view
    @IBOutlet weak var party: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var residence: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populating ui from object
        party.text = currentLegislator?.party
        imageView.image = currentLegislator?.image
        residence.text = currentLegislator?.state
        titleLable.text = currentLegislator?.title
        navigationItem.title = currentLegislator?.name
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
