//
//  ChatLog.swift
//  
//
//  Created by Justin Hinds on 7/23/16.
//
//

import Foundation
import UIKit
import Firebase

class ChatLog: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var messageCollectionView: UICollectionView!
    var user : User?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        messageCollectionView.backgroundColor = UIColor.whiteColor()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : MessageCell = messageCollectionView.dequeueReusableCellWithReuseIdentifier("message", forIndexPath: indexPath) as! MessageCell
        cell.message.text = "dummy ipsom"
return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "textInput"){
            let detailView : TextInput = segue.destinationViewController as! TextInput
            detailView.user = self.user
        }
    
    }
}