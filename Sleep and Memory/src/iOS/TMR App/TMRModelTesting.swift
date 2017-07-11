//
//  TMRModelTesting.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

// type: .Testing, .Testing2, .PreNapTest:
class TMRModelTesting : TMRModel {
    var touchEnable : Bool = true
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        print("model \(getName(modelType: context.currentModel, repeatTime: context.repeatCnt)) begin")
        super.begin(screen: screen, context: context)
        
        
                //let settings = context.project.getGuiSetting()
        //let resource = context.project.getTMRResource()
        screen.clearScreen()
        screen.addGrid()
        screen.addColor()
        
        // create training list
        var testingList = context.project.getResourceIndexEntries()
        testingList.shuffle();
        context.setResourceIndexList(resourceIndexList: testingList)
        
        context.curIdx = 0
        
        if ( context.currentModel == .Testing ) {
            screen.showText(text: "Pre-Treatment Test with Feedback Round \(context.repeatCnt+1)",fontSize:30, yPercent:90)
            screen.showText(text: "\(context.project.getGuiSetting().getSampleSize()) images will be presented to you at the center of the screen.", fontSize: 20, yPercent: 60)
            screen.showText(text: "Tap where you remember/think the original correct location was.", fontSize: 20, yPercent: 50)
            screen.showText(text: "Take as much time as you need. This task is not timed.", fontSize: 20, yPercent: 40)
            screen.showText(text: "Tap to Start", fontSize: 30, yPercent: 20)
        }
        else if ( context.currentModel == .PreNapTest){
            screen.showText(text: "Pre-Treatment Test with No Feedback",fontSize:30,yPercent:90)
            screen.showText(text: "\(context.project.getGuiSetting().getSampleSize()) images will be presented to you at the center of the screen.", fontSize: 20, yPercent: 65)
            screen.showText(text: "Tap where you remember/think the original correct location was.", fontSize: 20, yPercent: 55)
            screen.showText(text: "Take as much time as you need. This task is not timed.", fontSize: 20, yPercent: 45)
            screen.showText(text: "There is a slight delay between images - wait for the next image.", fontSize: 20, yPercent: 35)
            
            screen.showText(text: "Tap to Start", fontSize: 30, yPercent: 20)
        }
        else if ( context.currentModel == .Retest) {
            screen.showText(text: "Post-Treatment Test with No Feedback",fontSize:30,yPercent:90)
            screen.showText(text: "\(context.project.getGuiSetting().getSampleSize()) images will be presented to you at the center of the screen.", fontSize: 20, yPercent: 65)
            screen.showText(text: "Tap where you remember/think the original correct location was.", fontSize: 20, yPercent: 55)
            screen.showText(text: "Take as much time as you need. This task is not timed.", fontSize: 20, yPercent: 45)
            screen.showText(text: "There is a slight delay between images - wait for the next image.", fontSize: 20, yPercent: 35)
            screen.showText(text: "Tap to Start", fontSize: 30, yPercent: 20)
        }
        touchEnable = true
        screen.timerInterval(interval: 0)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model \(getName(modelType: context.currentModel, repeatTime: context.repeatCnt)) tick")
        
