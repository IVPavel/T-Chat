//
//  User.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 21.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation
import Firebase

struct UserProfile {
    let id: String
    let imageProfile: String
    let email: String
    let username: String
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        imageProfile = snapshotValue["imageProfile"] as! String
        email = snapshotValue["email"] as! String
        username = snapshotValue["username"] as! String
        id = snapshot.key
    }
}
