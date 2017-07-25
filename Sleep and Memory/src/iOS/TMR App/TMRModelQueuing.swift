//
//  TMRModelQueuing.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TMRModelQueuing : TMRModel {
    var start = SKSpriteNode()
    var nextt = SKSpriteNode()
    var redo = SKSpriteNode()
    var startLabel = SKLabelNode()
    var dont = SKLabelNode()
    var queueLabel = SKLabelNode()
    
    var counter = 0
    
    var targeted:[Int] = []
    
    var player: AVAudioPlayer!
    
    var toplay:[URL] = []
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        screen.clearScreen()
        super.begin(screen: screen, context: context)
        targeted = context.project.getTargetIndexEntries()
        targeted.shuffle()
        
        start = SKSpriteNode(imageName: "start", xSize: screen.frame.width/5, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, alpha: 1)
        screen.addChild(start)
        
        startLabel = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-50), zPosition: 1, text: "Give the Device to the Researcher", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(startLabel)
        
        dont = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:50), zPosition: 1, text: "Do NOT tap the Blue Play Button", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .bottom, horizontalAlignmentMode: .center)
        screen.addChild(dont)
        
        queueLabel = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, text: "", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        screen.addChild(queueLabel)
        queueLabel.isHidden = true
        
        toplay = context.project.getBasedSoundsForTargeted()
        for num in 0..<targeted.count{
            let tSound = context.project.getAudioUrl(resourceIndex: targeted[num])!
            toplay.append(tSound)
        }
        toplay.shuffle()
        context.project.setCueTimeBegin(time: Date())
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if start.contains(position){
            context.project.setCueTimeBegin2(time: Date())
            //screen.playSound(name: "bg", sound: "whiteNoise.mp3")
            startLabel.removeFromParent()
            dont.removeFromParent()
            start.position = CGPoint(x:screen.frame.width*100,y:screen.frame.width*100)//Get rid of the touch
            start.removeFromParent()
            queueLabel.isHidden = false
            screen.timerInterval(interval: Double(context.project.getGuiSetting().getSleepInterval()), repeats : true)
        }
        if nextt.contains(position){
            context.nextModel = .Retest
            context.project.setCueTimeEnd(time: Date())
        }
        if redo.contains(position){
            screen.clearScreen()
            targeted = context.project.getTargetIndexEntries()
            targeted.shuffle()
            counter = 0
            start = SKSpriteNode(imageName: "start", xSize: screen.frame.width/5, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, alpha: 1)
            screen.addChild(start)
            
            queueLabel = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height/2), zPosition: 1, text: "", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
            screen.addChild(queueLabel)
            queueLabel.isHidden = true
            
            toplay = context.project.getBasedSoundsForTargeted()
            for num in 0..<targeted.count{
                let tSound = context.project.getAudioUrl(resourceIndex: targeted[num])!
                toplay.append(tSound)
            }
            toplay.shuffle()
            redo.removeFromParent()
            nextt.removeFromParent()
        }
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        if counter<targeted.count*2{
            do {
                let soundLoad = try AVAudioPlayer(contentsOf: toplay[counter])
                player = soundLoad
                player.play()
                let baseSounds = context.project.getBasedSoundsForTargeted()
                var isBaseline = false
                for url in baseSounds{
                    if url == toplay[counter]{
                        isBaseline = true
                    }
                }
                queueLabel.isHidden = false
                if !isBaseline{
                    queueLabel.text = "Targeted Sound Is Playing"
                }else{
                    queueLabel.text = "Baseline Sound Is Playing"
                }
                
            }catch {}
        }else{
            context.project.setCueTimeEnd2(time: Date())
            queueLabel.isHidden = true
            screen.timerInterval(interval: 0)
            nextt = SKSpriteNode(imageName: "next", xSize: screen.frame.width/5, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/3,y:screen.frame.height/2), zPosition: 1, alpha: 1)
            screen.addChild(nextt)
            redo = SKSpriteNode(imageName: "redo", xSize: screen.frame.width/5, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/3*2,y:screen.frame.height/2), zPosition: 1, alpha: 1)
            screen.addChild(redo)
        }
        counter+=1
    }
    
    
    override func end(screen : TMRScreen, context : TMRContext){
        screen.stopSound(name: "bg")
    }
}
