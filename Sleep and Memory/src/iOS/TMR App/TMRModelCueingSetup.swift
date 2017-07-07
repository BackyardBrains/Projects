//
//  CueingSetupScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//to choose automatic or manual cueing choice

import Foundation
import SpriteKit

class TMRModelCueingSetup:TMRModel{
    
    var automatic = SKLabelNode()
    var manual = SKLabelNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "Cueing Selection Options", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        automatic = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.6), zPosition: 1, text: "Automatically Select Cued Sounds", fontColor: UIColor(red:209/255,green:154/255,blue:102/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(automatic)
        
        manual = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.4), zPosition: 1, text: "Manually Select Cued Sounds", fontColor: UIColor(red:209/255,green:154/255,blue:102/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(manual)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if automatic.contains(position){
            context.nextModel = .CueingSetupAuto
        }
        if manual.contains(position){
            //context.nextModel = .CueingSetupManual
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
