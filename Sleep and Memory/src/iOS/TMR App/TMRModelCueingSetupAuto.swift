//
//  CueingSetupScreen2.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//to choose 25%, 50%, 75%, 100% to be targeted

import Foundation
import SpriteKit

class TMRModelCueingSetupAuto:TMRModel{
    
    var field = UITextField()
    var next = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Choose % Sample Size to be Cued", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        field = UITextField(text: "", placeholder: "% Sounds to be Cued 0-100 (default: 50)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/2, y: view.frame.height*0.3, width: screen.frame.width/2, height: screen.frame.width/20))
        field.center = CGPoint(x:view.frame.width/2, y: view.frame.height*0.3)
        view.addSubview(field)
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if next.contains(position){
            if let text = field.text{
                if let num = Int(text){
                    if num >= 0 && num <= 100{
                        let setting = context.project.getGuiSetting()
                        setting.setCuedPercent(num:num)
                        context.project.setGuiSetting(guiSetting: setting)
                    }else{
                        let setting = context.project.getGuiSetting()
                        setting.setCuedPercent(num:50)
                        context.project.setGuiSetting(guiSetting: setting)
                    }
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setCuedPercent(num:50)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setCuedPercent(num:50)
                context.project.setGuiSetting(guiSetting: setting)
            }
            field.removeFromSuperview()
            context.nextModel = .Settings
            print(context.project.getGuiSetting().getCuedPercent())
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
