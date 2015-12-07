//
//  User.swift
//  NoSnooze
//
//  Created by user on 12/2/15.
//  Copyright © 2015 emnetg. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var uid: String!
    var displayName: String!
    

    init(authData: FAuthData) {
        self.uid = authData.uid
        self.displayName = authData.providerData["displayName"] as! String
    }
}