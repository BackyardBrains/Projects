//
//  TMRModelTraining.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

class TMRModelTraining : TMRModel {
    var index : Int = 0
    var isWaiting = false
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        print("model training begin")
        super.begin(screen: screen, context: context)
        let settings = context.project.getGuiSetting()
        
        screen.clearScreen()
        screen.addLabel(text: "Remember the Image Positions",
                        position: CGPoint(x:screen.width/2,y:screen.height/2+15),
                        name: "trainingRemind")
        screen.addLabel(text: "Do Not Tap the Screen", position: CGPoint(x:screen.width/2,y:screen.height/2-30), name: "trainingRemind",fontSize:30)
        
        context.project.setBeginTime(beginTime: Date())
        screen.addGrid()
        screen.timerInterval(interval: Double(context.project.getGuiSetting().getTrainingInterval()))
        context.curIdx = 0
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model training tick: \(context.curIdx)")
        screen.clearNode("trainingRemind")
        if context.curIdx >= context.project.getNumOfEntries() {
            context.nextModel = .Testing
            return
        }
        // show image
        if isWaiting{
            print("hi")
            screen.clearNode("image")
            isWaiting = false
            screen.timerInterval(interval: Double(context.project.getGuiSetting().getInterTrainingInterval()), repeats : false)
        }
        else{
            isWaiting = true
            let resIndex = context.getResourceIndexList()[context.curIdx]
            let picture = context.project.getPictureName(resourceIndex: resIndex)
            let sound = context.project.getAudioUrl(resourceIndex: resIndex)
            let (x,y) = context.project.getPosition(resourceIndex: resIndex)
            screen.showImage(path: picture, position: CGPoint(x:x,y:y), sound: sound!)
            context.curIdx = context.curIdx + 1
            screen.timerInterval(interval: Double(context.project.getGuiSetting().getTrainingInterval()), repeats : false)
        }
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        print("model training touch")
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model training end")
        screen.clearScreen()
        screen.showText(text: "Learning Complete")
    }
}
