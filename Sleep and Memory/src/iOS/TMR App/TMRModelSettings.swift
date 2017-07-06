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
    
    override func begin(screen : TMRScreen, context : TMRContext) {
        print("model Settings begin")
        screen.clearScreen()
        screen.addLabel(text: "load testing data...", position: CGPoint(x:screen.width/2,y:screen.height/2),
                        name: "settings")
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
        context.userAccount = UserAccountFactory.createUserAccount(userName: "Robert", password: "")
        context.project = TMRProjectFactory.getTMRProject(userAccount : context.userAccount)

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
        let targetIndexList = RandomNumberGenerator.generateRandomNumbers(
            range: trainingList.count,
            sampleSize: settings.getSampleSize()/2)
        
        // set target list to project
        var targetList = [Int]();
        for i in 0..<targetIndexList.count {
            targetList.append(trainingList[targetIndexList[i]])
        }
        context.project.setTargetIndexEntries(resourceIndexEntries: targetList)
    }
}
