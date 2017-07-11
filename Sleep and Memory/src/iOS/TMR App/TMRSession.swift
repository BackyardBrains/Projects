//
//  TMRExport.swift
//  TMR App
//
//  Created by Robert Zhang on 6/29/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import EVReflection

class Session:EVObject{
    var projectName = ""
    var subject = ""
    var experimenter = ""
    var timeBegin = ""
    var timeEnd = ""
    var comments = ""
    var location = ""
    var displayDevice = ""
    var displayOrientation = ""
    var version:Version
    var targets:[Target] = []
    var training:Training
    var testing:[Testing] = []
    var treatment:Treatment
    
    init(project:TMRProject){
        projectName = project.getTMRProjectName()
        subject = project.getSubject()
        experimenter = project.getExperimenter()
        timeBegin = project.getBeginTime()
        timeEnd = project.getEndTime()
        comments = project.getTMRProjectNote()
        location = project.getLocation()
        displayDevice = project.getDisplayDevice()
        displayOrientation = project.getDeviceOrientation()
        version = Version(project: project)
        
        for num in project.getResourceIndexEntries(){
            let target = Target(project: project, ID: num)
            targets.append(target)
        }

        training = Training(project: project)
        
        for num in 1...4{
            let test = Testing(project: project, num: num)
            testing.append(test)
        }
        
        treatment = Treatment(project: project)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class Version:EVObject{
    var json = ""
    var software = ""
    
    init(project:TMRProject){
        json = project.getJSON()
        software = project.getSoftware()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class Target:EVObject{
    var targetID = 0
    var picture = ""
    var sound = ""
    var x:Float = 0
    var y:Float = 0
    
    init(project:TMRProject,ID:Int){
        targetID = ID
        picture = "p\(ID+1)"
        sound = "s\(ID+1)"
        x = Float(project.getPosition(resourceIndex: ID).0)
        y = Float(project.getPosition(resourceIndex: ID).1)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class Training:EVObject{
    var trialIDs:[Int] = []
    var displayLength = 0
    var interTrialInterval = 0
    
    init(project:TMRProject){
        displayLength = project.getGuiSetting().getTrainingInterval()
        interTrialInterval = project.getGuiSetting().getInterTrainingInterval()
        trialIDs = project.getResourceIndexEntries()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
}

class Testing:EVObject{
    var feedback = 0
    var preTreatment = 0
    var timeBegin = ""
    var timeEnd = ""
    var trials:[Trials] = []
    
    init(project:TMRProject,num:Int){
        if num == 1 || num == 2{
            feedback = 1
        }else{
            feedback = 0
        }
        if num<=3{
            preTreatment = 1
        }else{
            preTreatment = 0
        }
        
        if num == 1{
            timeBegin = project.getTimeStart1()
            timeEnd = project.getTimeEnd1()
        }
        
        if num == 2{
            timeBegin = project.getTimeStart2()
            timeEnd = project.getTimeEnd2()
        }
        
        if num == 3{
            timeBegin = project.getTimeStartBeforeSleep()
            timeEnd = project.getTimeEndBeforeSleep()
        }
        
        if num == 4{
            timeBegin = project.getTimeStartAfterSleep()
            timeEnd = project.getTimeEndAfterSleep()
        }
        
        for ID in project.getResourceIndexEntries(){
            let trial = Trials(project: project, ID: ID, num:num)
            trials.append(trial)
        }
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class Trials:EVObject{
    var targetID = 0
    var x = 0
    var y = 0
    var isCorrect:Int = 0
    var reactionTime:Float = 0
    var distanceInPoints:Float = 0
    var distanceInPercentageOfScreen:Float = 0
    var distanceInCM:Float = 0
    var timeBegin = ""
    
    init(project:TMRProject,ID:Int,num:Int){
        targetID = ID
        if num == 1{
            let tempCorrect = project.getIsCorrect1(resourceIndex: ID)
            if tempCorrect{isCorrect = 1}else{isCorrect = 0}
            x = project.getX1(resourceIndex: ID)
            y = project.getY1(resourceIndex: ID)
            reactionTime = project.getReactionTime1(resourceIndex: ID)
            distanceInPoints = project.getDistance1(resourceIndex: ID)
            distanceInPercentageOfScreen = project.getDistancePercent1(resourceIndex: ID)
            distanceInCM = project.getDistanceCM1(resourceIndex: ID)
            timeBegin = project.getTimeBegin1(resourceIndex: ID)
        }
        if num == 2{
            let tempCorrect = project.getIsCorrect2(resourceIndex: ID)
            if tempCorrect{isCorrect = 1}else{isCorrect = 0}
            x = project.getX2(resourceIndex: ID)
            y = project.getY2(resourceIndex: ID)
            reactionTime = project.getReactionTime2(resourceIndex: ID)
            distanceInPoints = project.getDistance2(resourceIndex: ID)
            distanceInPercentageOfScreen = project.getDistancePercent2(resourceIndex: ID)
            distanceInCM = project.getDistanceCM2(resourceIndex: ID)
            timeBegin = project.getTimeBegin2(resourceIndex: ID)
        }
        if num == 3{
            let tempCorrect = project.getIsCorrectBeforeSleep(resourceIndex: ID)
            if tempCorrect{isCorrect = 1}else{isCorrect = 0}
            x = project.getXBeforeSleep(resourceIndex: ID)
            y = project.getYBeforeSleep(resourceIndex: ID)
            reactionTime = project.getReactionTimeBeforeSleep(resourceIndex: ID)
            distanceInPoints = project.getDistanceBeforeSleep(resourceIndex: ID)
            distanceInPercentageOfScreen = project.getDistancePercentBeforeSleep(resourceIndex: ID)
            distanceInCM = project.getDistanceCMBeforeSleep(resourceIndex: ID)
            timeBegin = project.getTimeBeginBeforeSleep(resourceIndex: ID)
        }
        if num == 4{
            let tempCorrect = project.getIsCorrectAfterSleep(resourceIndex: ID)
            if tempCorrect{isCorrect = 1}else{isCorrect = 0}
            x = project.getXAfterSleep(resourceIndex: ID)
            y = project.getYAfterSleep(resourceIndex: ID)
            reactionTime = project.getReactionTimeAfterSleep(resourceIndex: ID)
            distanceInPoints = project.getDistanceAfterSleep(resourceIndex: ID)
            distanceInPercentageOfScreen = project.getDistancePercentAfterSleep(resourceIndex: ID)
            distanceInCM = project.getDistanceCMAfterSleep(resourceIndex: ID)
            timeBegin = project.getTimeBeginAfterSleep(resourceIndex: ID)
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class Treatment:EVObject{
    //var timeBegin = ""
    //var timeEnd = ""
    var subjectNapped = 0
    var timeCueBegin = ""
    var timeCueEnds = ""
    var interSoundInterval = 0
    
    var cuedTargetIDs:[Int] = []
    var uncuedTargetIDs:[Int] = []
    var baselineTargetIDs:[Int] = []
    var percentCorrectControl:[Double] = []
    
    init(project:TMRProject){
        //timeBegin = project.getCueTimeBegin()
        //timeEnd = project.getCueTimeEnd()
        timeCueBegin = project.getCueTimeBegin2()
        timeCueEnds = project.getCueTimeEnd2()
        subjectNapped = project.getSubjectNapped()
        interSoundInterval = project.getGuiSetting().getSleepInterval()
        
        cuedTargetIDs = project.getTargetIndexEntries()
        let IDs = project.getResourceIndexEntries()
        var uncued:[Int] = []
        for id in IDs{
            var isIn = false
            for id2 in cuedTargetIDs{
                if id == id2{
                    isIn = true
                }
            }
            if !isIn{
                uncued.append(id)
            }
        }
        uncuedTargetIDs = uncued
        
        for string in project.getBasedSoundNames(){
            let index = string.index(string.startIndex,offsetBy:1)
            let new = string.substring(from: index)
            let index2 = new.index(new.endIndex,offsetBy:-4)
            let new2 = Int(new.substring(to: index2))!
            baselineTargetIDs.append(new2)
        }
        if project.getControlArray() != [0,0,0,0]{
            percentCorrectControl = project.getControlArray()
        }
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}


