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
    var nextt = SKSpriteNode()
    var prev = SKSpriteNode()
    var x = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Choose % Sample Size to be Randomly Cued", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        x = SKSpriteNode(imageName: "quit", ySize: screen.frame.height/6-10, anchorPoint: CGPoint(x:0,y:1), position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 3, alpha: 1)
        x.name = "quit"
        screen.addChild(x)
        
        field = UITextField(text: "", placeholder: "% Sounds to be Cued 0-100 (default: 50)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/2, y: view.frame.height*0.3, width: screen.frame.width/2, height: screen.frame.width/20))
        field.center = CGPoint(x:view.frame.width/2, y: view.frame.height*0.3)
        view.addSubview(field)
        
        nextt = SKSpriteNode(imageName: "done", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2+screen.frame.height/14+10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(nextt)
        
        prev = SKSpriteNode(imageName: "PrevIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2-screen.frame.height/14-10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(prev)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if x.contains(position){
            field.removeFromSuperview()
            context.reset()
            if context.project.getSetupPassed()[7] != 1{
                context.project.setSetupPassed(array: [0,0,0,0,0,0,0,0])
                context.userAccount.setID(ID: context.userAccount.getID()-1)

            }
            if context.project.getSetupPassed()[7] == 1{
                context.project = context.baseProjectCopy
            }
            context.nextModel = .Home
        }
        if prev.contains(position){
            field.removeFromSuperview()
            context.nextModel = .CueingSetup
        }
        if nextt.contains(position){
            var array = context.project.getSetupPassed()
            array[5] = 1
            context.project.setSetupPassed(array:array)
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
            
            setAll(screen:screen,context:context)
            
            context.nextModel = .Settings
        }
    }
    
    func setAll(screen:TMRScreen,context:TMRContext){
        let settings = context.project.getGuiSetting()
        let resource = context.project.getTMRResource()
        
        // create training list, randomly generated now
        let trainingList = RandomNumberGenerator.generateRandomNumbers(
            range: resource.getNumberOfResourceEntries(),
            sampleSize: settings.getSampleSize())
        
        // set this list back to project
        context.project.setResourceIndexEntries(resourceIndexEntries: trainingList)
        context.setResourceIndexList(resourceIndexList: trainingList)
        //print("after set trainingList")
        
        // create position list
        let posList = RandomNumberGenerator.generateRandomPositions(
            rangeX: (Int(screen.imgSize/2),Int(screen.width-screen.imgSize)),
            rangeY: (Int(screen.imgSize/2),Int(screen.height-screen.imgSize)),
            sampleSize: settings.getSampleSize())
        //print("posList \(posList)")
        
        // set position list to project
        for (idx,(x,y)) in zip(trainingList,posList) {
            context.project.setPosition(resourceIndex: idx, posX: x, posY: y)
        }
        //print("after set posList")
        
        // create target list
        let sampleSize = Int(round(Double(settings.getSampleSize()*settings.getCuedPercent())/100.0))
        let targetIndexList = RandomNumberGenerator.generateRandomNumbers(
            range: trainingList.count,
            sampleSize: sampleSize)
        
        // set target list to project
        var targetList = [Int]();
        for i in 0..<targetIndexList.count {
            targetList.append(trainingList[targetIndexList[i]])
        }
        context.project.setTargetIndexEntries(resourceIndexEntries: targetList)
    }
    
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
