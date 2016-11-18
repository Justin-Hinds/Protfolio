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
    let token = FIRInstanceID.instanceID().token()!
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        handleLogout()
    }
    var paintingsArray = [Painting]()
    var user : Artist?{
        didSet{
            navigationItem.title = user!.name
            DispatchQueue.main.async {
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let paths = collectionView?.indexPathsForSelectedItems
        //let indexPath = paths?[0] as! NSIndexPath

        print(" looking for \(paths)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        print(token)
        // Register cell classes
        observePaintings()
        observeDeletion()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        
        let artistPaintingsRef = FIRDatabase.database().reference().child("paintings")
        artistPaintingsRef.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:AnyObject]{
                let painting = Painting()
                painting.setValuesForKeys(dict)
                self.paintingsArray.append(painting)
                DispatchQueue.main.async(execute: {
                    self.collectionView!.reloadData()
                })
                
            }
            
            
        }, withCancel: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func observeDeletion() {
        let artistPaintingsRef = FIRDatabase.database().reference().child("paintings")
        artistPaintingsRef.observe(.childRemoved, with: {(snapshot) in
            let paths = self.collectionView?.indexPathsForSelectedItems
            
            if let indexPath = paths?[0]{
                print(indexPath.item)
                if indexPath.isEmpty == false{
                    self.paintingsArray.remove(at: indexPath.item)
                    //self.collectionView?.deleteItems(at: indexPaths!)
                    DispatchQueue.main.async(execute: {
                        print("Updated indexPath: \(indexPath.item)")
                        self.collectionView!.reloadData()
                    })
                }
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPainting"{
            let indexPaths = collectionView?.indexPathsForSelectedItems
            let indexPath = indexPaths?[0] as! NSIndexPath
            let detail = segue.destination as! PaintingViewController
            detail.painting = paintingsArray[indexPath.item]
        }else{
            let detail = segue.destination as! UploadViewController
        }
    }
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
