//
//  HomeCell.swift
//  TMR App
//
//  Created by Robert Zhang on 7/19/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class ManualCell:SKSpriteNode{
    var screen:SKScene
    var resource:TMRResource!
    
    var image = SKSpriteNode()
    var play = SKSpriteNode()
    var isSelected = false
    var toggleButton = SKSpriteNode()
    var hasTouchedDown = false
    
    var index:Int = 0
    
    var player = AVAudioPlayer()
    
    init(screen:SKScene,yNum:CGFloat,resource:TMRResource,index:Int){
        //Establish Scene property
        self.screen = screen
        //Set SKSpriteNode Positional and Visual Properties
        let texture:SKTexture = SKTexture(imageNamed:"rect")
        super.init(texture:texture,color:.clear,size:texture.size())
        self.zPosition = 0
        self.name = "cell"
        self.size = CGSize(width:screen.frame.width,height:screen.frame.height/4)
        self.color = .lightGray
        self.colorBlendFactor = 1
        self.position = CGPoint(x:screen.frame.width/2,y:-yNum*(self.frame.height+8)+screen.frame.height*5/6-self.frame.height/2)
        self.index = index
        self.resource = resource
        print(self.position)
        
        image = SKSpriteNode(imageName: resource.getPictureName(index: index), ySize: self.size.height*8/9, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:-self.frame.width/2+5,y:0), zPosition: 1, alpha: 1)
        self.addChild(image)
        
        play = SKSpriteNode(imageName:"continue", ySize: self.size.height*8/9, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:image.frame.width+30-self.size.width/2,y:0), zPosition: 1, alpha: 1)
        play.color = .red
        play.colorBlendFactor = 1
        play.name = "play"
        self.addChild(play)
    
        toggleButton = SKSpriteNode(imageName:"rect", width:self.size.width/2,height:self.size.height*8/9, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:0,y:0), zPosition: 1, alpha: 1)
        toggleButton.position.x = self.frame.width/2-30-toggleButton.frame.width/2
        toggleButton.color = .darkGray
        toggleButton.colorBlendFactor = 1
        toggleButton.name = "toggle"
        self.addChild(toggleButton)
        
        let label = SKLabelNode(position: CGPoint(x:0,y:0), zPosition: 1, text: "Not Selected", fontColor: .white, fontName: "Arial Bold", fontSize: 25, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "label"
        toggleButton.addChild(label)
        
    }
    
    func toggle(){
        if isSelected{
            isSelected = false
            self.color = .lightGray
            for node in toggleButton.children{
                if node.name == "label"{
                    let label = node as! SKLabelNode
                    label.text = "Not Selected"
                }
            }
        }else{
            isSelected = true
            self.color = .white
            for node in toggleButton.children{
                if node.name == "label"{
                    let label = node as! SKLabelNode
                    label.text = "Selected"
                }
            }
        }
    }
    
    func playSound(){
        do {
            let soundLoad = try AVAudioPlayer(contentsOf: resource.getAudioURL(index: index)!)
            player = soundLoad
            player.play()
        }catch {}
    }
    
    func scrollUp(){
        let a = SKAction.move(by: CGVector(dx:0,dy:screen.frame.height/1.5), duration: 0.15)
        self.run(a)
    }
    
    func scrollDown(){
        let a = SKAction.move(by: CGVector(dx:0,dy:-screen.frame.height/1.5), duration: 0.15)
        self.run(a)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
