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
    var x = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Save for Later/Save & Continue", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        x = SKSpriteNode(imageName: "quit", ySize: screen.frame.height/6-10, anchorPoint: CGPoint(x:0,y:1), position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 3, alpha: 1)
        x.name = "quit"
        screen.addChild(x)
        
        save = SKSpriteNode(imageName: "save", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*2/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        
        cont = SKSpriteNode(imageName: "continue", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*5/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        
        screen.addChild(save)
        screen.addChild(cont)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if x.contains(position){
            context.reset()
            if context.project.getSetupPassed()[7] != 1{
                context.project.setSetupPassed(array: [0,0,0,0,0,0,0,0])
                context.userAccount.setID(ID: context.userAccount.getID()-1)
            }
            if context.project.getSetupPassed()[7] == 1{
                context.project = context.baseProjectCopy
            }
            context.nextModel = .Home
        }
        if save.contains(position){
            // save project to file
            let projName = context.project.getTMRID()
            print(TMRProjectFactory.getNameList())
            
            if let index = context.getAllProjectNames().index(of: projName){
                context.allProjects.remove(at: index)
            }
            
            var array = context.project.getSetupPassed()
            array[7] = 1
            context.project.setSetupPassed(array: array)
            context.allProjects.append(context.project)
            context.reset()
            context.nextModel = .Home
            TMRProjectFactory.save(name: projName, proj: context.project.getTMRProjectTuple())

        }
        if cont.contains(position){
            var array = context.project.getSetupPassed()
            array[7] = 1
            context.project.setSetupPassed(array: array)
            context.reset()
            let userName = context.userAccount.getUserName()
            context.allProjects.append(context.project)
            
            // save project to file
            let projName = context.project.getTMRID()
            TMRProjectFactory.save(name: projName, proj: context.project.getTMRProjectTuple())
            context.nextModel = .Training
        }
        
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        // save user to file
        
        
    }
}
