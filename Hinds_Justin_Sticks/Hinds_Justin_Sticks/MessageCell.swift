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
        label.isEditable = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
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
        img.contentMode = .scaleToFill
        
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(messageLabel)
        bubbleView.addSubview(messageImage)
        //
        messageImage.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImage.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImage.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        messageImage.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        // constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor!.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor!.isActive = true
        // constraints
        messageLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant: 8).isActive = true
        messageLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        //messageLabel.widthAnchor.constraintEqualToConstant(200).active = true
        messageLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
