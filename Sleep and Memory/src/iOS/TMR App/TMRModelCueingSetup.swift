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
    var prev = SKSpriteNode()
    
    var isASelected = false
    var isMSelected = false
    
    var currentMode = 0 //0 - default, 1 - auto, 2 - manual
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "Methods For Selecting Cued Sounds", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
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
        
        if context.setupPassed[4]{
            if context.isAuto{
                isASelected = true
                automatic.fontColor = .black
                buttonA.color = .white
                currentMode = 1
            }else if !context.isAuto{
                isMSelected = true
                manual.fontColor = .black
                buttonM.color = .white
                currentMode = 2
            }
        }
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2+screen.frame.height/14+10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)
        
        prev = SKSpriteNode(imageName: "PrevIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2-screen.frame.height/14-10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(prev)
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
        
        
        if prev.contains(position){
            context.nextModel = .ExpOptions
        }
        if next.contains(position){
            context.setupPassed[4] = true
            if currentMode != 0{
                if currentMode == 1{
                    context.isAuto = true
                    context.nextModel = .CueingSetupAuto
                }
                if currentMode == 2{
                    //context.isAuto = false
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
