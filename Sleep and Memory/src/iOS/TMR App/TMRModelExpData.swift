//
//  ExpDataScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//To enter numOfcolumns, Sample Size, Distance Error Threshold

import Foundation
import SpriteKit

class TMRModelExpData:TMRModel{
    
    var colNumField = UITextField()
    var sampleSizeField = UITextField()
    var errorThreshold = UITextField()
    var nextt = SKSpriteNode()
    var prev = SKSpriteNode()
    var x = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 1, text: "TMR Session General Data", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        x = SKSpriteNode(imageName: "quit", ySize: screen.frame.height/6-10, anchorPoint: CGPoint(x:0,y:1), position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 3, alpha: 1)
        x.name = "quit"
        screen.addChild(x)
        
        sampleSizeField = UITextField(text: "", placeholder: "Total Sounds (default 48)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/4, y: view.frame.height*0.3, width: screen.frame.width/3, height: screen.frame.width/20))
        sampleSizeField.center = CGPoint(x:view.frame.width/4, y: view.frame.height*0.3)
        view.addSubview(sampleSizeField)
        
        colNumField = UITextField(text: "", placeholder: "# Grid Columns (default 10)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width*0.75, y: view.frame.height*0.3, width: screen.frame.width/3, height: screen.frame.width/20))
        colNumField.center = CGPoint(x:view.frame.width*0.75, y: view.frame.height*0.3)
        view.addSubview(colNumField)
        
        errorThreshold = UITextField(text: "", placeholder: "Integer Error Threshold in % screen width (default 15)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/2, y: view.frame.height*0.42, width: screen.frame.width/1.3, height: screen.frame.width/20))
        errorThreshold.center = CGPoint(x:view.frame.width/2, y: view.frame.height*0.42)
        view.addSubview(errorThreshold)
        
        if context.project.getSetupPassed()[1]==1{
            sampleSizeField.text = String(context.project.getGuiSetting().getSampleSize())
            colNumField.text = String(context.project.getGuiSetting().getNumColumns())
            errorThreshold.text = String(context.project.getGuiSetting().getDistanceThreshold())
        }
        
        nextt = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2+screen.frame.height/14+10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(nextt)
        
        prev = SKSpriteNode(imageName: "PrevIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2-screen.frame.height/14-10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(prev)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if x.contains(position){
            sampleSizeField.removeFromSuperview()
            colNumField.removeFromSuperview()
            errorThreshold.removeFromSuperview()
            context.reset()
            if context.project.getSetupPassed()[7] == 1{
                context.project = context.baseProjectCopy
            }
            
            if context.project.getSetupPassed()[7] != 1{
                context.userAccount.setID(ID: context.userAccount.getID()-1)
                context.project.setSetupPassed(array: [0,0,0,0,0,0,0,0])
            }
            context.nextModel = .Home
        }
        if prev.contains(position){
            sampleSizeField.removeFromSuperview()
            colNumField.removeFromSuperview()
            errorThreshold.removeFromSuperview()
            context.nextModel = .MetaData
        }
        if nextt.contains(position){
            var array = context.project.getSetupPassed()
            array[1] = 1
            context.project.setSetupPassed(array:array)
            if let p = colNumField.text{
                if let col = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setNumColumns(numOfColumns: col)
                    let row = (Double(col)*0.6)
                    setting.setNumRows(numOfRows: Int(row.rounded()))
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setNumColumns(numOfColumns: 10)
                    setting.setNumRows(numOfRows: 6)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setNumColumns(numOfColumns: 10)
                setting.setNumRows(numOfRows: 6)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            if let p = sampleSizeField.text{
                if let size = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setSampleSize(sampleSize: size)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setSampleSize(sampleSize: 48)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setSampleSize(sampleSize: 48)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            if let p = errorThreshold.text{
                if let error = Int(p){
                    let setting = context.project.getGuiSetting()
                    setting.setDistanceThreshold(threshold: error)
                    context.project.setGuiSetting(guiSetting: setting)
                }else{
                    let setting = context.project.getGuiSetting()
                    setting.setDistanceThreshold(threshold: 15)
                    context.project.setGuiSetting(guiSetting: setting)
                }
            }else{
                let setting = context.project.getGuiSetting()
                setting.setDistanceThreshold(threshold: 15)
                context.project.setGuiSetting(guiSetting: setting)
            }
            
            colNumField.removeFromSuperview()
            sampleSizeField.removeFromSuperview()
            errorThreshold.removeFromSuperview()
            
            context.nextModel = .TimingData
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
