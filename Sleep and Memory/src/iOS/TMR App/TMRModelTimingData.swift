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
    var prev = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "TMR Session Times (seconds)", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
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
        
        if context.setupPassed[2]{
            training.text = String(context.project.getGuiSetting().getTrainingInterval())
            trainingStop.text = String(context.project.getGuiSetting().getInterTrainingInterval())
            testing.text = String(context.project.getGuiSetting().getTestingInterval())
            cueing.text = String(context.project.getGuiSetting().getSleepInterval())
        }
        
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2+screen.frame.height/14+10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)
        
        prev = SKSpriteNode(imageName: "PrevIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2-screen.frame.height/14-10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(prev)
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if prev.contains(position){
            training.removeFromSuperview()
            trainingStop.removeFromSuperview()
            testing.removeFromSuperview()
            cueing.removeFromSuperview()
            context.nextModel = .ExpData
        }
        if next.contains(position){//3135
            context.setupPassed[2] = true
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
