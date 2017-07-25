//
//  CueingSetupScreen2.swift
//  TMR App
//
//  Created by Robert Zhang on 7/6/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

//manually choose cued

import Foundation
import SpriteKit

class TMRModelCueingSetupManual:TMRModel{
    
    var cells:[ManualCell] = []
    var screen:TMRScreen!
    var targetedIDs:[Int] = []
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        self.screen = screen
        
        //Nav bar
        let navigationBar = SKSpriteNode(color: .black, width: screen.frame.width, height: screen.frame.height/6, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-screen.frame.height/12), zPosition: 3, alpha: 1)
        navigationBar.name = "nav"
        let label = SKLabelNode(position: CGPoint(x:0,y:0), zPosition: 1, text: "Manual Select", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 40, verticalAlignmentMode: .center, horizontalAlignmentMode: .center)
        label.name = "homeLabel"
        navigationBar.addChild(label)
        
        let doneSign = SKSpriteNode(imageName: "done", ySize: navigationBar.frame.height-10, anchorPoint: CGPoint(x:1,y:1), position: CGPoint(x:screen.frame.width-5,y:screen.frame.height-5), zPosition: 4, alpha: 1)
        doneSign.name = "done"
        screen.addChild(doneSign)
        screen.addChild(navigationBar)
        
        let prevSign = SKSpriteNode(imageName: "PrevIcon", ySize: navigationBar.frame.height-10, anchorPoint: CGPoint(x:0,y:1), position: CGPoint(x:5,y:screen.frame.height-5), zPosition: 4, alpha: 1)
        prevSign.name = "prev"
        screen.addChild(prevSign)
        
        //Create Cells
        for index in 0..<context.project.getTMRResource().getNumberOfResourceEntries(){
            let cell = ManualCell(screen: screen, yNum: CGFloat(index), resource: context.project.getTMRResource(), index: index)
            cell.name = "cell"
            screen.addChild(cell)
            cells.append(cell)
        }
        
        if context.project.getSetupPassed()[6]==1{
            for index in context.project.getTargetIndexEntries(){
                for cell in cells{
                    if cell.index == index{
                        cell.isSelected = true
                    }
                }
            }
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
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
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
    
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        for node in screen.children{
            if node.contains(position){
                if node.name == "done"{
                    let settings = context.project.getGuiSetting()
                    let resource = context.project.getTMRResource()
                    
                    var array = context.project.getSetupPassed()
                    array[6] = 1
                    context.project.setSetupPassed(array:array)
                    //set targetIDs
                    context.project.setResourceIndexEntries(resourceIndexEntries: targetedIDs)
                    context.setResourceIndexList(resourceIndexList: targetedIDs)
                    
                    // create position list
                    let posList = RandomNumberGenerator.generateRandomPositions(
                        rangeX: (Int(screen.imgSize/2),Int(screen.width-screen.imgSize)),
                        rangeY: (Int(screen.imgSize/2),Int(screen.height-screen.imgSize)),
                        sampleSize: settings.getSampleSize())
                    
                    // set position list to project
                    for (idx,(x,y)) in zip(targetedIDs,posList) {
                        context.project.setPosition(resourceIndex: idx, posX: x, posY: y)
                    }
                    
                    // create target list
                    let targetIndexList = RandomNumberGenerator.generateRandomNumbers(
                        range: targetedIDs.count,
                        sampleSize: Int(Double(targetedIDs.count)*0.5))
                    //0.5 maybe should be set manually?
                    
                    // set target list to project
                    var targetList = [Int]();
                    for i in 0..<targetIndexList.count {
                        targetList.append(targetedIDs[targetIndexList[i]])
                    }
                    context.project.setTargetIndexEntries(resourceIndexEntries: targetList)
                    
                    context.nextModel = .Settings
                }
                if node.name == "prev"{
                    context.nextModel = .CueingSetup
                }
                if node.name == "cell"{
                    for n in node.children{
                        if n.name == "play"{
                            let play = n as! SKSpriteNode
                            let newPos = SKSpriteNode(color: .clear, width: play.frame.width, height: play.frame.height, anchorPoint: CGPoint(x:0,y:0.5), position: CGPoint(x:play.position.x+node.position.x,y:play.position.y+node.position.y), zPosition: 1, alpha: 1)
                            if newPos.contains(position){
                                let cell = node as! ManualCell
                                cell.playSound()
                            }
                            
                        }
                        if n.name == "toggle"{
                            let toggle = n as! SKSpriteNode
                            let newPos = SKSpriteNode(color: .clear, width: toggle.frame.width, height: toggle.frame.height, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:toggle.position.x+node.position.x,y:toggle.position.y+node.position.y), zPosition: 1, alpha: 1)
                            if newPos.contains(position){
                                let cell = node as! ManualCell
                                if !cell.isSelected{
                                    cell.toggle()
                                    targetedIDs.append(cell.index)
                                }else{
                                    cell.toggle()
                                    if let index = targetedIDs.index(of: cell.index){
                                        targetedIDs.remove(at: index)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        print("ended")
    }
}
