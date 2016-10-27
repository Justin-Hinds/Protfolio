//
//  CustomCellTableViewCell.swift
//  Hinds_Justin_CE10
//
//  Created by Justin Hinds on 10/20/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    // outlets for cell
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
