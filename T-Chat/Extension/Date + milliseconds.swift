//
//  Date + milliseconds.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 23.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
