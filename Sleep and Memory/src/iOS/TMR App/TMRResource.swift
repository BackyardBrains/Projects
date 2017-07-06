//
//  TMRResource.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

protocol TMRResource : NSCopying{
    func getResourceName() -> String
    func getNumberOfResourceEntries() -> Int
    func getAllResources()
    func getPictureName(index : Int) -> String
    func getSoundName(index : Int) -> String
    func getAudioURL(index : Int) -> URL?
    func getNickName(index : Int) -> String
    func getUnSelectedResourceIndexEntries(selectedResourceIndexEntries : [Int]) -> [Int]
}
