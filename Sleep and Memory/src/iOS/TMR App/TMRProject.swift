//
//  TMRRecord.swift
//  TMR App
//
//  Created by Robert Zhang on 6/15/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

protocol TMRProject {
    //Explicit Exported Data
    //projectID
    func getTMRID()->String
    func setTMRID(ID:String)
    //projectName
    func getTMRProjectTuple() -> TMRProjectTuple
    func setTMRProjectTuple(tuple : TMRProjectTuple)
    func getTMRProjectName() -> String
    func setTMRProjectName(name:String)
    //subject
    func getSubject() -> String
    func setSubject(name:String)
    //experimenter
    func getExperimenter() -> String
    func setExperimenter(name:String)
    //comments
    func getTMRProjectNote() -> String
    func setTMRProjectNote(note:String)
    //location
    func getLocation() -> String
    func setLocation(name:String)
    //displayDevice
    func getDisplayDevice() -> String
    func setDisplayDevice(name:String)
    //deviceOrientation
    func getDeviceOrientation() -> String
    func setDeviceOrientation(name:String)
    //JSONVersion
    func getJSON()->String
    func setJSON(name:Float)
    //SoftwareVersion
    func getSoftware()->String
    func setSoftware(name:Float)
    
    //SetupPass
    func getSetupPassed()->[Int]
    func setSetupPassed(array:[Int])
    
    func getIsAuto()->Bool
    func setIsAuto(bool:Bool)
    
    //Other Data
    func setExperimentCompleted()
    func getExperimentCompleted() -> Bool
    func getTMRResource()-> TMRResource
    func setTMRResource(resource:TMRResource)
    func setTMRResource(resourceName:String)
    func getGuiSetting() -> GuiSetting
    func setGuiSetting(guiSetting : GuiSetting)
    func getUser() -> UserAccount
    func setUser(user : UserAccount )
    func getPictureName(resourceIndex : Int) -> String
    func getAudioUrl(resourceIndex : Int) -> URL?
    func getSoundName(resourceIndex : Int) -> String
    func getIsTargeted(resourceIndex : Int) -> Bool
    func setIsTargeted(resourceIndex : Int, isTargeted : Bool)
    func setResultForTestBeforeSleep(resourceIndex:Int, result:Bool)
    func setResultForTestAfterSleep(resourceIndex:Int, result:Bool)
    func getNickName(resourceIndex : Int)->String
    
    func getNumOfEntries() -> Int
    func setResourceIndexEntries(resourceIndexEntries : [Int])
    func getResourceIndexEntries() -> [Int]
    func setTargetIndexEntries(resourceIndexEntries : [Int])
    func getTargetIndexEntries() -> [Int]
    func getPosition(resourceIndex : Int) -> (Int, Int)
    func setPosition(resourceIndex : Int, posX : Int, posY : Int)
    func getBasedSoundNames() -> [String]
    func getBasedSoundsForTargeted() -> [URL]
    
    func getPreNapEntries() -> TMRExportAllEntry
    func getPostNapEntries() -> TMRExportAllEntry
    
    //Statistics
    //Round 1
    func getDistance1(resourceIndex : Int) -> Float
    func setDistance1(resourceIndex:Int, distance : Float )
    func getDistancePercent1(resourceIndex : Int) -> Float
    func setDistancePercent1(resourceIndex:Int, distancePercent : Float )
    func getDistanceCM1(resourceIndex:Int)->Float
    func setDistanceCM1(resourceIndex:Int,distanceCM:Float)
    func getTimeBegin1(resourceIndex:Int)->String
    func getTimeBegin1(resourceIndex:Int)->Date
    func setTimeBegin1(resourceIndex:Int,time:Date)
    func getReactionTime1(resourceIndex:Int)->Float
    func setReactionTime1(resourceIndex:Int,time:Float)
    func getX1(resourceIndex:Int)->Int
    func setX1(resourceIndex:Int,x:Int)
    func getY1(resourceIndex:Int)->Int
    func setY1(resourceIndex:Int,y:Int)
    func getIsCorrect1(resourceIndex:Int)->Bool
    func setIsCorrect1(resourceIndex:Int,correct:Bool)
    func getTimeStart1()->String
    func setTimeStart1(time:Date)
    func getTimeEnd1()->String
    func setTimeEnd1(time:Date)
    func getPercentOfCorrection1() -> Int
    func getNumOfCorrectRecords1() -> Int
    
    //Round 2
    func getDistance2(resourceIndex : Int) -> Float
    func setDistance2(resourceIndex:Int, distance : Float )
    func getDistancePercent2(resourceIndex : Int) -> Float
    func setDistancePercent2(resourceIndex:Int, distancePercent : Float )
    func getDistanceCM2(resourceIndex:Int)->Float
    func setDistanceCM2(resourceIndex:Int,distanceCM:Float)
    func getTimeBegin2(resourceIndex:Int)->String
    func getTimeBegin2(resourceIndex:Int)->Date
    func setTimeBegin2(resourceIndex:Int,time:Date)
    func getReactionTime2(resourceIndex:Int)->Float
    func setReactionTime2(resourceIndex:Int,time:Float)
    func getX2(resourceIndex:Int)->Int
    func setX2(resourceIndex:Int,x:Int)
    func getY2(resourceIndex:Int)->Int
    func setY2(resourceIndex:Int,y:Int)
    func getIsCorrect2(resourceIndex:Int)->Bool
    func setIsCorrect2(resourceIndex:Int,correct:Bool)
    func getTimeStart2()->String
    func setTimeStart2(time:Date)
    func getTimeEnd2()->String
    func setTimeEnd2(time:Date)
    func getPercentOfCorrection2() -> Int
    func getNumOfCorrectRecords2() -> Int
    
