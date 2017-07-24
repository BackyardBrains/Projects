//
//  Beautify.swift
//  TMR App
//
//  Created by Robert Zhang on 6/30/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
extension NSDictionary {
    var beautify: String {
        get {
            var v = ""
            for (key, value) in self {
                v += ("\(key) : \(value)\n")
            }
            return v
        }
    }
}
