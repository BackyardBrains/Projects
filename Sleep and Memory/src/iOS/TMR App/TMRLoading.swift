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
        
        for projectName in context.projNameList{
            let project = TMRProjectFactory.importProjectFromFile(projectName: projectName)
            context.allProjects.append(project)
        }
    
        
        context.userNameList = UserAccountFactory.getNameList()
        if context.userNameList.count > 0 {
            context.selUserName = context.userNameList[0]
            context.userAccount = UserAccountFactory.importUserAccountFromFile(userName: context.selUserName)
            print("\(context.userAccount.getUserAccountTuple())")
        }
        
        context.nextModel = .Home
        
        
    }
    
}
