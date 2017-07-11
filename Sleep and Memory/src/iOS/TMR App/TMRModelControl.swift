//
//  TMRModelControl.swift
//  TMR App
//
//  Created by Robert Zhang on 7/7/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

//Instructions -> Tap to Continue
//Gameplay -> Variable Time and isCueing
//Feedback for all

class TMRModelControl : TMRModel {
    var counter = 0
    var isShow = true
    var numCounter = 0
    var durationCounter = 0
    
    var numInterval = 0.4
    var spaceInterval = 0.9
    
    
    var numPair = [0,0]
    var bg = SKSpriteNode()
    
    var duration = 0
    var cueBeginTime = 0
    
    var numCorrect = 0
    var numCount = 0
    
    var isCueing = false
    
    var soundCounter = 0
    var soundCounter2 = 0
    
    var targeted:[Int] = []
    
    var player: AVAudioPlayer!
    
    var toplay:[URL] = []
    
    var hasTouched = false
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        super.begin(screen: screen, context: context)
        
        bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        //Duration setting
        //In order to ensure that there is always enough time to present all of the cueing, the duration is calculated as a sum of 3 parts: timeBeforeCueing, timeCueing (based on the sleep interval from settings), timeAfterCueing. If there are 50 total for example, tBC = 1 min 30 sec, tC = 4 min 10 sec, tAC = 1 min 50 sec, totaling 7.5 minutes
        
        cueBeginTime = Int(1.8*Double(context.project.getNumOfEntries())) //so 50 total (not targeted) is 1.5 minutes
        
