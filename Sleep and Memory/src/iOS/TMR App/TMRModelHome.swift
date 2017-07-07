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
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        print("model home begin")
        screen.clearScreen()
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        let label = SKLabelNode(position: CGPoint(x:screen.width/2,y:screen.height/2), zPosition: 1, text: "Click For New Project", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "homeLabel"
        screen.addChild(label)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model home tick")
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        context.nextModel = .MetaData
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model home end")
    }
}
