//
//  MessageCell.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    let messageLabel: UITextView = {
        let label = UITextView()
        label.text = "rubbish"
        label.editable = false
        label.font = UIFont.systemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    static let yourBubbleViewBackgroundColor = UIColor(R: 255, G: 133, B: 55, A: 1)
    static let theirBubbleViewBackgroundColor = UIColor(R: 242, G: 242, B: 242, A: 1)
    lazy var bubbleView: UIView = {
        let bv = UIView()
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    let messageImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .ScaleToFill
        
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(messageLabel)
        bubbleView.addSubview(messageImage)
        //
        messageImage.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor).active = true
        messageImage.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor).active = true
        messageImage.heightAnchor.constraintEqualToAnchor(bubbleView.heightAnchor).active = true
        messageImage.widthAnchor.constraintEqualToAnchor(bubbleView.widthAnchor).active = true
        // constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8)
        bubbleViewRightAnchor!.active = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.active = false
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor!.active = true
        // constraints
        messageLabel.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor,constant: 8).active = true
        messageLabel.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        messageLabel.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        //messageLabel.widthAnchor.constraintEqualToConstant(200).active = true
        messageLabel.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor, constant: -8).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
