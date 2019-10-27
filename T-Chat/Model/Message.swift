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
    let typeMessage: String
    let toIdUser: String
    let fromIdUser: String
    let date: Double
    let message: String
    
    init(typeMessage: String, toIdUser: String, fromIdUser: String, date: Double, message: String) {
        self.typeMessage = typeMessage
        self.toIdUser = toIdUser
        self.fromIdUser = fromIdUser
        self.date = date
        self.message = message
    }
    
    init(snapshot: DataSnapshot) {
        let snaphotValue = snapshot.value as! [String : AnyObject]
        typeMessage = snaphotValue["typeMessage"] as! String
        toIdUser = snaphotValue["toIdUser"] as! String
        fromIdUser = snaphotValue["fromIdUser"] as! String
        date = snaphotValue["dateSend"] as! Double
        message = snaphotValue["message"] as! String
    }
    
    func convertToDictionary() -> Any {
        return ["typeMessage" : typeMessage, "toIdUser" : toIdUser, "fromIdUser" : fromIdUser, "dateSend" : date, "message" : message]
    }
}
