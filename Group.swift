//
//  Group.swift
//  NoSnooze
//
//  Created by Teddy Pappas on 12/14/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import Foundation
import Firebase

struct Group {
    var name: String!
    var members: [String]
    
    
    init(name: String!, members: [String]) {
        self.name = name
        self.members = members
    }
}