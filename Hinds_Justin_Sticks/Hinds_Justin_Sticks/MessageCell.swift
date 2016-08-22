//
//  MessageCell.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "rubbish"
        label.textColor = UIColor.clearColor()
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

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
        messageLabel.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor,constant: -8).active = true
        messageLabel.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        messageLabel.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        messageLabel.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
