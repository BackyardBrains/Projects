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
        
        let label = SKLabelNode(position: CGPoint(x:screen.width/2,y:screen.height/2), zPosition: 1, text: "load testing data...", fontColor: UIColor(red:170/255,green:177/255,blue:190/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(label)
        screen.timerInterval(interval: 0.0)
        dbLoad(screen: screen, context: context)
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
        // save user to file
        let userName = context.userAccount.getUserName()
        UserAccountFactory.save(name: userName, user: context.userAccount.getUserAccountTuple())
        
        // save project to file
        let projName = context.project.getTMRProjectName()
        TMRProjectFactory.save(name: projName, proj: context.project.getTMRProjectTuple())
    }
    
    func dbLoad(screen : TMRScreen, context: TMRContext){

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
}
