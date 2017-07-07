//
//  TMRModelControl.swift
//  TMR App
//
//  Created by Robert Zhang on 7/7/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TMRModelControl : TMRModel {
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        super.begin(screen: screen, context: context)
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
