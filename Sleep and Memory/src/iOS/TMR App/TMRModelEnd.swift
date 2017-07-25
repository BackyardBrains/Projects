//
//  TMRModelEnd.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit


class TMRModelEnd : TMRModel  {
    
    var end = SKSpriteNode()
    var export = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        print("model End begin")
        screen.clearScreen()
        
        let label = SKLabelNode(position: CGPoint(x:screen.width/2,y:screen.height/2), zPosition: 1, text: "Project Complete - Please Export Data", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(label)
        
        //should only appear when export button clicked
        export = SKSpriteNode(imageName: "export", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0), position: CGPoint(x:screen.frame.width/2,y:10), zPosition: 1, alpha: 1)
        screen.addChild(export)
        
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model End tick")
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        print("model End touch")
        if export.contains(position){
            export.position.x = screen.frame.width*100
            export.removeFromParent()
            end = SKSpriteNode(imageName: "exit", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0), position: CGPoint(x:screen.frame.width/2,y:10), zPosition: 1, alpha: 1)
            screen.addChild(end)
            context.project.setExperimentCompleted()
            let jsonString = TMRProjectFactory.exportProjectToFile(project: context.project, screen:screen)
            screen.shareData(info: [jsonString])
        }
        else if end.contains(position){
            context.reset()
            context.nextModel = .Home
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model End")
        let project : TMRProject = context.project
        TMRProjectFactory.save(name: project.getTMRID(), proj: project.getTMRProjectTuple())
    }
}
