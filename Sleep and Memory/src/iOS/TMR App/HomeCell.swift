//
//  HomeCell.swift
//  TMR App
//
//  Created by Robert Zhang on 7/19/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

class HomeCell:SKSpriteNode{
    var screen:SKScene
    var project:TMRProject!
    
    var title = SKLabelNode()
    var timeStamp = SKLabelNode()
    var projectIndex:Int!
    
    var hasTouchedDown = false
    
    init(screen:SKScene,yNum:CGFloat,project:TMRProject,projectIndex:Int){
        //Establish Scene property
        self.screen = screen
        //Set SKSpriteNode Positional and Visual Properties
        self.project = project
        let texture:SKTexture = SKTexture(imageNamed:"rect")
        super.init(texture:texture,color:.clear,size:texture.size())
        self.zPosition = 0
        self.name = "cell"
        self.size = CGSize(width:screen.frame.width,height:screen.frame.height/4)
        self.color = .lightGray
        self.position = CGPoint(x:screen.frame.width/2,y:-yNum*(self.frame.height+8)+screen.frame.height*5/6-self.frame.height/2)
        self.projectIndex = projectIndex
        
        title = SKLabelNode(position: CGPoint(x:5-self.frame.width/2,y:self.frame.height/2-5), zPosition: 1, text: project.getTMRProjectName(), fontColor: .black, fontName: "Arial Bold", fontSize: 25, verticalAlignmentMode: .top, horizontalAlignmentMode: .left)
        self.addChild(title)
        
        timeStamp = SKLabelNode(position: CGPoint(x:-self.frame.width/2+5,y:-self.frame.height/2+5), zPosition: 1, text: project.getBeginTime(), fontColor: .black, fontName: "Arial Bold", fontSize: 25, verticalAlignmentMode: .bottom, horizontalAlignmentMode: .left)
        self.addChild(timeStamp)
        
        var text = ""
        if project.getExperimentCompleted(){text = "Experiment Complete"}else{text = "Experiment Incomplete"}
        
        let isDone = SKLabelNode(position: CGPoint(x:self.frame.width/2-5,y:self.frame.height/2-5), zPosition: 1, text: text, fontColor: .black, fontName: "Arial Bold", fontSize: 25, verticalAlignmentMode: .top, horizontalAlignmentMode: .right)
        self.addChild(isDone)
    }
    
    func scrollUp(){
        let a = SKAction.move(by: CGVector(dx:0,dy:screen.frame.height/2), duration: 0.15)
        self.run(a)
    }
    
    func scrollDown(){
        let a = SKAction.move(by: CGVector(dx:0,dy:-screen.frame.height/2), duration: 0.15)
        self.run(a)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
