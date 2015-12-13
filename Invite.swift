//
//  Invite.swift
//  NoSnooze
//
//  Created by user on 12/12/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import Foundation
import Firebase

struct Invite {
    var userID: String!
    
    var participating: Bool!
    var inviteID: String!
    var alarmID: String!

    init(userID: String, alarmID: String) {
        self.userID = userID
        self.alarmID = alarmID
        self.participating = false
    }
    
    init(snapshot: FDataSnapshot) {
        inviteID = snapshot.value["inviteID"] as! String
        userID = snapshot.value["userID"] as! String
        alarmID = snapshot.value["alarmID"] as! String
        participating = snapshot.value["participating"] as! Bool
    }
}