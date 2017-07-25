//
//  StringExtension.swift
//  TMR App
//
//  Created by Robert Zhang on 7/25/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
}
