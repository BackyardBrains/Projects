//
//  TMRModelResult.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

// type: .PreNapStat,.Result:
class TMRPostTestStats : TMRModel {
    var currentGraph = 0 //0 for total, 1 for targeted, 2 for untargeted
    var right = SKSpriteNode()
    var left = SKSpriteNode()
    var percentCorrectB:CGFloat = 0
    var percentCorrectA:CGFloat = 0
    var text = "Total"
    var end = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        percentCorrectB = CGFloat(context.project.getPercentOfCorrectionBeforeSleep())/100
        percentCorrectA = CGFloat(context.project.getPercentOfCorrectionAfterSleep())/100
        createGraph(beforePercent: percentCorrectB, afterPercent: percentCorrectA, screen: screen,text:text)
        
        right = SKSpriteNode(imageName: "NextIcon", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:1,y:0.5), position: CGPoint(x:screen.frame.width-10,y:screen.frame.height/2), zPosition: 1, alpha: 1)
        screen.addChild(right)
        
        left = SKSpriteNode(imageName: "PrevIcon", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:10,y:screen.frame.height/2), zPosition: 1, alpha: 1)
        left.isHidden = true
        screen.addChild(left)
        
        let green = SKSpriteNode(color: .green, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2-20), zPosition: 1, alpha: 1)
        screen.addChild(green)
        let gText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2-20), zPosition: 1, text: "Correct", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(gText)
        
        let red = SKSpriteNode(color: .red, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2+20), zPosition: 1, alpha: 1)
        screen.addChild(red)
        let rText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2+20), zPosition: 1, text: "Incorrect", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(rText)
        
        
        end = SKSpriteNode(imageName: "exit", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:10,y:10), zPosition: 1, alpha: 1)
        screen.addChild(end)
    }
    
    func createGraph(beforePercent:CGFloat,afterPercent:CGFloat,screen:TMRScreen,text:String){
        screen.clearNode("removable")
        
        let cumText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-10), zPosition: 2, text: "\(text) Improvement", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        cumText.name = "removable"
        screen.addChild(cumText)
        
        let dictateText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-50), zPosition: 2, text: "%Correct:%Incorrect", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(dictateText)
        
        let beforeText = SKLabelNode(position: CGPoint(x:screen.frame.width/3+screen.frame.width/12,y:screen.frame.height*0.2-10), zPosition: 1, text: "Before", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        beforeText.name = "removable"
        screen.addChild(beforeText)
        
        let beforePercents = SKLabelNode(position: CGPoint(x:screen.frame.width/3+screen.frame.width/12,y:screen.frame.height*0.2-30), zPosition: 1, text: "\(round2(percentCorrectB))%:\(round2(1-percentCorrectB))%", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        beforePercents.name = "removable"
        screen.addChild(beforePercents)
        
        let wrongB = SKSpriteNode(color: .red,
                                  width: screen.frame.width/12,
                                  height: screen.frame.height*0.6,
                                  anchorPoint: CGPoint(x:0,y:0),
                                  position: CGPoint(x:screen.frame.width/3+screen.frame.width/24,
                                                    y:screen.frame.height*0.2),
                                  zPosition: 1, alpha: 1)
        wrongB.name = "removable"
        screen.addChild(wrongB)
        
        let correctB = SKSpriteNode(color: .green,
                                    width:  screen.frame.width/12,
                                    height: screen.frame.height*0.6*beforePercent,
                                    anchorPoint: CGPoint(x:0,y:0),
                                    position: CGPoint(x:screen.frame.width/3+screen.frame.width/24,
                                                      y:screen.frame.height*0.2),
                                    zPosition: 2, alpha: 1)
        correctB.name = "removable"
        screen.addChild(correctB)
        
        let afterText = SKLabelNode(position: CGPoint(x:screen.frame.width/2+screen.frame.width/12,y:screen.frame.height*0.2-10), zPosition: 1, text: "After", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        afterText.name = "removable"
        screen.addChild(afterText)
        
        let afterPercents = SKLabelNode(position: CGPoint(x:screen.frame.width/2+screen.frame.width/12,y:screen.frame.height*0.2-30), zPosition: 1, text: "\(round2(percentCorrectA))%:\(round2(1-percentCorrectA))%", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        afterPercents.name = "removable"
        screen.addChild(afterPercents)
        
        let wrongA = SKSpriteNode(color: .red,
                                  width: screen.frame.width/12,
                                  height: screen.frame.height*0.6,
                                  anchorPoint: CGPoint(x:0,y:0),
                                  position: CGPoint(x:screen.frame.width/2+screen.frame.width/24,
                                                    y:screen.frame.height*0.2),
                                  zPosition: 1, alpha: 1)
        wrongA.name = "removable"
        screen.addChild(wrongA)
        
        let correctA = SKSpriteNode(color: .green,
                                    width: screen.frame.width/12,
                                    height: screen.frame.height*0.6*afterPercent,
                                    anchorPoint: CGPoint(x:0,y:0),
                                    position: CGPoint(x:screen.frame.width/2+screen.frame.width/24,
                                                      y:screen.frame.height*0.2),
                                    zPosition: 2, alpha: 1)
        correctA.name = "removable"
        screen.addChild(correctA)
    }
    
    func round2(_ num:CGFloat)->CGFloat{
        let rounded = round(num*1000)/10
        return rounded
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if left.contains(position){
            if currentGraph-1>=0{
                currentGraph-=1
                if currentGraph == 2{
                    right.isHidden = true
                }else{
                    right.isHidden = false
                }
                if currentGraph == 0{
                    left.isHidden = true
                }else{
                    left.isHidden = false
                }
            }
        }
        
        if end.contains(position){
            context.nextModel = .ViewProj
        }
        
        if right.contains(position){
            if currentGraph+1<=2{
                currentGraph+=1
                if currentGraph == 2{
                    right.isHidden = true
                }else{
                    right.isHidden = false
                }
                if currentGraph == 0{
                    left.isHidden = true
                }else{
                    left.isHidden = false
                }
            }
        }
        if currentGraph == 0{
            percentCorrectB = CGFloat(context.project.getPercentOfCorrectionBeforeSleep())/100
            percentCorrectA = CGFloat(context.project.getPercentOfCorrectionAfterSleep())/100
            text = "Total"
        }
        else if currentGraph == 1{
            percentCorrectB = CGFloat(context.project.getPercentOfCorrectionBeforeSleepForTargeted())/100
            percentCorrectA = CGFloat(context.project.getPercentOfCorrectionAfterSleepForTargeted())/100
            text = "Targeted"
        }
        else{
            percentCorrectB = CGFloat(context.project.getPercentOfCorrectionBeforeSleepForUnTargeted())/100
            percentCorrectA = CGFloat(context.project.getPercentOfCorrectionAfterSleepForUnTargeted())/100
            text = "Untargeted"
        }
        createGraph(beforePercent: percentCorrectB, afterPercent: percentCorrectA, screen: screen,text:text)
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
    
}
