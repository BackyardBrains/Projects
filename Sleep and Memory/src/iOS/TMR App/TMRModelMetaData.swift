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
    
    var next = SKSpriteNode()
    override func begin(screen : TMRScreen, context : TMRContext,view:SKView) {
        super.begin(screen: screen, context: context)
        screen.clearScreen()
        
        let bg = SKSpriteNode(color: UIColor(red:40/255,green:44/255,blue:52/255,alpha:1), width: screen.frame.width, height: screen.frame.height, anchorPoint: CGPoint(x:0,y:0), position: CGPoint(x:0,y:0), zPosition: 0, alpha: 1)
        screen.addChild(bg)

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
        
        next = SKSpriteNode(imageName: "NextIcon", ySize: screen.frame.height/7, anchorPoint: CGPoint(x:0.5,y:0.5), position: CGPoint(x:screen.frame.width/2,y:screen.frame.height*0.3), zPosition: 2, alpha: 1)
        screen.addChild(next)

    }
    
    override func timerTick(screen : TMRScreen, context : TMRContext) {
        
    }
    
    override func touch(screen : TMRScreen, context:TMRContext, position: CGPoint) {
        if next.contains(position){
            context.userAccount = UserAccountFactory.createUserAccount(userName: "Robert", password: "")
            context.project = TMRProjectFactory.getTMRProject(userAccount : context.userAccount)
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
            
            if let name = projectNameField.text{
                if name != ""{
                    context.project.setTMRProjectName(name: name)
                }else{
                    context.project.setTMRProjectName(name: "Untitled")
                }
            }else{context.project.setTMRProjectName(name: "Untitled")}
            
            subjectNameField.removeFromSuperview()
            locationField.removeFromSuperview()
            experimenterField.removeFromSuperview()
            projectNameField.removeFromSuperview()
            
            context.nextModel = .ExpData
            
            print(context.project.getSubject())
            print(context.project.getExperimenter())
            print(context.project.getLocation())
            print(context.project.getTMRProjectName())
        }
    }
    
    override func end(screen : TMRScreen, context : TMRContext){

    }
}
