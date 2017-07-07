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
    var buttonA = SKSpriteNode()
    var buttonM = SKSpriteNode()
    
    var next = SKSpriteNode()
    
    var isASelected = false
    var isMSelected = false
    
    var currentMode = 0 //0 - default, 1 - auto, 2 - manual
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "Methods For Selecting Cued Sounds", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        automatic = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*2/3), zPosition: 2, text: "Randomly Select (default)", fontColor: .lightText, fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        automatic.name = "label"
        screen.addChild(automatic)
        
        buttonA = SKSpriteNode(color: .darkGray, width: automatic.frame.width+20, height: automatic.frame.height+20, anchorPoint: CGPoint(x:0.5,y:0.5), position: automatic.position, zPosition: 1, alpha: 1)
        buttonA.name = "button"
        screen.addChild(buttonA)
        
        manual = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:buttonA.position.y-buttonA.size.height/2-40), zPosition: 2, text: "Manually Select", fontColor: .lightText, fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        manual.name = "label"
        screen.addChild(manual)
        
        buttonM = SKSpriteNode(color: .darkGray, width: automatic.frame.width+20, height: manual.frame.height+20, anchorPoint: CGPoint(x:0.5,y:0.5), position: manual.position, zPosition: 1, alpha: 1)
        buttonM.name = "button"
        screen.addChild(buttonM)
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if buttonA.contains(position){
            if isASelected{
                automatic.fontColor = .lightText
                buttonA.color = .darkGray
                currentMode = 0
                isASelected = false
            }else{
                for child in screen.children{
                    if child.name == "button"{
                        let c = child as! SKSpriteNode
                        c.color = .darkGray
                    }
                    if child.name == "label"{
                        let c = child as! SKLabelNode
                        c.fontColor = .lightText
                    }
                }
                isMSelected = false
                automatic.fontColor = .black
                buttonA.color = .white
                currentMode = 1
                isASelected = true
            }
            
        }
        if buttonM.contains(position){
            if isMSelected{
                manual.fontColor = .lightText
                buttonM.color = .darkGray
                currentMode = 0
                isMSelected = false
            }else{
                for child in screen.children{
                    if child.name == "button"{
                        let c = child as! SKSpriteNode
                        c.color = .darkGray
                    }
                    if child.name == "label"{
                        let c = child as! SKLabelNode
                        c.fontColor = .lightText
                    }
                }
                isASelected = false
                manual.fontColor = .black
                buttonM.color = .white
                currentMode = 2
                isMSelected = true
            }
            
        }
        if next.contains(position){
            if currentMode != 0{
                if currentMode == 1{
                    context.nextModel = .CueingSetupAuto
                }
                if currentMode == 2{
                    //context.nextModel = .CueingSetupManual
                }
            }else{
                context.nextModel = .CueingSetupAuto
            }
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
