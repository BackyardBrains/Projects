//
//  TimingDataScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//To enter Timing Intervals

import Foundation
import SpriteKit

class TMRModelTimingData:TMRModel{
    
    var training = UITextField()
    var trainingStop = UITextField()
    var testing = UITextField()
    var cueing = UITextField()
    
    var next = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "TMR Session Times (seconds)", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        training = UITextField(text: "", placeholder: "Training Display Time (default 3)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/4, y: view.frame.height*0.3, width: screen.frame.width/2.2, height: screen.frame.width/20))
        training.center = CGPoint(x:view.frame.width/4, y: view.frame.height*0.3)
        view.addSubview(training)
        
        trainingStop = UITextField(text: "", placeholder: "Between Training Images (default 1)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width*0.75, y: view.frame.height*0.3, width: screen.frame.width/2.2, height: screen.frame.width/20))
        trainingStop.center = CGPoint(x:view.frame.width*0.75, y: view.frame.height*0.3)
        view.addSubview(trainingStop)
        
        testing = UITextField(text: "", placeholder: "Test Feedback Time (default 3)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/4, y: view.frame.height*0.42, width: screen.frame.width/2.2, height: screen.frame.width/20))
        testing.center = CGPoint(x:view.frame.width/4, y: view.frame.height*0.42)
        view.addSubview(testing)
        
        cueing = UITextField(text: "", placeholder: "Time Between Cued Sounds (default 5)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width*0.75, y: view.frame.height*0.42, width: screen.frame.width/2.2, height: screen.frame.width/20))
        cueing.center = CGPoint(x:view.frame.width*0.75, y: view.frame.height*0.42)
        view.addSubview(cueing)
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if next.contains(position){//3135
            if let p = training.text{
                if let t = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setTrainingInterval(trainingInterval: t)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setTrainingInterval(trainingInterval: 3)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setTrainingInterval(trainingInterval: 3)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            if let p = trainingStop.text{
                if let t = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setInterTrainingInterval(interTrainingInterval: t)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setInterTrainingInterval(interTrainingInterval: 1)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setInterTrainingInterval(interTrainingInterval: 1)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            if let p = testing.text{
                if let t = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setTestingInterval(testingInterval: t)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setTestingInterval(testingInterval: 3)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setTestingInterval(testingInterval: 3)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            if let p = cueing.text{
                if let t = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setSleepInterval(sleepSoundInterval: t)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setSleepInterval(sleepSoundInterval: 5)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setSleepInterval(sleepSoundInterval: 5)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            training.removeFromSuperview()
            trainingStop.removeFromSuperview()
            testing.removeFromSuperview()
            cueing.removeFromSuperview()
            context.nextModel = .ExpOptions
            
            print(context.project.getGuiSetting().getTrainingInterval())
            print(context.project.getGuiSetting().getInterTrainingInterval())
            print(context.project.getGuiSetting().getTestingInterval())
            print(context.project.getGuiSetting().getSleepInterval())
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