    //PrenapTest
    func getDistanceBeforeSleep(resourceIndex : Int) -> Float
    func setDistanceBeforeSleep(resourceIndex:Int, distance : Float )
    func getDistancePercentBeforeSleep(resourceIndex : Int) -> Float
    func setDistancePercentBeforeSleep(resourceIndex:Int, distancePercent : Float )
    func getDistanceCMBeforeSleep(resourceIndex:Int)->Float
    func setDistanceCMBeforeSleep(resourceIndex:Int,distanceCM:Float)
    func getTimeBeginBeforeSleep(resourceIndex:Int)->String
    func getTimeBeginBeforeSleep(resourceIndex:Int)->Date
    func setTimeBeginBeforeSleep(resourceIndex:Int,time:Date)
    func getReactionTimeBeforeSleep(resourceIndex:Int)->Float
    func setReactionTimeBeforeSleep(resourceIndex:Int,time:Float)
    func getXBeforeSleep(resourceIndex:Int)->Int
    func setXBeforeSleep(resourceIndex:Int,x:Int)
    func getYBeforeSleep(resourceIndex:Int)->Int
    func setYBeforeSleep(resourceIndex:Int,y:Int)
    func getIsCorrectBeforeSleep(resourceIndex:Int)->Bool
    func setIsCorrectBeforeSleep(resourceIndex:Int,correct:Bool)
    func getTimeStartBeforeSleep()->String
    func setTimeStartBeforeSleep(time:Date)
    func getTimeEndBeforeSleep()->String
    func setTimeEndBeforeSleep(time:Date)
    
    func getNumOfCorrectRecordsBeforeSleep() -> Int
    func getNumOfCorrectRecordsBeforeSleepForTargeted() -> Int
    func getPercentOfCorrectionBeforeSleep() -> Int
    func getPercentOfCorrectionBeforeSleepForUnTargeted() -> Int
    func getPercentOfCorrectionBeforeSleepForTargeted() -> Int
    
    //PostnapTest
    func getDistanceAfterSleep(resourceIndex : Int) -> Float
    func setDistanceAfterSleep(resourceIndex:Int, distance : Float )
    func getDistancePercentAfterSleep(resourceIndex : Int) -> Float
    func setDistancePercentAfterSleep(resourceIndex:Int, distancePercent : Float )
    func getDistanceCMAfterSleep(resourceIndex:Int)->Float
    func setDistanceCMAfterSleep(resourceIndex:Int,distanceCM:Float)
    func getTimeBeginAfterSleep(resourceIndex:Int)->String
    func getTimeBeginAfterSleep(resourceIndex:Int)->Date
    func setTimeBeginAfterSleep(resourceIndex:Int,time:Date)
    func getReactionTimeAfterSleep(resourceIndex:Int)->Float
    func setReactionTimeAfterSleep(resourceIndex:Int,time:Float)
    func getXAfterSleep(resourceIndex:Int)->Int
    func setXAfterSleep(resourceIndex:Int,x:Int)
    func getYAfterSleep(resourceIndex:Int)->Int
    func setYAfterSleep(resourceIndex:Int,y:Int)
    func getIsCorrectAfterSleep(resourceIndex:Int)->Bool
    func setIsCorrectAfterSleep(resourceIndex:Int,correct:Bool)
    func getTimeStartAfterSleep()->String
    func setTimeStartAfterSleep(time:Date)
    func getTimeEndAfterSleep()->String
    func setTimeEndAfterSleep(time:Date)
    
    func getNumOfCorrectRecordsAfterSleep() -> Int
    func getNumOfCorrectRecordsAfterSleepForTargeted() -> Int
    func getPercentOfCorrectionAfterSleep() -> Int
    func getPercentOfCorrectionAfterSleepForUnTargeted() -> Int
    func getPercentOfCorrectionAfterSleepForTargeted() -> Int
    
    //Cueing
    func getCueTimeBegin() -> String
    func setCueTimeBegin(time:Date)
    func getCueTimeEnd() -> String
    func setCueTimeEnd(time:Date)
    func getSubjectNapped() -> Int
    func setSubjectNapped(num:Int)
    func getCueTimeBegin2() -> String
    func setCueTimeBegin2(time:Date)
    func getCueTimeEnd2() -> String
    func setCueTimeEnd2(time:Date)
    //
    /*
     func toJSON() -> [String:Any]
     func fromJson (dictionary : [String : Any])
     */
    
    func getBeginTime () -> String
    func setBeginTime(beginTime:Date)
    func setBeginTime(beginTime:String)
    func getEndTime () -> String
    func setEndTime(endTime:Date)
    func setEndTime(endTime:String)
    
    func getControlArray()->[Double]
    func setControlArray(array:[Double])
}
