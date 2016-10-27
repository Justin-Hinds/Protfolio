//
//  ViewController.swift
//  Hind_Justin_CE6
//
//  Created by Justin Hinds on 10/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import MapKit
protocol Notation {
    func setAnnotation(pinToggle: Bool)
}
class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    let mapScreen = MapViewController()
    var delegate : Notation! = nil
    var toggle = true
    var locationTitle = ""
    var array = [String:String]()
    @IBAction func annotationToggle(_ sender: AnyObject) {
        toggle = !toggle
        myTableView.reloadData()
        print(array)
        delegate.setAnnotation(pinToggle: toggle)
        //navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let divc = MapViewController() as MapViewController
       divc.mapToggle = self.toggle
locationLabel.text = locationTitle
        array = [
            "#1" : "Big Kahuna Burger",
            "#2" : "The Double Deuce",
            "#3" :"Blazé",
            "#4" : "Metabbean",
            "#5" : "Coco Bongo",
            "#6" :"Pizza Planet",
            "#7" : "The Max",
            "#8" : "Frosty Palace",
            "#9" : "eCola Inc.",
            "#10" :"Aperature Science Labs"
        ]

        // Do any additional setup after loading the view, typically from a nib.
//        if let userLocationTitle = mapScreen.mapView.userLocation.title{
//            if userLocationTitle != nil{
//                locationLabel.text = userLocationTitle
//            }
//        }else{
//            locationLabel.text = "No Location"
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = array.k(forKey: "#\(indexPath.row + 1)").key
            cell.detailTextLabel?.text = array[indexPath].value
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

