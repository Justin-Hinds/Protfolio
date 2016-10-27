//
//  PostCell.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UICollectionViewCell {
    let commentButton: UIButton = {
        let cb = UIButton()
        let commentImage = UIImage(named: "Comments_Icon")
        cb.setImage(commentImage, for: UIControlState())
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()

    lazy var approveButton: UIButton = {
        let ab = UIButton()
        let approveImage = UIImage(named: "Approve_Icon")
        ab.setImage(approveImage, for: UIControlState())
        ab.isUserInteractionEnabled = true
        ab.addTarget(self, action: #selector(handleApprove), for: .touchUpInside)
        ab.translatesAutoresizingMaskIntoConstraints = false
        return ab
    }()
    let disapproveButton: UIButton = {
        let disapproveImage = UIImage(named: "Disapprove_Icon")
        let db = UIButton()
        db.setImage(disapproveImage, for: UIControlState())
        db.translatesAutoresizingMaskIntoConstraints = false
        return db
    }()
    let downVoteButton: UIButton = {
        let dv = UIButton()
        let downVoteImage = UIImage(named: "DownVote_Icon")
        dv.setImage(downVoteImage, for: UIControlState())
        dv.translatesAutoresizingMaskIntoConstraints = false
        return dv
    }()
    let upVoteButton: UIButton = {
        let uv = UIButton()
        let upVoteImage = UIImage(named: "UpVote_Icon")
        uv.setImage(upVoteImage, for: UIControlState())
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()

    var textView: UITextView = {
       let tv = UITextView()
        //tv.text = "ipsom"
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var postView: UIView = {
        let pv = UIView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor.white
        return pv
    }()
    var postImageView: UIImageView = {
        let pi = UIImageView()
        pi.contentMode = .scaleAspectFit
        pi.translatesAutoresizingMaskIntoConstraints = false
        return pi
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //add subviews to collection cell
        postView.addSubview(textView)
        postView.addSubview(postImageView)
        addSubview(approveButton)
        addSubview(disapproveButton)
        addSubview(downVoteButton)
        addSubview(upVoteButton)
        addSubview(commentButton)
        addSubview(postView)
        backgroundColor = UIColor(R: 47, G: 72, B: 88, A: 1)
        // TextView constraints
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //postView Constraints
        postView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        postView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        postView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //image view constraints
        postImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        postImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 17/25).isActive = true
        postImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //ios constraints
        approveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        approveButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        approveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        approveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //iOS constraints
        disapproveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        disapproveButton.leftAnchor.constraint(equalTo: approveButton.rightAnchor, constant: 8).isActive = true
        disapproveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        disapproveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //ios constraints
        downVoteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        downVoteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        downVoteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        downVoteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //iOS constraints
        upVoteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        upVoteButton.rightAnchor.constraint(equalTo: downVoteButton.leftAnchor, constant: 0).isActive = true
        upVoteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        upVoteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //iOS constraints
        commentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        commentButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func handleApprove() {
        let ref = FIRDatabase.database().reference().child("posts_approved").child("-KQ2nHnrUhq_Q-uYINXe")
        let senderId = FIRAuth.auth()!.currentUser!.uid
       // let time: NSNumber = NSNumber(Int(Date().timeIntervalSince1970))
        let values = ["senderId": senderId, "time": time] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            
//            let approveRef = childRef.child("approve").child(senderId)
//            let messageID = approveRef.key
//            
//            approveRef.updateChildValues([messageID : 1])


    }
}
}

