//
//  TMRModel.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

class TMRModel:SKScene {
    func begin(screen : TMRScreen, context : TMRContext) {
        screen.timerInterval(interval: 0)
    }
    
    func begin(screen : TMRScreen, context : TMRContext, view:SKView) {
        screen.timerInterval(interval: 0)
    }
    
    func timerTick(screen : TMRScreen, context : TMRContext) {
    }
    
    func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
    }
    
    func touchEnd(screen : TMRScreen, context:TMRContext, position: CGPoint) {
    }

    func end(screen : TMRScreen, context : TMRContext){
    }
}
