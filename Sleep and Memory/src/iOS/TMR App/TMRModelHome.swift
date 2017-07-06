//
//  TMRModelHome.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit


class TMRModelHome : TMRModel  {
    
    override func begin(screen : TMRScreen, context : TMRContext) {
        print("model home begin")
        screen.clearScreen()
        screen.addLabel(text: "Click for New Project", position: CGPoint(x:screen.width/2,y:screen.height/2),
                        name: "homeLabel")
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model home tick")
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        context.nextModel = .Settings
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model home end")
    }
}
