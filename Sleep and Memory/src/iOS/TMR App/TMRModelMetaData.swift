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

class TMRModelMetaData:TMRModel{
    var projectNameField = UITextField()
    var subjectNameField = UITextField()
    var experimenterField = UITextField()
    var locationField = UITextField()
    
    var nextt = SKSpriteNode()
    var prev = SKSpriteNode()
    
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let title = SKLabelNode(position: CGPoint(x:screen.frame.width/2,y:screen.frame.height-30), zPosition: 2, text: "Setup: If blank, default value is used", fontColor: UIColor(red:97/255,green:175/255,blue:175/255,alpha:1), fontName: "Arial Bold", fontSize: 30, verticalAlignmentMode: .top, horizontalAlignmentMode: .center)
        screen.addChild(title)
        
        projectNameField = UITextField(text: "", placeholder: "Session Name (default: Untitled)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/4, y: view.frame.height*0.3, width: screen.frame.width/2.5, height: screen.frame.width/20))
        projectNameField.center = CGPoint(x:view.frame.width/4, y: view.frame.height*0.3)
        projectNameField.autocorrectionType = .no
        view.addSubview(projectNameField)
        
        subjectNameField = UITextField(text: "", placeholder: "Subject Name (default: Not Set)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width*0.75, y: view.frame.height*0.3, width: screen.frame.width/2.5, height: screen.frame.width/20))
        subjectNameField.center = CGPoint(x:view.frame.width*0.75, y: view.frame.height*0.3)
        subjectNameField.autocorrectionType = .no
        view.addSubview(subjectNameField)
        
        experimenterField = UITextField(text: "", placeholder: "Experimenter Name (default: Not Set)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width/4, y: view.frame.height*0.42, width: screen.frame.width/2.5, height: screen.frame.width/20))
        experimenterField.center = CGPoint(x:view.frame.width/4, y: view.frame.height*0.42)
        experimenterField.autocorrectionType = .no
        view.addSubview(experimenterField)
        
        locationField = UITextField(text: "", placeholder: "Experiment Location (default: Not Set)", font: "Arial Bold", fontSize: 300, textColor: .black, textAlignment: .center, border: .roundedRect, adjustToFit: false, rect: CGRect(x: view.frame.width*0.75, y: view.frame.height*0.42, width: screen.frame.width/2.5, height: screen.frame.width/20))
        locationField.center = CGPoint(x:view.frame.width*0.75, y: view.frame.height*0.42)
        locationField.autocorrectionType = .no
        view.addSubview(locationField)
        
        if context.setupPassed[0]{
            projectNameField.text = context.project.getTMRProjectName()
            subjectNameField.text = context.project.getSubject()
            experimenterField.text = context.project.getExperimenter()
            locationField.text = context.project.getLocation()
        }
        
        
        nextt = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2+screen.frame.height/14+10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(nextt)
        
        prev = SKSpriteNode(imageName: "home", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2-screen.frame.height/14-10,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(prev)
        
    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if prev.contains(position){
            subjectNameField.removeFromSuperview()
            locationField.removeFromSuperview()
            experimenterField.removeFromSuperview()
            projectNameField.removeFromSuperview()
            context.reset()
            context.nextModel = .Home
        }
        if nextt.contains(position){
            context.userAccount = UserAccountFactory.createUserAccount(userName: "Robert", password: "")
            
            if let name = projectNameField.text{
                if name != ""{
                    context.project = TMRProjectFactory.getTMRProject(projectName: name, ID:context.userAccount.getID(), userAccount: context.userAccount)
                    context.userAccount.setID(ID: context.userAccount.getID()+1)
                }else{
                    context.project = TMRProjectFactory.getTMRProject(projectName: "Untitled", ID:context.userAccount.getID(),userAccount: context.userAccount)
                    context.userAccount.setID(ID: context.userAccount.getID()+1)
                }
            }else{
                context.project = TMRProjectFactory.getTMRProject(projectName: "Untitled",ID:context.userAccount.getID(),userAccount: context.userAccount)
                context.userAccount.setID(ID: context.userAccount.getID()+1)
            }
            
            if let subject = subjectNameField.text{
                if subject != ""{
                    context.project.setSubject(name: subject)
                }else{
                    context.project.setSubject(name: "Not Set")
                }
            }else{context.project.setSubject(name: "Not Set")}
            
            if let location = locationField.text{
                if location != ""{
                    context.project.setLocation(name: location)
                }else{
                    context.project.setLocation(name: "Not Set")
                }
            }else{context.project.setLocation(name: "Not Set")}
            
            if let experimenter = experimenterField.text{
                if experimenter != ""{
                    context.project.setExperimenter(name: experimenter)
                }else{
                    context.project.setExperimenter(name: "Not Set")
                }
            }else{context.project.setExperimenter(name: "Not Set")}
            
            subjectNameField.removeFromSuperview()
            locationField.removeFromSuperview()
            experimenterField.removeFromSuperview()
            projectNameField.removeFromSuperview()
            
            context.setupPassed[0] = true
            context.nextModel = .ExpData
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){
        
    }
}
