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
    
    let key: String!
    let alarmTime: String!
    let cutoffTime: String!
    let addedByUser: String!
    let ref: Firebase?
    let name: String!
    let active: Bool!
    let members: [User]!
    
    init(alarmTime: String, userID: String, name: String, cutoffTime: String, members: [User]?, key: String = "") {
        self.key = key
        self.name = name
        self.alarmTime = alarmTime
        self.addedByUser = userID
        self.cutoffTime = cutoffTime
        self.ref = nil
        self.active = false;
        self.members = members
    }

    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        name = snapshot.value["name"] as! String
        addedByUser = snapshot.value["addedByUser"] as! String
        active = snapshot.value["active"] as! Bool
        alarmTime = snapshot.value["alarmTime"] as! String
        cutoffTime = snapshot.value["cutoffTime"] as! String
        members = snapshot.value["members"] as! Array
    }
    
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "alarmTime": alarmTime,
            "cutoffTime": cutoffTime,
            "active": active,
            "members": members as! AnyObject
        ]
    }
    
}