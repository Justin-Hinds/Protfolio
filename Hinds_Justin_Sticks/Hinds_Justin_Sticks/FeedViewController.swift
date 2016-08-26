//
//  FeedViewController.swift
//  
//
//  Created by Justin Hinds on 8/9/16.
//
//

import UIKit
import Firebase

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FeedDelegate {
    var userArray = [StickUser]()
    var posts = [Post]()
    let time: NSNumber = Int(NSDate().timeIntervalSince1970)
    var hasImage = false
    var newsArray = [NewsPost]()
    var newsArray2 = [NewsPost]()
    var newsPref = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
    override func viewWillAppear(animated: Bool) {
        
        

    }
    override func viewDidLoad() {
        getNewsFeed()
        collectionView?.backgroundColor = UIColor.blackColor()
        collectionView?.registerClass(PostCell.self, forCellWithReuseIdentifier: "postCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Inbox", style: .Plain, target: self, action: #selector(presentInbox))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        grabUsers()
        launchPostView()
        launchSettings()
        observePost()
    }
    
    func launchSettings() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
    }
    func swipeLeftAction() {
        let setting = Settings() as Settings
        setting.delegate = self
        self.presentViewController(setting, animated: true, completion: nil)
    }

    func launchPostView() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeRightAction() {
        self.presentViewController(PostView(), animated: true, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let webView = WebViewController()
        if posts.count > 0 {
            let post = posts[indexPath.item]
            if let postUrl = post.linkUrl {
            let request = NSURLRequest(URL: postUrl)
            webView.postWebView.loadRequest(request)
            navigationController?.pushViewController(webView, animated: true)
            }
            
        }

    }
    // Function to present inbox
    func presentInbox() {
        let inboxController = NewMessageController()

        navigationController?.pushViewController(inboxController, animated: true)
    }
    func getNewsFeed() {
         let queryURLString: String = newsPref //"https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=\(newsPref)%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=\(time)"
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
                    let newsP: Post = Post()
                    newsP.senderId = entryUUID
                    newsP.text = entryTitle
                    newsP.linkUrl = url
                    if let image = thread.objectForKey("main_image") as? String{
                        guard let url = NSURL(string: image) else{
                            return
                        }
                    if let imageData = NSData(contentsOfURL: url){
                        if let mainImage = UIImage(data: imageData) {
                            newsP.image = mainImage
                        }
                    }
                }
                   self.posts.append(newsP)
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
        navigationController!.pushViewController(LoginView(), animated: true)
    }
    func collectionView(collecionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 350)
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PostCell = collectionView.dequeueReusableCellWithReuseIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        if posts.count > 0 {
            let post = posts[indexPath.item]
            cell.textView.text = post.text
            //print(post.image)
            cell.postImageView.image = post.image
           // print(cell.postImageView.image)

        }
        //cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
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

        let postRef = FIRDatabase.database().reference().child("posts")
            postRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    print(snapshot)
                    let post = Post()
                    post.setValuesForKeysWithDictionary(dict)
                    self.posts.insert(post, atIndex: 0)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView!.reloadData()
                        })
                    let postID = snapshot.key
                    let approveRef = FIRDatabase.database().reference().child("post_approved").child(postID)
                approveRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print(snapshot)
                    }, withCancelBlock: nil)

                }
                
                }, withCancelBlock: nil)
    }
    
    func setUpFeed(feedPref: String)  {
        newsPref = feedPref
        posts.removeAll()
       // posts.removeAll()
        print(feedPref)
        print(self.newsPref)
        getNewsFeed()
        collectionView?.reloadData()
    }
}

