//
//  ViewController.swift
//  Hinds_Justin_CE2
//
//  Created by Justin Hinds on 10/2/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cheeseArray = ["Gouda", "Stilton", "Gruyere", "Cheddar", "Emmentaler"]
    var steakArray = ["NY Strip", "Ribeye", "Sirloin", "Tri Tip", "Filler"]
    var cheeseArray2 = [FoodItem]()
    var steakArray2 =  [FoodItem]()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBAction func addRow(sender: UIButton){
        myTableView.setEditing(true, animated: true)
    }
    @IBAction func deleteRow(sender: UIButton) {
        myTableView.setEditing(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var num = 2

        for food in cheeseArray{
            let item = FoodItem(name: food, cost: num)
            cheeseArray2.append(item)
            num += 1
        }
        for food in steakArray{
            let item = FoodItem(name: food, cost: num)
            steakArray2.append(item)
            num += 2

        }
        myTableView.register(UINib(nibName: "CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return cheeseArray.count
        }else{
        return steakArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeader
        if section == 0 {
            header.label.text = "Cheese"
        }else{
            header.label.text = "Steak"
        }
        
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.section == 0{
            let cheese = cheeseArray2[indexPath.row]
            cell.item.text = cheese.title
            cell.price.text = "\(cheese.price!)"
        }else{
            let steak = steakArray2[indexPath.row]
            cell.item.text = steak.title
            cell.price.text = "\(steak.price!)"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            myTableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert{
            myTableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

