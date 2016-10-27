//
//  ViewController.swift
//  Hinds_Justin_CE10
//
//  Created by Justin Hinds on 10/20/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //tableview reference
    @IBOutlet weak var myTableView: UITableView!
    // url for request
    let myURL = URL(string: "https://congress.api.sunlightfoundation.com/legislators?in_office=true&apikey=1f4393dfee044bb18bb580ef0beb9437")
    //array for table view
    var legiArray = [Legislator]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let mySession = URLSession.shared
        let request = NSURLRequest(url: myURL!)
        var task = mySession.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else{
                    return
            }

            do{
                let response = try JSONSerialization.jsonObject(with:  data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let info = response.object(forKey: "results" ) as! NSArray
                //loop for parsing data to populate object from json
                for result in info{
                    let firstName = (result as AnyObject).object(forKey: "first_name") as! String
                    let lastName = (result as AnyObject).object(forKey: "last_name") as! String
                    let party = (result as AnyObject).object(forKey: "party") as! String
                    let state = (result as AnyObject).object(forKey: "state_name") as! String
                    let title = (result as AnyObject).object(forKey: "title") as! String
                    let bioID = (result as AnyObject).object(forKey: "bioguide_id") as! String
                    let imgURL = URL(string: "https://theunitedstates.io/images/congress/225x275/\(bioID).jpg")
                    
                    
                    let fullName = "\(firstName) \(lastName)"
                    let image = try UIImage(data: Data(contentsOf: imgURL!))
                    let legislator = Legislator(fullNam: fullName, jobTitle: title, affliation: party, img: image!, st: state)
                    self.legiArray.append(legislator)
                    print(firstName)
                    //async dispact to reload tableview
                    DispatchQueue.main.async {
                        self.myTableView?.reloadData()
                    }
                }
                print(info)
            }catch{
                print(error)
            }
        }
        task.resume()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legiArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
        let legislator = legiArray[indexPath.row]
        cell.nameLable.text = legislator.name
        cell.partyLabel.text = legislator.party
        cell.titleLabel.text = legislator.title
        if legislator.party == "R"{
        cell.backgroundColor = UIColor.red
        
        }else{
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as! DetailViewViewController
        let indexPath = myTableView.indexPathForSelectedRow
        detail.currentLegislator = legiArray[(indexPath?.row)!]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

