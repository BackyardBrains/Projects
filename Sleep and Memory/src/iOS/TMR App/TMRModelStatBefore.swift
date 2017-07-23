//
//  TMRModelResult.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

class TMRModelStatBefore : TMRModel {
    
    var currentGraph = 0 //0 for no feedback, 1 for feedback, 2 for total
    var right = SKSpriteNode()
    var left = SKSpriteNode()
    var text = "With Feedback"
    
    var percentCorrect:CGFloat = 0
    
    var nextt = SKSpriteNode() //to comments
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        context.project.setExperimentCompleted()
        screen.clearScreen()
        
        percentCorrect = CGFloat(context.project.getPercentOfCorrection1()+context.project.getPercentOfCorrection2())/200
        
        createGraph(percentCorrect: percentCorrect, screen: screen, text: text)
        
        right = SKSpriteNode(imageName: "NextIcon", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:1,y:0.5), position: CGPoint(x:screen.frame.width-10,y:screen.frame.height/2), zPosition: 1, alpha: 1)
        screen.addChild(right)
        
        left = SKSpriteNode(imageName: "PrevIcon", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:10,y:screen.frame.height/2), zPosition: 1, alpha: 1)
        left.isHidden = true
        screen.addChild(left)
       
        nextt = SKSpriteNode(imageName: "next", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:10,y:10), zPosition: 1, alpha: 1)
        screen.addChild(nextt)
        
        let green = SKSpriteNode(color: .green, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2-20), zPosition: 1, alpha: 1)
        screen.addChild(green)
        let gText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2-20), zPosition: 1, text: "Correct", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(gText)
        
        let red = SKSpriteNode(color: .red, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2+20), zPosition: 1, alpha: 1)
        screen.addChild(red)
        let rText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2+20), zPosition: 1, text: "Incorrect", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(rText)
    }
    
    func round2(_ num:CGFloat)->CGFloat{
        let rounded = round(num*1000)/10
        return rounded
    }
    
    func createGraph(percentCorrect:CGFloat,screen:TMRScreen,text:String){
        screen.clearNode("removable")
        
        let cumText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-10), zPosition: 2, text: "\(text) Correct/Incorrect Ratio", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        cumText.name = "removable"
        screen.addChild(cumText)
        
        let dictateText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-50), zPosition: 2, text: "%Correct:%Incorrect", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(dictateText)
        
        let percents = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.2-40), zPosition: 1, text: "\(round2(percentCorrect))%:\(round2(1-percentCorrect))%", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        percents.name = "removable"
        screen.addChild(percents)
        
        let wrong = SKSpriteNode(color: .red,
                                 width: screen.frame.width/12,
                                 height: screen.frame.height*0.6,
                                 anchorPoint: CGPoint(x:0.5,y:0),
                                 position: CGPoint(x:screen.frame.width/2,
                                                   y:screen.frame.height*0.15),
                                 zPosition: 1, alpha: 1)
        wrong.name = "removable"
        screen.addChild(wrong)
        
        let correct = SKSpriteNode(color: .green,
                                   width: screen.frame.width/12,
                                   height: screen.frame.height*0.6*percentCorrect,
                                   anchorPoint: CGPoint(x:0.5,y:0),
                                   position: CGPoint(x:screen.frame.width/2,
                                                     y:screen.frame.height*0.15),
                                   zPosition: 2, alpha: 1)
        correct.name = "removable"
        screen.addChild(correct)
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
        
        if nextt.contains(position){
            if context.project.getGuiSetting().getTreatmentNum() == 1{
                context.nextModel = .Queuing
            }
            if context.project.getGuiSetting().getTreatmentNum() == 2{
                context.nextModel = .Control
            }
            //Goes to others with different treatments
        }
        
        if currentGraph == 0{
            percentCorrect = CGFloat(context.project.getPercentOfCorrection1()+context.project.getPercentOfCorrection2())/200
            text = "With Feedback"
        }
        else if currentGraph == 1{
            percentCorrect = CGFloat(context.project.getPercentOfCorrectionBeforeSleep())/100
            text = "No Feedback"
        }
        else{
            percentCorrect = CGFloat(context.project.getPercentOfCorrection1()+context.project.getPercentOfCorrection2()+context.project.getPercentOfCorrectionBeforeSleep())/300
            text = "Total"
        }
        createGraph(percentCorrect: percentCorrect, screen: screen, text: text)
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
    
}
