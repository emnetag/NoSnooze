//
//  FBFriendTableViewCell.swift
//  NoSnooze
//
//  Created by user on 12/15/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FBFriendTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var FriendProfImage: UIImageView!
    
    @IBOutlet weak var FriendName: UILabel!
    
    func loadUserData(facebookFriend: NSDictionary) {
        
        let userID = facebookFriend["id"] as! String
        let userName = facebookFriend["name"] as! String
        
        let urlString = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=normal")

        if let data = NSData(contentsOfURL: urlString!) {
            self.FriendProfImage!.image = UIImage(data: data)
        }
        
        self.FriendName!.text = userName
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
