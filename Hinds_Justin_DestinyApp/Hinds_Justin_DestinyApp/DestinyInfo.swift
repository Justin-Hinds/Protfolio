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
       mainCollectionView.backgroundColor = UIColor.white
  let svc = self.tabBarController  as! DestinyViewController
    self.myArray = svc.myArray
    print(svc.myArray.count)
    print(svc.array1.count)
    self.activityArray = svc.array1
    print(activityArray.count)
   
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            performSegue(withIdentifier: "characterSelect", sender: self)
        case 1:
            performSegue(withIdentifier: "activityList", sender: self)

        default:
            break
        }
    }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return nameArray.count + 1
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell: CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CustomCell
        if ((indexPath as NSIndexPath).item > 0){
            cell.baseLevel.text = ""
            cell.classTitle.text = ""
            cell.lightLevel.text = ""
            cell.title.text = "\(nameArray[(indexPath as NSIndexPath).item - 1])"
        }else{/Users/ChefZatoichi/Documents/Protfolio/Hinds_Justin_DestinyApp/Hinds_Justin_DestinyApp/CharacterSelect.swift
        cell.cladssTitle.text = "\(myArray[currentCharacter].characterClass!)"
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         logic for multiple segues
        switch segue.identifier!{
        case "characterSelect":
            let detailView : CharacterSelect = segue.destination as! CharacterSelect
            detailView.delegate = self
        case "activityLest":
            let detailView : ActivityController = segue.destination as! ActivityController
            detailView.activityArray = activityArray
        default:
            break
        }
 
    }
    func setUpCurrentCharacter(_ selectedCharacter: Int) {
        self.currentCharacter = selectedCharacter
        mainCollectionView.reloadData()
    }


}
