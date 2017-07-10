//
//  TMRModelHome.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit


class TMRModelHome : TMRModel  {
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        print("model home begin")
        screen.clearScreen()
        
        let label = SKLabelNode(position: CGPoint(x:screen.width/2,y:screen.height/2), zPosition: 1, text: "Click For New Project", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "homeLabel"
        screen.addChild(label)
        
        //TMRProjectFactory.delAll()
        
        context.userNameList = UserAccountFactory.getNameList()
        if context.userNameList.count > 0 {
            context.selUserName = context.userNameList[0]
            context.userAccount = UserAccountFactory.importUserAccountFromFile(userName: context.selUserName)
            print("\(context.userAccount.getUserAccountTuple())")
        }
        
        context.projNameList = TMRProjectFactory.getNameList()
        if context.projNameList.count > 0 {
            context.selProjName = context.projNameList[0] // select first for now
            context.project = TMRProjectFactory.importProjectFromFile(projectName: context.selProjName)
            print("\(context.project.getTMRProjectTuple())")
        }
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        print("model home tick")
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        context.nextModel = .MetaData
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model home end")
    }
}
