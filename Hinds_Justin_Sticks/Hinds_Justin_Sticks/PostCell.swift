//
//  PostCell.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    let commentButton: UIButton = {
        let cb = UIButton()
        let commentImage = UIImage(named: "Comments_Icon")
        cb.setImage(commentImage, forState: .Normal)
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()

    let approveButton: UIButton = {
        let ab = UIButton()
        let approveImage = UIImage(named: "Approve_Icon")
        ab.setImage(approveImage, forState: .Normal)
        ab.translatesAutoresizingMaskIntoConstraints = false
        return ab
    }()
    let disapproveButton: UIButton = {
        let disapproveImage = UIImage(named: "Disapprove_Icon")
        let db = UIButton()
        db.setImage(disapproveImage, forState: .Normal)
        db.translatesAutoresizingMaskIntoConstraints = false
        return db
    }()
    let downVoteButton: UIButton = {
        let dv = UIButton()
        let downVoteImage = UIImage(named: "DownVote_Icon")
        dv.setImage(downVoteImage, forState: .Normal)
        dv.translatesAutoresizingMaskIntoConstraints = false
        return dv
    }()
    let upVoteButton: UIButton = {
        let uv = UIButton()
        let upVoteImage = UIImage(named: "UpVote_Icon")
        uv.setImage(upVoteImage, forState: .Normal)
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()

    var textView: UITextView = {
       let tv = UITextView()
        //tv.text = "ipsom"
        tv.allowsEditingTextAttributes = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var postView: UIView = {
        let pv = UIView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = UIColor.blueColor()
        return pv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //add subviews to collection cell
        postView.addSubview(textView)
        addSubview(approveButton)
        addSubview(disapproveButton)
        addSubview(downVoteButton)
        addSubview(upVoteButton)
        addSubview(commentButton)
        addSubview(postView)
        backgroundColor = UIColor.greenColor()
        // TextView constraints
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.heightAnchor.constraintEqualToConstant(60).active = true
        textView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        textView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        //postView Constraints
        postView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        postView.heightAnchor.constraintEqualToConstant(300).active = true
        postView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        postView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        //ios constraints
        approveButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
        approveButton.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        approveButton.heightAnchor.constraintEqualToConstant(40).active = true
        approveButton.widthAnchor.constraintEqualToConstant(40).active = true
        //iOS constraints
        disapproveButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
        disapproveButton.leftAnchor.constraintEqualToAnchor(approveButton.rightAnchor, constant: 8).active = true
        disapproveButton.heightAnchor.constraintEqualToConstant(40).active = true
        disapproveButton.widthAnchor.constraintEqualToConstant(40).active = true
        //ios constraints
        downVoteButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
        downVoteButton.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        downVoteButton.heightAnchor.constraintEqualToConstant(40).active = true
        downVoteButton.widthAnchor.constraintEqualToConstant(40).active = true
        //iOS constraints
        upVoteButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
        upVoteButton.rightAnchor.constraintEqualToAnchor(downVoteButton.leftAnchor, constant: 0).active = true
        upVoteButton.heightAnchor.constraintEqualToConstant(40).active = true
        upVoteButton.widthAnchor.constraintEqualToConstant(40).active = true
        //iOS constraints
        commentButton.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
        commentButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        commentButton.heightAnchor.constraintEqualToConstant(40).active = true
        commentButton.widthAnchor.constraintEqualToConstant(40).active = true


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

