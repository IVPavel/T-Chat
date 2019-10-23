//
//  Message.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 22.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let toIdUser: String
    let fromIdUser: String
    let date: Double
    let textMessage: String
    
    init(snapshot: DataSnapshot) {
        let snaphotValue = snapshot.value as! [String : AnyObject]
        toIdUser = snaphotValue["toIdUser"] as! String
        fromIdUser = snaphotValue["fromIdUser"] as! String
        date = snaphotValue["dateSend"] as! Double
        textMessage =  snaphotValue["textMessage"] as! String
    }
}
