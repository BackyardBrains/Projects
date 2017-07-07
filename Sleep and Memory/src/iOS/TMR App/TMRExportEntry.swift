//
//  TMRExportEntry.swift
//  TMR App
//
//  Created by Robert Zhang on 6/20/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class TMRExportEntry {
    var pictureName:String
    var soundName:String
    var isCorrect:Bool = false
    var distance:Float = 0
    var distancePercent:Float = 0
    var baseSoundName:String = "baseline.wave"
    
    init(pictureName : String?, soundName : String?, isCorrect : Bool?,
        distance : Float?,  distancePercent : Float?, baseSoundName : String?) {
        self.pictureName = pictureName!
        self.soundName = soundName!
        self.isCorrect = isCorrect!
        self.distance = distance!
        self.distancePercent = distancePercent!
        self.baseSoundName = baseSoundName!
    }
    
    func toJSON() -> [String:Any] {
        var dictionary: [String : Any] = [:]
        
        dictionary["pictureName"] = pictureName
        dictionary["soundName"] = soundName
        if ( self.isCorrect ) {
            dictionary["isCorrect"] = "True"
        }
        else {
            dictionary["isCorrect"] = "False"
        }
        dictionary["distance"] = "\(self.distance)"
        dictionary["distancePercent"] = "\(self.distancePercent)%"
        dictionary["baseSoundName"] = self.baseSoundName
        return dictionary
    }
    
}

class TMRExportAllEntry {
    var listTargetedEntries : [TMRExportEntry] = [TMRExportEntry]()
    var listUnTargetedEntries : [TMRExportEntry] = [TMRExportEntry]()
    
    
    func toJSON() -> [String:Any] {
        
        var dictionary: [String : Any] = [:]
        
        var targetDictionary : [String : Any] = [:]
        var targetsDictionary: [String : Any] = [:]
        
        print("TMRExportAllEntry:toJSON(): before list encoding")
        for i in 0..<listTargetedEntries.count {
            targetsDictionary["picture \(listTargetedEntries[i].pictureName)"] = listTargetedEntries[i].toJSON()
        }
        targetDictionary["list entries"] = targetsDictionary
        targetDictionary["targeted list correct percentage"] = "\(getCorrectPercentage(listEntries: listTargetedEntries))%)"
        dictionary["targeted list"] = targetDictionary
        
        var unTargetDictionary: [String : Any] = [:]
        var unTargetsDictionary: [String : Any] = [:]
        
        for i in 0..<listUnTargetedEntries.count {
            unTargetsDictionary["picture \(listUnTargetedEntries[i].pictureName)"] = listUnTargetedEntries[i].toJSON()
        }
        
        unTargetDictionary["list entries"] = unTargetsDictionary
        unTargetDictionary["untargeted list correct percentage"] = "\(getCorrectPercentage(listEntries: listUnTargetedEntries))%)"
        
        dictionary["untargeted list"] = unTargetDictionary
        
        return dictionary
    }
    
    func getCorrectPercentage(listEntries : [TMRExportEntry]) -> Float {
        var correctCount:Int = 0;
        for i in 0..<listEntries.count {
            if listEntries[i].isCorrect {
                correctCount = correctCount + 1
            }
        }
        return ( (Float)(correctCount*100)/(Float)(listEntries.count))
    }
    
    func getTotalCorrectPercentage() -> Float {
        var correctCount:Int = 0;
        for i in 0..<listTargetedEntries.count {
            if listTargetedEntries[i].isCorrect {
                correctCount = correctCount + 1
            }
        }
        for i in 0..<listUnTargetedEntries.count {
            if listUnTargetedEntries[i].isCorrect {
                correctCount = correctCount + 1
            }
        }
        
        return ( (Float)(correctCount*100)/(Float)(listTargetedEntries.count + listUnTargetedEntries.count))
    }
}

class TMRExportProject {
    var projectName : String
    var listPreNapEntries : TMRExportAllEntry
    var listPostNapEntries : TMRExportAllEntry
    
    init(projectName : String, listPreNapEntries : TMRExportAllEntry, listPostNapEntries: TMRExportAllEntry) {
        self.projectName = projectName;
        self.listPreNapEntries = listPreNapEntries
        self.listPostNapEntries = listPostNapEntries
    }
    
    func toJSON() -> [String:Any] {
        
        var dictionary: [String : Any] = [:]
        
        dictionary["projectName"] = projectName
        dictionary["pre nap result"] = listPreNapEntries.toJSON()
        dictionary["pre nap correct percentage"] = "\(listPreNapEntries.getTotalCorrectPercentage())%)"
        
        dictionary["post nap result"] = listPostNapEntries.toJSON()
        dictionary["post nap correct percentage"] = "\(listPostNapEntries.getTotalCorrectPercentage()))%)"
        
        return dictionary
    }
    
}

class TMRExportAllProjects {
    var listProjects : [TMRExportProject] = [TMRExportProject]()
    
    func toJSON() -> [String:Any] {
        var dictionary: [String : Any] = [:]
        
        
        var projectsDictionary: [String : Any] = [:]
        
        for i in 0..<listProjects.count {
            projectsDictionary["\(i)"] = listProjects[i].toJSON()
        }
        dictionary["project list"] = projectsDictionary
        
        return dictionary
    
    }
    
    func addProject(project:TMRExportProject) {
        listProjects.append(project)
    }
    
    
}
