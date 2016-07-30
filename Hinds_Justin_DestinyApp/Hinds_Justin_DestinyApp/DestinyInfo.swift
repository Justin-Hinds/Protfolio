//
//  DestinyInfo.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/11/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DestinyInfo : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CharacterDelegate{
    var myArray = [DestinyCharacter]()
    var nameArray = ["Tasks", "Activity", "Inventory", "Weapons"]
    var activityArray = [Activity]()
    
    var currentCharacter = 0
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
   override func viewDidLoad() {
       mainCollectionView.backgroundColor = UIColor.whiteColor()
  let svc = self.tabBarController  as! DestinyViewController
    self.myArray = svc.myArray
    print(svc.myArray.count)
    print(svc.array1.count)
    self.activityArray = svc.array1
    print(activityArray.count)
   
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("characterSelect", sender: self)
        case 1:
            performSegueWithIdentifier("activityList", sender: self)

        default:
            break
        }
    }
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return nameArray.count + 1
    }
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell: CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("characterCell", forIndexPath: indexPath) as! CustomCell
        if (indexPath.item > 0){
            cell.baseLevel.text = ""
            cell.classTitle.text = ""
            cell.lightLevel.text = ""
            cell.title.text = "\(nameArray[indexPath.item - 1])"
        }else{
        cell.classTitle.text = "\(myArray[currentCharacter].characterClass!)"
        cell.lightLevel.text = "Light: \(myArray[currentCharacter].light!)"
        cell.baseLevel.text = "Level: \(myArray[currentCharacter].level!)"
        cell.backgroundImage.image = myArray[currentCharacter].background
        cell.title.text = ""
        }

        return cell
    }
    
//    override func viewWillAppear(animated: Bool) {
//        print(currentCharacter)
//        mainCollectionView.reloadData()
//    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         logic for multiple segues
        switch segue.identifier!{
        case "characterSelect":
            let detailView : CharacterSelect = segue.destinationViewController as! CharacterSelect
            detailView.delegate = self
        case "activityLest":
            let detailView : ActivityController = segue.destinationViewController as! ActivityController
            detailView.activityArray = activityArray
        default:
            break
        }
 
    }
    func setUpCurrentCharacter(selectedCharacter: Int) {
        self.currentCharacter = selectedCharacter
        mainCollectionView.reloadData()
    }


}