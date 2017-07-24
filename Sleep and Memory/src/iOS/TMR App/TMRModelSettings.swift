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
    
    var save = SKSpriteNode()
    var cont = SKSpriteNode()
    var trash = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Trash, Save for Later, Save & Continue", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        save = SKSpriteNode(imageName: "save", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        
        trash = SKSpriteNode(imageName: "trash", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*2/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        
        cont = SKSpriteNode(imageName: "continue", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*5/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        
        screen.addChild(save)
        screen.addChild(trash)
        screen.addChild(cont)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model Settings tick")
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        print("model Settings touch")
        if save.contains(position){
            let userName = context.userAccount.getUserName()
            UserAccountFactory.save(name: userName, user: context.userAccount.getUserAccountTuple())
            
            // save project to file
            let projName = context.project.getTMRID()
            TMRProjectFactory.save(name: projName, proj: context.project.getTMRProjectTuple())
            context.allProjects.append(context.project)
            context.reset()
            context.nextModel = .Home
        }
        if trash.contains(position){
            context.nextModel = .Home
            TMRProjectFactory.del(name: context.project.getTMRID())
            //remove from all projects too
        }
        if cont.contains(position){
            context.reset()
            let userName = context.userAccount.getUserName()
            UserAccountFactory.save(name: userName, user: context.userAccount.getUserAccountTuple())
            context.allProjects.append(context.project)
            
            // save project to file
            let projName = context.project.getTMRID()
            TMRProjectFactory.save(name: projName, proj: context.project.getTMRProjectTuple())
            context.nextModel = .Training
        }
        
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model Settings end")
        // save user to file
        
        
    }
}
