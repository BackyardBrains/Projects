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
    var next = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext) {
        context.project.setExperimentCompleted()
        screen.clearScreen()
        let percentCorrect = CGFloat(context.project.getPercentOfCorrectionBeforeSleep())/100
        
        let cumText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-10), zPosition: 2, text: "Correct/Incorrect Ratio", fontColor: .black, fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(cumText)
        
        let dictateText = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-50), zPosition: 2, text: "%Correct:%Incorrect", fontColor: .black, fontName: "Arial Bold", fontSize: 20, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(dictateText)
        
        let green = SKSpriteNode(color: .green, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2-20), zPosition: 1, alpha: 1)
        screen.addChild(green)
        let gText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2-20), zPosition: 1, text: "Correct", fontColor: .black, fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(gText)
        
        let red = SKSpriteNode(color: .red, width: 20, height: 20, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:screen.frame.width/10+40,y:screen.frame.height/2+20), zPosition: 1, alpha: 1)
        screen.addChild(red)
        let rText = SKLabelNode(position: CGPoint(x:screen.frame.width/10+70,y:screen.frame.height/2+20), zPosition: 1, text: "Incorrect", fontColor: .black, fontName: "Arial Bold", fontSize: 10, verticalAlignmentMode: .center, horizontalAlignmentMode: .left)
        screen.addChild(rText)
        
        let percents = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.2-40), zPosition: 1, text: "\(round2(percentCorrect))%:\(round2(1-percentCorrect))%", fontColor: .black, fontName: "Arial Bold", fontSize: 15, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(percents)
        
        let wrong = SKSpriteNode(color: .red,
                                 width: screen.frame.width/12,
                                 height: screen.frame.height*0.6,
                                 anchorPoint: CGPoint(x:0.5,y:0),
                                 position: CGPoint(x:screen.frame.width/2,
                                                   y:screen.frame.height*0.15),
                                 zPosition: 1, alpha: 1)
        screen.addChild(wrong)
        
        let correct = SKSpriteNode(color: .green,
                                   width: screen.frame.width/12,
                                   height: screen.frame.height*0.6*percentCorrect,
                                   anchorPoint: CGPoint(x:0.5,y:0),
                                   position: CGPoint(x:screen.frame.width/2,
                                                     y:screen.frame.height*0.15),
                                   zPosition: 2, alpha: 1)
        screen.addChild(correct)
       
        
        next = SKSpriteNode(imageName: "next", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:10,y:10), zPosition: 1, alpha: 1)
        screen.addChild(next)
    }
    
    func round2(_ num:CGFloat)->CGFloat{
        let rounded = round(num*1000)/10
        return rounded
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if next.contains(position){
            context.nextModel = .Queuing
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
    
}
