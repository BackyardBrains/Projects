//
//  TMRModelHome.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


class TMRLoading : TMRModel  {
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        print("model home begin")
        screen.clearScreen()
        
        let label = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, text: "Loading Data", fontColor: .cyan, fontName: "Arial Bold", fontSize: 60, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(label)
        
        context.projNameList = TMRProjectFactory.getNameList()
        print(TMRProjectFactory.getNameList())
        
        TMRProjectFactory.importAllProjectsFromFiles()
        
        var numProjects = 0
        for projectName in context.projNameList{
            let project = TMRProjectFactory.importProjectFromFile(projectName: projectName)
            context.allProjects.append(project)
            numProjects+=1
        }
        
        context.selUserName = context.userAccount.getUserName()
        context.userAccount = UserAccountFactory.importUserAccountFromFile(userName: context.selUserName)
        
//        //THIS SHOULD NOT BE HERE!!!!!!!
        context.userAccount.setID(ID: numProjects)
//        //TEMPORARY FIX
        
        
        context.nextModel = .Home
    }
    
}