        if context.controlModel == 1{
            duration = Int(2.4*Double(context.project.getNumOfEntries())) //so 50 total (not targeted) is 2 minutes
        }else if context.controlModel == 2{
            duration = cueBeginTime+context.project.getNumOfEntries()*context.project.getGuiSetting().getSleepInterval()+Int(2.2*Double(context.project.getNumOfEntries()))
        }else if context.controlModel == 3{
            duration = cueBeginTime+context.project.getNumOfEntries()*context.project.getGuiSetting().getSleepInterval()+Int(2.2*Double(context.project.getNumOfEntries())) //so 50 total (not targeted) is 7.5 minutes
        }else{
            duration = cueBeginTime+context.project.getNumOfEntries()*context.project.getGuiSetting().getSleepInterval()+Int(2.2*Double(context.project.getNumOfEntries()))
        }
        
        
        //Instructions -> Tap to continue
        var text1:String
        if context.controlModel == 1{
            text1 = "Practice Run"
        }else if context.controlModel == 2{
            text1 = "Run 1 without Cues"
        }else if context.controlModel == 3{
            text1 = "Run 2 with Cues"
        }else{
            text1 = "Run 3 without Cues"
        }
        
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.95), zPosition: 1, text: "\(text1) Instructions", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        title.name = "s"
        screen.addChild(title)
        
        let i1 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.8), zPosition: 1, text: "A number will first appear on the left and disappear.", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i1.name = "s"
        screen.addChild(i1)
        let i2 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.7), zPosition: 1, text: "A 2nd number will then appear on the right and disappear.", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i2.name = "s"
        screen.addChild(i2)
        let i3 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.6), zPosition: 1, text: "Once the 2nd number disappears, if the two numbers were", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i3.name = "s"
        screen.addChild(i3)
        let i4 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.5), zPosition: 1, text: "both even or both odd, immediately tap the screen.", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i4.name = "s"
        screen.addChild(i4)
        let i5 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.4), zPosition: 1, text: "If not, do not tap the screen and wait for the next pair.", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i5.name = "s"
        screen.addChild(i5)
        var i6 = SKLabelNode()
        if context.controlModel == 3{
            i6 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 1, text: "Sounds will play. Focus on the task and Ignore Them", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        }else{
            i6 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 1, text: "Try to Tap Correctly and Quickly. This is timed.", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        }
        i6.name = "s"
        screen.addChild(i6)
        let i7 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.15), zPosition: 1, text: "Tap to Play", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i7.name = "s"
        screen.addChild(i7)
        
        targeted = context.project.getTargetIndexEntries()
        targeted.shuffle()
        
        toplay = context.project.getBasedSoundsForTargeted()
        for num in 0..<targeted.count{
            let tSound = context.project.getAudioUrl(resourceIndex: targeted[num])!
            toplay.append(tSound)
        }
        toplay.shuffle()
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if counter == 0{
            screen.clearNode("s")
            let line = SKSpriteNode(color: .lightGray, width: 5, height: screen.frame.height, anchorPoint: CGPoint(x:0.5,y:0), position: CGPoint(x:screen.frame.width/2,y:0), zPosition: 1, alpha: 1)
            line.name = "g"
            screen.addChild(line)
            let num1 = SKLabelNode(position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 1, text: "Number 1", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .top, horizontalAlignmentMode: .left)
            num1.name = "g"
            screen.addChild(num1)
            let num2 = SKLabelNode(position: CGPoint(x:screen.frame.width/2+7,y:screen.frame.height-5), zPosition: 1, text: "Number 2", fontColor: .lightText, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .top, horizontalAlignmentMode: .left)
            num2.name = "g"
            screen.addChild(num2)
            screen.timerInterval(interval: 0.1, repeats: true)
            counter += 1
            context.project.setCueTimeBegin(time: Date())
        }else if counter == 1000000000{//gameover
            screen.clearNode("f")
            if context.controlModel == 4{
                context.nextModel = .Retest
                context.project.setCueTimeEnd(time: Date())
            }else{
                context.controlModel+=1
                context.nextModel = .Control
            }
        }
        else{
            if isShow && counter%2 == 1 && !hasTouched{
                if numPair[0]%2 == numPair[1]%2{//green
                    bg.color = UIColor(red: 0, green: 153/255, blue: 0, alpha: 1)
                    numCorrect+=1
                }else{
                    bg.color = UIColor(red: 153/255, green: 0, blue: 0, alpha: 1)
                }
                hasTouched = true
            }
        }
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        numCounter+=1
        durationCounter+=1
        soundCounter+=1
        let totalTime = 2*(Int(spaceInterval*10)+Int(numInterval*10))
        if numCounter==Int(spaceInterval*10) && counter%2 == 1{
            print("PASS")
            print(duration*10)
            print((numCount+1)*totalTime)
        }
        if numCounter==Int(spaceInterval*10) && counter%2 == 1 && (numCount+1)*totalTime >= duration*10{
            print("feedback1")
            counter = 1000000000 //billion
            screen.timerInterval(interval: 0)
            //feedback
            feedback(screen:screen,context:context)
        }else{
            if counter%2 == 1{//If odd, num 1
                
                if isShow && numCounter == Int(spaceInterval*10){
                    if !hasTouched && numPair[0]%2 != numPair[1]%2{
                        numCorrect+=1
                    }
                    
                    hasTouched = false
                    bg.color = UIColor(red:40/255,green:44/255,blue:52/255,alpha:1)
                    let num1 = Int(arc4random_uniform(100)+1)
                    let num2 = Int(arc4random_uniform(100)+1)
                    numPair = [num1,num2]
                    let label = SKLabelNode(position: CGPoint(x:screen.frame.width*0.25,y:screen.frame.height/2), zPosition: 1, text: "\(numPair[0])", fontColor: .white, fontName: "Arial Bold", fontSize: 90, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
                    label.name = "n"
                    screen.addChild(label)
                    isShow = false
                }else if !isShow && numCounter == Int(spaceInterval*10)+Int(numInterval*10){
                    screen.clearNode("n")
                    isShow = true
                    counter+=1
                    numCounter = 0
                }
                
            }else{//If even, num 2
                if isShow && numCounter == Int(spaceInterval*10){
                    let label = SKLabelNode(position: CGPoint(x:screen.frame.width*0.75,y:screen.frame.height/2), zPosition: 1, text: "\(numPair[1])", fontColor: .white, fontName: "Arial Bold", fontSize: 90, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
                    label.name = "n"
                    screen.addChild(label)
                    isShow = false
                }else if !isShow && numCounter == Int(spaceInterval*10)+Int(numInterval*10){
                    screen.clearNode("n")
                    isShow = true
                    counter+=1
                    numCount+=1
                    numCounter = 0
                }
            }
        }
        
        if isCueing && soundCounter%(context.project.getGuiSetting().getSleepInterval()*10) == 0 && soundCounter2<targeted.count*2{
            do {
                let soundLoad = try AVAudioPlayer(contentsOf: toplay[soundCounter2])
                player = soundLoad
                player.play()
            }catch {}
            soundCounter2+=1
            context.project.setCueTimeEnd2(time: Date())
        }
        
        if durationCounter == cueBeginTime*10 && context.controlModel == 3{
            //begin cueing
            context.project.setCueTimeBegin2(time: Date())
            isCueing = true
            
        }
        if durationCounter >= duration*10{
            print("feedback2")
            counter = 1000000000 //billion
            screen.timerInterval(interval: 0)
            //feedback
            feedback(screen:screen,context:context)
        }
    }
    
    func feedback(screen:TMRScreen,context:TMRContext){
        screen.clearNode("n")
        screen.clearNode("g")
        
        bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.95), zPosition: 1, text: "Feedback", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        title.name = "f"
        screen.addChild(title)
        
        let p = Int(100*Double(numCorrect)/Double(numCount))
        var array = context.project.getControlArray()
        array[context.controlModel-1] = Double(numCorrect)/Double(numCount)
        context.project.setControlArray(array: array)
        
        let percent = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.5), zPosition: 1, text: "\(p)% Correct", fontColor: .white, fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        percent.name = "f"
        screen.addChild(percent)
        
        let i7 = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.15), zPosition: 1, text: "Tap to Continue", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        i7.name = "f"
        screen.addChild(i7)
        
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
