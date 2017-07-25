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


class TMRModelHome : TMRModel  {
    
    var cells:[HomeCell] = []
    var screen:TMRScreen!
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        print("model home begin")
        screen.clearScreen()
        
        
        //screen.addChild(label)
        self.screen = screen
        
        let navigationBar = SKSpriteNode(color: .black, width: screen.frame.width, height: screen.frame.height/6, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-screen.frame.height/12), zPosition: 2, alpha: 1)
        navigationBar.name = "nav"
        let label = SKLabelNode(position: CGPoint(x:0,y:0), zPosition: 1, text: "TMR App", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "homeLabel"
        navigationBar.addChild(label)
        
        let plusSign = SKSpriteNode(imageName: "plus", ySize: navigationBar.frame.height-10, anchorPoint: CGPoint(x:1,y:1), position: CGPoint(x:screen.frame.width-5,y:screen.frame.height-5), zPosition: 3, alpha: 1)
        plusSign.name = "plus"
        screen.addChild(plusSign)
        screen.addChild(navigationBar)
        
        var counter = context.allProjects.count-1
        for projectIndex in 0..<context.allProjects.count{
            let cell = HomeCell(screen: screen, yNum: CGFloat(counter), project: context.allProjects[projectIndex], projectIndex: projectIndex)
            counter-=1
            screen.addChild(cell)
            cells.append(cell)
        }
        
        //Gesture Recognizers
        let upGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        upGesture.direction = .up
        upGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(upGesture)
        
        let downGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:#selector(self.swipe))
        downGesture.direction = .down
        downGesture.numberOfTouchesRequired = 1 //You can edit this - how many fingers need to do the swipe.
        view.addGestureRecognizer(downGesture)

    }
    
    func swipe(gesture:UISwipeGestureRecognizer){
        if gesture.direction == .up{
            var ta = 0
            var t = 0
            for cell in cells{
                t+=1
                if cell.position.y-cell.frame.height/2 > 0{
                    ta+=1
                }
            }
            if ta < t{
                for cell in cells{
                    cell.scrollUp()
                }
            }
        }
        if gesture.direction == .down{
            var ta = 0
            var t = 0
            for cell in cells{
                t+=1
                if cell.position.y+cell.frame.height/2 < screen.frame.height{
                    ta+=1
                }
            }
            if ta<t{
                for cell in cells{
                   
                    cell.scrollDown()
                }
            }
        }
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        for node in screen.children{
            if node.name == "cell"{
                if node.contains(position){
                    let cell = node as! HomeCell
                    cell.hasTouchedDown = true
                }
            }
   
            if node.name == "plus" && node.contains(position){
                //add new project
                context.nextModel = .MetaData
                context.project = TMRProjectImpl()
            }
        }
    }
    
    override func touchEnd(screen: TMRScreen, context: TMRContext, position: CGPoint) {
        for node in screen.children{
            if node.name == "cell"{
                if node.contains(position){
                    let cell = node as! HomeCell
                    if cell.hasTouchedDown{
                        cell.hasTouchedDown = false
                        print(context.project.getSetupPassed())
                        context.project = context.allProjects[cell.projectIndex]
                        print(context.project.getSetupPassed())
                        context.nextModel = .ViewProj
                    }
                }
            }
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("model home end")
    }
}
