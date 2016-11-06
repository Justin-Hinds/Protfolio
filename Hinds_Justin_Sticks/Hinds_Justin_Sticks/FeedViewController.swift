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
    let time = NSNumber(value: Int(Date().timeIntervalSince1970))
    var hasImage = false
    var newsArray = [NewsPost]()
    var newsArray2 = [NewsPost]()
    var newsPref = "https://webhose.io/search?token=53c94167-efaf-426a-8228-b10c4342b062&format=json&q=smartphones%20tablets%20language%3A(english)%20site_category%3Atech%20(site_type%3Anews%20OR%20site_type%3Ablogs)&ts=1472087084380"
    override func viewWillAppear(_ animated: Bool) {
        
        

    }
    override func viewDidLoad() {
        getNewsFeed()
        collectionView?.backgroundColor = UIColor.black
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: "postCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Inbox", style: .plain, target: self, action: #selector(presentInbox))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        grabUsers()
        launchPostView()
        launchSettings()
        observePost()
    }
    
    func launchSettings() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    func swipeLeftAction() {
        let setting = Settings() as Settings
        setting.delegate = self
        self.present(setting, animated: true, completion: nil)
    }

    func launchPostView() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeRightAction() {
        self.present(PostView(), animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let webView = WebViewController()
        if posts.count > 0 {
            let post = posts[(indexPath as NSIndexPath).item]
            if let postUrl = post.linkUrl {
            let request = URLRequest(url: postUrl as URL)
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
        let queryURL: URL = URL(string: queryURLString)!
        let session = URLSession.shared
        let request = URLRequest(url: queryURL)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else{
                    return
            }
            
            do{
                //parsing api feed
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let feedEntry = response.object(forKey: "posts") as! NSArray
                for entry in feedEntry{
                    let thread = (entry as AnyObject).object(forKey: "thread") as! NSDictionary
                    let entryTitle  = thread.object(forKey: "title") as! String
                    let entryURL = thread.object(forKey: "url") as! String
                    let url = URL(string: entryURL)
                    let entryUUID = thread.object(forKey: "uuid") as! String
                    let newsP: Post = Post()
                    newsP.senderId = entryUUID
                    newsP.text = entryTitle
                    newsP.linkUrl = url
                    if let image = thread.object(forKey: "main_image") as? String{
                        guard let url = URL(string: image) else{
                            return
                        }
                    if let imageData = try? Data(contentsOf: url){
                        if let mainImage = UIImage(data: imageData) {
                            newsP.image = mainImage
                        }
                    }
                }
                   self.posts.append(newsP)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
         

            }catch{
                
            }
            self.newsArray2 = self.newsArray
        }) 
        task.resume()

            }
    func grabCurrentUserAndSetupNavBar() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = StickUser()
                user.setValuesForKeys(dictionary)
                self.setUpNavBar(user)
            }
            
            
            }, withCancel: nil)

    }
    func setUpNavBar(_ user: StickUser) {
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
        self.dismiss(animated: true, completion: nil)
        navigationController!.pushViewController(LoginView(), animated: true)
    }
    func collectionView(_ collecionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 350)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        if posts.count > 0 {
            let post = posts[(indexPath as NSIndexPath).item]
            cell.textView.text = post.text
            //print(post.image)
            cell.postImageView.image = post.image
           // print(cell.postImageView.image)

        }
        //cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func grabUsers() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = StickUser()
                user.id = snapshot.key
            //Class properties must match exactly or this will cause a crash.
                user.setValuesForKeys(dictionary)
                self.userArray.append(user)
                DispatchQueue.main.async(execute: {
                    self.collectionView!.reloadData()
                })
            }
            }, withCancel: nil)
    }
    func observePost(){

        let postRef = FIRDatabase.database().reference().child("posts")
            postRef.observe(.childAdded, with: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    print(snapshot)
                    let post = Post()
                    post.setValuesForKeys(dict)
                    self.posts.insert(post, at: 0)
                    DispatchQueue.main.async(execute: {
                        self.collectionView!.reloadData()
                        })
                    let postID = snapshot.key
                    let approveRef = FIRDatabase.database().reference().child("post_approved").child(postID)
                approveRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    }, withCancel: nil)

                }
                
                }, withCancel: nil)
    }
    
    func setUpFeed(_ feedPref: String)  {
        newsPref = feedPref
        posts.removeAll()
       // posts.removeAll()
        print(feedPref)
        print(self.newsPref)
        getNewsFeed()
        collectionView?.reloadData()
    }
}

