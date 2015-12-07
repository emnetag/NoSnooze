//
//  Alarm.swift
//  NoSnooze
//
//  Created by user on 12/6/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import Foundation
import Firebase

struct Alarm {
    
    let alarmTime: NSDate!
    let cutoffTime: NSDate!
    let snoozesAllowed: Int!
    let addedByUser: String!
    let ref: Firebase?
    let name: String!
    
    init(alarmTime: NSDate?, userID: String, name: String, snoozesAllowed: Int = 0, cutoffTime: NSDate) {
        self.name = name
        self.alarmTime = alarmTime
        self.addedByUser = userID
        self.snoozesAllowed = snoozesAllowed
        self.cutoffTime = cutoffTime
        self.ref = nil
    }

    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "alarmTime": alarmTime,
            "cutoffTime": cutoffTime,
            "snoozesAllowed": snoozesAllowed
        ]
    }
    
}