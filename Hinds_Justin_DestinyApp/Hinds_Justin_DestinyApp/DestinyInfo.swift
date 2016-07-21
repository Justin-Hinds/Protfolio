//
//  DestinyInfo.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/11/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import Foundation
import UIKit

class DestinyInfo : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    var myArray = [DestinyCharacter]()
    var nameArray = ["Tasks", "Activity", "Inventory", "Weapons"]
    var currentCharacter = 0
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
   override func viewDidLoad() {
    mainCollectionView.backgroundColor = UIColor.whiteColor()
  let svc = self.tabBarController  as! DestinyViewController
    self.myArray = svc.myArray
    print(currentCharacter)
    }
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
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
        cell.lightLevel.text = "\(myArray[currentCharacter].light!)"
        cell.baseLevel.text = "\(myArray[currentCharacter].level!)"
        cell.title.text = ""
        }

        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // logic for multiple segues
//        if (segue.identifier == "characters"){
//            let detailView : CharacterSelect = segue.destinationViewController as! CharacterSelect
//            
//        }
    }


}