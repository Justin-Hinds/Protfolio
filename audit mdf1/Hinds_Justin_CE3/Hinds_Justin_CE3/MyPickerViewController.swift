//
//  MyPickerViewController.swift
//  Hinds_Justin_CE3
//
//  Created by Justin Hinds on 10/7/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class MyPickerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    //array for picker
let array = ["Monday","Tuesday","Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //outlets and actions
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBAction func pickerButton(_ sender: AnyObject) {
        myPickerView.isHidden = !myPickerView.isHidden
    }
    
    
    @IBOutlet weak var Label: UILabel!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    override func viewDidLoad() {
        myPickerView.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // picker view functions
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.Label.text = array[row] 
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
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
