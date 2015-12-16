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
    let name: String!
    let active: Bool!
    let minFriends: Int!

    var storageFormat: Bool!
    
    let alarmTime: NSDate!
    let cutoffTime: NSDate!

    var alarmString: String!
    var cutoffString: String!
    
    let addedByUser: String!
    
    let ref: Firebase?
    let dateFormatter = NSDateFormatter()
    
    var members: [String]?
    
    init(alarmTime: NSDate, userID: String, name: String, cutoffTime: NSDate, members: [String]?, minFriends: Int, key: String = "") {
        self.key = key
        self.name = name
        self.alarmTime = alarmTime
        self.addedByUser = userID
        self.cutoffTime = cutoffTime
        self.ref = nil
        self.active = false
        self.storageFormat = true
        self.minFriends = minFriends
        self.dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        self.alarmString = dateFormatter.stringFromDate(alarmTime)
        self.cutoffString = dateFormatter.stringFromDate(cutoffTime)
        self.members = members
    }
    
    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        name = snapshot.value["name"] as! String
        addedByUser = snapshot.value["addedByUser"] as! String
        active = snapshot.value["active"] as! Bool
        minFriends = snapshot.value["minFriends"] as! Int
        alarmString = snapshot.value["alarmTime"] as! String
        cutoffString = snapshot.value["cutoffTime"] as! String
        
        self.dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        alarmTime = dateFormatter.dateFromString(self.alarmString)
        cutoffTime = dateFormatter.dateFromString(self.cutoffString)
        self.storageFormat = true
        members = snapshot.value["members"] as? Array
    }
    
        
    mutating func toDisplayFormat() -> Void {
        self.dateFormatter.dateFormat = "EEE, MMM dd"
        let dateShort = dateFormatter.stringFromDate(alarmTime)
        
        self.dateFormatter.dateFormat = "HH:mm a"
        self.dateFormatter.timeStyle = .ShortStyle
        
        let time = dateFormatter.stringFromDate(alarmTime)
        self.alarmString = "\(time) on \(dateShort)"
        
        self.cutoffString = dateFormatter.stringFromDate(cutoffTime)
        self.storageFormat = false
    }
    
    mutating func toStorageFormat() -> Void {
        self.dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        self.dateFormatter.timeStyle = .NoStyle
        self.alarmString = dateFormatter.stringFromDate(alarmTime)
        self.cutoffString = dateFormatter.stringFromDate(cutoffTime)
        self.storageFormat = true
    }
    
    mutating func toAnyObject() -> AnyObject {
        return [
            "members": members as! AnyObject,
            "alarmTime": alarmString,
            "cutoffTime": cutoffString,
            "active": active,
            "minFriends": minFriends,
            "name": name,
            "addedByUser": addedByUser
        ]
    }
    
}