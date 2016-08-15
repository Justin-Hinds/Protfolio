//
//  PostCell.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    var textView: UITextView = {
       let tv = UITextView()
        tv.text = "ipsom"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
//    var postView: UIView = {
//        
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(postView)
        addSubview(textView)
        backgroundColor = UIColor.blackColor()
        //constraints
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

