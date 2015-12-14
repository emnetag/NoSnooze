//
//  AlarmTableViewCell.swift
//  NoSnooze
//
//  Created by Sanjay Sagar on 12/10/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var AlarmText: UILabel!
    @IBOutlet weak var CutoffTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
