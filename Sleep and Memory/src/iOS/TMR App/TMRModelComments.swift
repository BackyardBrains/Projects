//
//  MetaDataScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//


//Add post experiment Comments

import Foundation
import SpriteKit

class TMRModelComments:TMRModel{
    
    var next = SKSpriteNode()
    
    var field = UITextView()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)
        
        field = UITextView(frame: CGRect(x:view.frame.width/2,y:view.frame.height*0.45,width:view.frame.width*0.9,height:view.frame.height*0.4))
        field.allowsEditingTextAttributes = true
        field.center = CGPoint(x:view.frame.width/2,y:view.frame.height*0.45)
        view.addSubview(field)
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Comments For Experimenter", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.2), zPosition: 2, alpha: 1)
        screen.addChild(next)
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if next.contains(position){
            if let f = field.text{
                if f != ""{
                    context.project.setTMRProjectNote(note: f)
                }else{
                    context.project.setTMRProjectNote(note: "No Comments Were Made")
                }
            }else{
                context.project.setTMRProjectNote(note: "No Comments Were Made")
            }
            field.removeFromSuperview()
            context.nextModel = .End
            
            print(context.project.getTMRProjectNote())
            
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
