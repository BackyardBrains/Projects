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


class TMRUserSignin : TMRModel  {
    var username = UITextField()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        print("model sign in begin")
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Sign In", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        username = UITextField(text: "", placeholder: "Username (type:Robert)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/2, y: view.frame.height*0.42, width: screen.frame.width/1.3, height: screen.frame.width/20))
        username.center = CGPoint(x:view.frame.width/2, y: view.frame.height*0.42)
        view.addSubview(username)
        
        let next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        next.name = "next"
        screen.addChild(next)
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        for node in screen.children{
            if node.name == "next"{
                if let name = username.text{
                   // if name == "Robert"{
                        UserAccountFactory.importAllUserAccountssFromFiles()
                        context.userAccount = UserAccountFactory.createUserAccount(userName: name, password: "6")
                        UserAccountFactory.save(name: context.userAccount.getUserName(), user: context.userAccount.getUserAccountTuple())
                        context.nextModel = .Loading
                        context.userAccount.setUserName(userName: name)
                        username.removeFromSuperview()
                   // }
                }
                
            }
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model sign in end")
    }
    
}
