//
//  ExperimentOptionsScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//to choose cueing options (w/ cueing, no cueing, control, etc...)

import Foundation
import SpriteKit

class TMRModelExpOptions:TMRModel{
    
    var treatment1 = SKLabelNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "Treatment Options", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        treatment1 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, text: "Sleep with Cueing", fontColor: UIColor(red:209/255,green:154/255,blue:102/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(treatment1)
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if treatment1.contains(position){
            let setting = context.project.getGuiSetting()
            setting.setTreatmentNum(num: 1)
            context.project.setGuiSetting(guiSetting: setting)
            context.nextModel = .CueingSetup
            
            print(context.project.getGuiSetting().getTreatmentNum())
            
        }
        //more will add as more treatments implemented
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