        if context.curIdx >= context.project.getNumOfEntries() {
            switch (context.currentModel){
            case .Testing:
                context.repeatCnt = context.repeatCnt + 1
                print("repeat:\(context.repeatCnt)")
                if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining() ) {
                    context.repeatCnt = 0
                    context.nextModel = .PreNapTest
                    context.project.setTimeEnd2(time: Date())
                    print("setEnd2Sleep")
                }
                else {
                    context.project.setTimeEnd1(time: Date())
                    context.nextModel = .Testing
                    print("setEnd1Sleep")
                }
            case .PreNapTest:
                context.nextModel = .PreNapResult
                context.project.setTimeEndBeforeSleep(time: Date())
                print("setEndBeforeSleep")
            case .Retest:
                context.nextModel = .Result
                context.project.setTimeEndAfterSleep(time: Date())
                print("setEndAfterSleep")
            default:
                print("Error: ModelTest: current type not handle")
            }
            return
        }

        let resIndex = context.getResourceIndexList()[context.curIdx]
    
        switch (context.currentModel){
        case .Testing:
            print("testing \(context.repeatCnt)")
            if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining()-1 ) {
                context.project.setTimeBegin2(resourceIndex: resIndex, time: Date())
                print("settimebegin2")
            }else{
                context.project.setTimeBegin1(resourceIndex: resIndex, time: Date())
                print("settimebegin1")
            }
        case .PreNapTest:
            context.project.setTimeBeginBeforeSleep(resourceIndex: resIndex, time: Date())
        case .Retest:
            context.project.setTimeBeginAfterSleep(resourceIndex: resIndex, time: Date())
        default:
            print("Error: ModelTest: current type not handle")
        }
            
        let picture = context.project.getPictureName(resourceIndex: resIndex)
        let sound = context.project.getAudioUrl(resourceIndex: resIndex)
        let pos = CGPoint(x: screen.width/2, y: screen.height/2)
        screen.clearScreen()
        screen.addGrid()
        screen.addColor()
        screen.showImage(path: picture, position: pos, sound: sound!)
        context.curIdx = context.curIdx + 1
        screen.timerInterval(interval: 0)
        touchEnable = true
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        print("model \(getName(modelType: context.currentModel, repeatTime: context.repeatCnt)) touch")
        
        if !touchEnable {
            return
        }
        
        if context.curIdx == 0{
            print("repeat:\(context.repeatCnt)")
            switch (context.currentModel){
            case .Testing:
                if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining()-1) {
                    context.project.setTimeStart2(time: Date())
                    print("setStart2Sleep")
                }
                else {
                    context.project.setTimeStart1(time: Date())
                    print("setStart1Sleep")
                }
            case .PreNapTest:
                context.project.setTimeStartBeforeSleep(time: Date())
                print("setStartBeforeSleep")
            case .Retest:
                context.project.setTimeStartAfterSleep(time: Date())
                print("setStartAfterSleep")
            default:
                print("Error: ModelTest: current type not handle")
            }
        }
        // show image
        if ( context.curIdx > 0 ) {
            let prevResIndex = context.getResourceIndexList()[context.curIdx - 1]
            let (prevX, prevY) = context.project.getPosition(resourceIndex: prevResIndex)
            let prevPicture = context.project.getPictureName(resourceIndex: prevResIndex)
            let prevSound = context.project.getAudioUrl(resourceIndex: prevResIndex)
            //GET DATE after
            let date = Date()
            var reactionTime:Float = 0.0
            switch (context.currentModel){
            case .Testing:
                if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining()-1) {
                    reactionTime = Float(date.nanoseconds(from: context.project.getTimeBegin2(resourceIndex: prevResIndex)))/1000000000.0
                    context.project.setReactionTime2(resourceIndex: prevResIndex, time: reactionTime)
                    context.project.setX2(resourceIndex: prevResIndex, x: Int(position.x))
                    context.project.setY2(resourceIndex: prevResIndex, y: Int(position.y))
                }else{
                    reactionTime = Float(date.nanoseconds(from: context.project.getTimeBegin1(resourceIndex: prevResIndex)))/1000000000.0
                    context.project.setReactionTime1(resourceIndex: prevResIndex, time: reactionTime)
                    context.project.setX1(resourceIndex: prevResIndex, x: Int(position.x))
                    context.project.setY1(resourceIndex: prevResIndex, y: Int(position.y))
                }
            case .PreNapTest:
                reactionTime = Float(date.nanoseconds(from: context.project.getTimeBeginBeforeSleep(resourceIndex: prevResIndex)))/1000000000.0
                context.project.setReactionTimeBeforeSleep(resourceIndex: prevResIndex, time: reactionTime)
                context.project.setXBeforeSleep(resourceIndex: prevResIndex, x: Int(position.x))
                context.project.setYBeforeSleep(resourceIndex: prevResIndex, y: Int(position.y))
            case .Retest:
                reactionTime = Float(date.nanoseconds(from: context.project.getTimeBeginAfterSleep(resourceIndex: prevResIndex)))/1000000000.0
                context.project.setReactionTimeAfterSleep(resourceIndex: prevResIndex, time: reactionTime)
                context.project.setXAfterSleep(resourceIndex: prevResIndex, x: Int(position.x))
                context.project.setYAfterSleep(resourceIndex: prevResIndex, y: Int(position.y))
            default:
                print("Error: ModelTest: current type not handle")
            }
            //
            screen.clearScreen()
            screen.addGrid()
            screen.addColor()
            if ( context.currentModel == .Testing ) {
                screen.showImage(path: prevPicture, position: CGPoint(x:prevX,y:prevY), sound: prevSound!)
            }
            let (touched,distance,percent,cm) = screen.isTouched(pos: position, x: prevX, y: prevY)
            if touched {
                if ( context.currentModel == .Testing) {
                    screen.showText(text: "Correct")
                }
                
                updateResult(context: context, resourceIndex: prevResIndex, result: true)
                updateDistance(context: context, resourceIndex: prevResIndex, distance: distance, distancePercent: percent, distanceCM: cm)
            }
            else {
                if ( context.currentModel == .Testing) {
                    screen.showText(text: "Incorrect - Correct Position Shown")
                }
                updateResult(context : context, resourceIndex: prevResIndex, result: false)
                updateDistance(context: context, resourceIndex: prevResIndex, distance: distance, distancePercent : percent, distanceCM: cm)
            }
            touchEnable = false
        }
        else{
            touchEnable = false
            screen.timerInterval(interval: 1,repeats: false)
            return
        }
        screen.timerInterval(interval: Double(context.project.getGuiSetting().getTestingInterval()), repeats : false)
        
        
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model \(getName(modelType: context.currentModel, repeatTime: context.repeatCnt)) end")
    }
    
    func updateResult(context:TMRContext, resourceIndex : Int, result : Bool ) {
        if  context.currentModel == .PreNapTest {
            context.project.setResultForTestBeforeSleep(resourceIndex: resourceIndex, result: result)
        }
        else if  context.currentModel == .Retest  {
            context.project.setResultForTestAfterSleep(resourceIndex: resourceIndex, result: result)
        }
        else if context.currentModel == .Testing{
            if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining()-1) {
                context.project.setIsCorrect2(resourceIndex: resourceIndex, correct: result)
            }else{
                context.project.setIsCorrect1(resourceIndex: resourceIndex, correct: result)
            }
        }
    }
    
    func updateDistance(context:TMRContext, resourceIndex : Int, distance :CGFloat, distancePercent: CGFloat, distanceCM: CGFloat) {
        if context.currentModel == .Testing{
            if ( context.repeatCnt == context.project.getGuiSetting().getRepeatTimesForTestAfterTraining()-1) {
                context.project.setDistance2(resourceIndex: resourceIndex, distance: Float(distance))
                context.project.setDistancePercent2(resourceIndex: resourceIndex, distancePercent: Float(distancePercent))
                context.project.setDistanceCM2(resourceIndex: resourceIndex, distanceCM: Float(distanceCM))
            }else{
                context.project.setDistance1(resourceIndex: resourceIndex, distance: Float(distance))
                context.project.setDistancePercent1(resourceIndex: resourceIndex, distancePercent: Float(distancePercent))
                context.project.setDistanceCM1(resourceIndex: resourceIndex, distanceCM: Float(distanceCM))
            }
        }
        if  context.currentModel == .PreNapTest {
            context.project.setDistanceBeforeSleep(resourceIndex: resourceIndex, distance: Float(distance))
            context.project.setDistancePercentBeforeSleep(resourceIndex: resourceIndex, distancePercent: Float(distancePercent))
            context.project.setDistanceCMBeforeSleep(resourceIndex: resourceIndex, distanceCM: Float(distanceCM))
        }
        else if  context.currentModel == .Retest  {
            context.project.setDistanceAfterSleep(resourceIndex: resourceIndex, distance: Float(distance))
            context.project.setDistancePercentAfterSleep(resourceIndex: resourceIndex, distancePercent: Float(distancePercent))
            context.project.setDistanceCMAfterSleep(resourceIndex: resourceIndex, distanceCM: Float(distanceCM))
        }
    }
    
    func getName(modelType : ModelType, repeatTime : Int) -> String {
        switch  ( modelType ) {
        case .Testing :
            return "TrainingTest\(repeatTime+1)"
        case .PreNapTest :
            return "PreNapTest"
        case .Retest :
            return "AfterNapTest"
        default:
            return "testing"
        }
    }
    
}
