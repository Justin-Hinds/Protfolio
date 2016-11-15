//
//  GalleryCollectionViewController.swift
//  HindsArt
//
//  Created by Justin Hinds on 11/3/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "PaintingCell"

class GalleryCollectionViewController: UICollectionViewController {
    
    
    var paintingsArray = [Painting]()
    var user : Artist?{
        didSet{
            navigationItem.title = user!.name
            DispatchQueue.main.async {
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        observePaintings()
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return paintingsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaintingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaintingCell", for: indexPath) as! PaintingCollectionViewCell
    
        // Configure the cell
        let painting = paintingsArray[indexPath.row]
        cell.paintingImage.loadImageUsingCache(painting.imgURL!)
        cell.backgroundColor = UIColor.gray
    
        return cell
    }

    func observePaintings() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let artistPaintingsRef = FIRDatabase.database().reference().child("artist_paintings").child(uid)
        artistPaintingsRef.observe(.childAdded, with: { (snapshot) in
            let paintingID = snapshot.key
            let paintingRef = FIRDatabase.database().reference().child("paintings").child(paintingID)
            paintingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let painting = Painting()
                    painting.setValuesForKeys(dict)
                    self.paintingsArray.append(painting)
                                            DispatchQueue.main.async(execute: {
                            self.collectionView!.reloadData()
                        })
                        
                    }
                
                
            }, withCancel: nil)
        }, withCancel: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPainting"{
        let indexPaths = collectionView?.indexPathsForSelectedItems
         let indexPath = indexPaths?[0] as! NSIndexPath
        let detail = segue.destination as! PaintingViewController
            detail.painting = paintingsArray[indexPath.row]
        }else{
            let detail = segue.destination as! UploadViewController
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
