//
//  TMRModelSettings.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit


class TMRModelSettings : TMRModel  {
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        print("model Settings begin")
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        let label = SKLabelNode(position: CGPoint(x:screen.width/2,y:screen.height/2), zPosition: 1, text: "load testing data...", fontColor: UIColor(red:170/255,green:177/255,blue:190/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(label)
        screen.timerInterval(interval: 0.0)
        dbLoad(context: context)
        screen.timerInterval(interval: 0.5) // trig callback for model transition
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model Settings tick")
        context.nextModel = .Training
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        print("model Settings touch")
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model Settings end")
    }
    
    func dbLoad(context: TMRContext){

        let settings = context.project.getGuiSetting()
        let resource = context.project.getTMRResource()
        
        // create training list, randomly generated now
        let trainingList = RandomNumberGenerator.generateRandomNumbers(
            range: resource.getNumberOfResourceEntries(),
            sampleSize: settings.getSampleSize())
        //print("trainingList \(trainingList)")
        
        // set this list back to project
        context.project.setResourceIndexEntries(resourceIndexEntries: trainingList)
        context.setResourceIndexList(resourceIndexList: trainingList)
        //print("after set trainingList")
        
        // create position list
        let posList = RandomNumberGenerator.generateRandomPositions(
            rangeX: settings.getNumColumns(),
            rangeY: settings.getNumRows(),
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
}
