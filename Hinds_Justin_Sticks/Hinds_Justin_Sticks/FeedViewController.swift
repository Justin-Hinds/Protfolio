//
//  FeedViewController.swift
//  
//
//  Created by Justin Hinds on 8/9/16.
//
//

import UIKit
import Firebase

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PostDelegate {
    var userArray = [StickUser]()
    var posts = [Post]()
    let queryURLString: String = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1471200930721"
    var newsArray = [NewsPost]()
    var newsArray2 = [NewsPost]()
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
                collectionView?.backgroundColor = UIColor.whiteColor()
            collectionView?.registerClass(PostCell.self, forCellWithReuseIdentifier: "postCell")
              // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Inbox", style: .Plain, target: self, action: <#T##Selector#>)
        handleLogout()
        grabUsers()
        getNewsFeed()

    }

    func getNewsFeed() {
        let queryURL: NSURL = NSURL(string: queryURLString)!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: queryURL)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else{
                    return
            }
            
            do{
                //parsing api feed
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments) as! NSDictionary
                let feedEntry = response.objectForKey("posts") as! NSArray
                for entry in feedEntry{
                    let thread = entry.objectForKey("thread") as! NSDictionary
                    let entryTitle  = thread.objectForKey("title") as! String
                    let entryURL = thread.objectForKey("url") as! String
                    let url = NSURL(string: entryURL)
                    let entryUUID = thread.objectForKey("uuid") as! String
                   // let image = thread.objectForKey("main_image") as! String
//                    guard let mainImage = UIImage(data: NSData(contentsOfURL: NSURL(string: image)!)!) else{
//                        return
//                    }
                    let newsP: NewsPost = NewsPost(sender: entryUUID, title: entryTitle, url: url!)
                    self.newsArray.append(newsP)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView?.reloadData()
                    }
                    
                }
         

            }catch{
                
            }
            self.newsArray2 = self.newsArray
        }
        task.resume()

            }
    func grabCurrentUserAndSetupNavBar() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = StickUser()
                user.setValuesForKeysWithDictionary(dictionary)
                self.setUpNavBar(user)
            }
            
            
            }, withCancelBlock: nil)

    }
    func setUpNavBar(user: StickUser) {
        self.navigationItem.title = user.name
        let titleView = UIView()
        self.navigationItem.titleView = titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print("Logout Error = \(logoutError)")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func collectionView(collecionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PostCell = collectionView.dequeueReusableCellWithReuseIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        if newsArray.count > 0 {
            let post = newsArray[indexPath.item]
            cell.textView.text = post.text


        }
        //cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func grabUsers() {
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = StickUser()
                user.id = snapshot.key
            //Class properties must match exactly or this will cause a crash.
                user.setValuesForKeysWithDictionary(dictionary)
                self.userArray.append(user)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView!.reloadData()
                })
            }
            }, withCancelBlock: nil)
    }
    func observePost(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let userPostRef = FIRDatabase.database().reference().child("user_Post").child(uid)
        userPostRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let postID = snapshot.key
            let postRef = FIRDatabase.database().reference().child("posts").child(postID)
            postRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    let post = Post()
                    post.setValuesForKeysWithDictionary(dict)
                    self.posts.append(post)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView!.reloadData()
                        })

                    
//                    if message.chatBuddy() == self.user?.id{
//                        self.messageArray.append(message)
//                        if let toId = message.toId{
//                            self.messageDict[toId] = message
//                            self.messageArray = Array(self.messageDict.values)
//                            self.messageArray.sortInPlace({ (m1, m2) -> Bool in
//                                return m1.time?.intValue > m2.time?.intValue
//                            })
//                        }
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.messageCollectionView.reloadData()
//                        })
//                        
//                    }
                }
                
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
    }
    
    func sendPost() {
        
    }
}

class customPostCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpPost()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
func setUpPost() {
    
}