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
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageLabel)
        messageLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        messageLabel.centerXAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        messageLabel.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        messageLabel.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
