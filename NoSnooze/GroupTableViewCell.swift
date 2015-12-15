//
//  GroupTableViewCell.swift
//  NoSnooze
//
//  Created by Teddy Pappas on 12/14/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var chatName: UILabel!
}