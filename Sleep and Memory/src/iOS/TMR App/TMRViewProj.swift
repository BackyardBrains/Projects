//
//  MetaDataScreen.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//


//to enter Project Name, Location, Experimenter, and Subject Parameters

import Foundation
import SpriteKit

class TMRViewProj:TMRModel{
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let navigationBar = SKSpriteNode(color: .black, width: screen.frame.width, height: screen.frame.height/6, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-screen.frame.height/12), zPosition: 2, alpha: 1)
        navigationBar.name = "nav"
        let label = SKLabelNode(position: CGPoint(x:0,y:0), zPosition: 1, text: "\(context.project.getTMRProjectName()) Data", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "homeLabel"
        navigationBar.addChild(label)
        screen.addChild(navigationBar)
        
        let x = SKSpriteNode(imageName: "done", ySize: navigationBar.frame.height-10, anchorPoint: CGPoint(x:0,y:1), position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 3, alpha: 1)
        x.name = "exit"
        screen.addChild(x)
        
        if context.project.getExperimentCompleted(){
            setupData(screen:screen,context:context)
        }else{
            setupStart(screen:screen,context:context)
        }
    }
    
    func setupData(screen:TMRScreen,context:TMRContext){
        let export = SKSpriteNode(imageName: "export", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*5/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        export.name = "export"
        screen.addChild(export)
        
        let data = SKSpriteNode(imageName: "data", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*2/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        data.name = "data"
        screen.addChild(data)
    }
    
    func setupStart(screen:TMRScreen,context:TMRContext){
        let start = SKSpriteNode(imageName: "continue", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*5/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        start.name = "start"
        screen.addChild(start)
        let settings = SKSpriteNode(imageName: "setup", xSize: screen.frame.width/10, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width*2/7,y:screen.frame.height/2), zPosition: 2, alpha: 1)
        settings.name = "settings"
        screen.addChild(settings)
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        for node in screen.children{
            if node.name == "exit" && node.contains(position){
                context.nextModel = .Home
                context.reset()
            }
            if node.name == "settings" && node.contains(position){
                context.reset()
                context.nextModel = .MetaData
            }
            if node.name == "start" && node.contains(position){
                context.reset()
                context.setResourceIndexList(resourceIndexList: context.project.getResourceIndexEntries())
                context.nextModel = .Training
            }
            if node.name == "export" && node.contains(position){
                let jsonString = TMRProjectFactory.exportProjectToFile(project: context.project, screen:screen)
                screen.shareData(info: [jsonString])
            }
            if node.name == "data" && node.contains(position){
                context.nextModel = .PostTestStats
            }
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
