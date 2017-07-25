//
//  TMRRecordImpl.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import EVReflection

class TMRProjectTuple : EVObject {
    var tmrProjectName : String = ""
    var tmrID:String = "proj0"
    var subject:String = ""
    var experimenter:String = ""
    var timeBegin:String = ""
    var timeEnd:String = ""
    var tmrNote : String = ""
    var location:String = ""
    var displayDevice:String = ""
    var deviceOrientation:String = ""
    
    var setupPassed:[Int] = [0,0,0,0,0,0,0,0] //0meta,1expdata,2timing,3expop,4cueingset,5auto,6manual,7settings
    
    var tmrResourceName:String = "default"
    var userAccountName : String = "Robert"
    var guiSetting : GuiSetting = GuiSetting()
    var tmrEntries : [TMREntry] = []
    var experimentCompleted:Bool = false
    var beginTime : String = ""
    var endTime : String = ""
    
    var JSONVersion:String = ""
    var software:String = ""
    
    var timeStart1:String = ""
    var timeEnd1:String = ""
    var timeStart2:String = ""
    var timeEnd2:String = ""
    var timeStartBeforeSleep:String = ""
    var timeEndBeforeSleep:String = ""
    var timeStartAfterSleep:String = ""
    var timeEndAfterSleep:String = ""
    
    
    var cueTimeBegin:String = ""
    var cueTimeEnd:String = ""
    var cueTimeBegin2:String = ""
    var cueTimeEnd2:String = ""
    var subjectNapped:Int = 1
    
    var isAuto = true
}

class TMRProjectImpl : TMRProject,NSCopying {
    var projectTuple : TMRProjectTuple = TMRProjectTuple()
    
    var tmrResource : TMRResource
    var user : UserAccount?
    var controlArray:[Double] = [0,0,0,0]
    
    func getTMRProjectTuple() -> TMRProjectTuple { return projectTuple }
    func setTMRProjectTuple(tuple : TMRProjectTuple) { projectTuple = tuple }
    func getTMRProjectName() -> String { return projectTuple.tmrProjectName}
    func setTMRProjectName(name:String) { projectTuple.tmrProjectName = name}
    func getTMRID()->String{return projectTuple.tmrID}
    func setTMRID(ID:String){projectTuple.tmrID = ID}
    func getSubject() -> String {return projectTuple.subject}
    func setSubject(name: String) {projectTuple.subject = name}
    func getExperimenter() -> String {return projectTuple.experimenter}
    func setExperimenter(name: String) {projectTuple.experimenter = name}
    func getTMRProjectNote() -> String { return projectTuple.tmrNote}
    func setTMRProjectNote(note:String) { projectTuple.tmrNote = note}
    func getLocation() -> String {return projectTuple.location}
    func setLocation(name: String) {projectTuple.location = name}
    func getDisplayDevice() -> String {return projectTuple.displayDevice}
    func setDisplayDevice(name: String) {projectTuple.displayDevice = name}
    func getDeviceOrientation() -> String {return projectTuple.deviceOrientation}
    func setDeviceOrientation(name: String) {projectTuple.deviceOrientation = name}
    func getSetupPassed()->[Int] {return projectTuple.setupPassed}
    func setSetupPassed(array:[Int]) {projectTuple.setupPassed = array}
    
    func getTMRResource()-> TMRResource { return tmrResource}
    func setTMRResource(resource:TMRResource) { tmrResource = resource }
    
    func getJSON()->String{return projectTuple.JSONVersion}
    func setJSON(name:Float) {
        projectTuple.guiSetting.setJSONVersion(version: name)
        let version = "Version \(projectTuple.guiSetting.getJSONVersion())"
        projectTuple.JSONVersion = version
    }
    
    func copy(with zone:NSZone? = nil)->Any{
        let copy = TMRProjectImpl(tuple: getTMRProjectTuple())
        return copy
    }
    
    func getSoftware()->String{return projectTuple.software}
    func setSoftware(name:Float) {
        projectTuple.guiSetting.setSoftwareVersion(version: name)
        let version = "Mark \(projectTuple.guiSetting.getSoftwareVersion())"
        projectTuple.software = version
    }
    
    init(tuple : TMRProjectTuple) {
        projectTuple = tuple
        tmrResource = TMRResourceFactory.getTMRResource(resourceName: tuple.tmrResourceName)
        self.user = UserAccountFactory.getUserAccount(userName: tuple.userAccountName)
        findDisplayDevice()
        findDisplayOrientation()
        setJSON(name: (projectTuple.guiSetting.getJSONVersion()))
        setSoftware(name: (projectTuple.guiSetting.getSoftwareVersion()))
        self.user?.addTMRRecord(project: self)
        
    }
    
    init(projectName:String, ID:String, user : UserAccount) {
        projectTuple.tmrProjectName = projectName;
        projectTuple.userAccountName = user.getUserName()
        projectTuple.tmrID = ID
        tmrResource = TMRResourceFactory.getTMRResource()
        projectTuple.tmrResourceName = tmrResource.getResourceName()
        self.user = UserAccount(userName: user.getUserName(), password: user.getPassword())
        projectTuple.guiSetting = user.getGuiSetting().copy() as! GuiSetting
        findDisplayDevice()
        findDisplayOrientation()
        setJSON(name: (projectTuple.guiSetting.getJSONVersion()))
        setSoftware(name: (projectTuple.guiSetting.getSoftwareVersion()))
    }
    
    init(projectName:String, resourceName:String, user : UserAccount) {
        projectTuple.tmrProjectName = projectName;
        projectTuple.userAccountName = user.getUserName()
        tmrResource = TMRResourceFactory.getTMRResource(resourceName: resourceName);
        projectTuple.tmrResourceName = tmrResource.getResourceName()
        self.user = UserAccount(userName: user.getUserName(), password: user.getPassword())
        projectTuple.guiSetting = user.getGuiSetting().copy() as! GuiSetting
        findDisplayDevice()
        findDisplayOrientation()
        setJSON(name: (projectTuple.guiSetting.getJSONVersion()))
        setSoftware(name: (projectTuple.guiSetting.getSoftwareVersion()))
    }
    
    init() {
        projectTuple.tmrProjectName = "projectName";
        tmrResource = TMRResourceFactory.getTMRResource();
        projectTuple.tmrResourceName = tmrResource.getResourceName()
        user = UserAccount()
        projectTuple.userAccountName = (user?.getUserName())!
        projectTuple.guiSetting = GuiSetting()
        findDisplayDevice()
        findDisplayOrientation()
        setJSON(name: (projectTuple.guiSetting.getJSONVersion()))
        setSoftware(name: (projectTuple.guiSetting.getSoftwareVersion()))
    }
    
    func setIsAuto(bool: Bool) {
        projectTuple.isAuto = bool
    }
    func getIsAuto() -> Bool {
        return projectTuple.isAuto
    }
    
    func getControlArray() -> [Double] {
        return controlArray
    }
    
    func setControlArray(array: [Double]) {
        controlArray = array
    }
    
    func findDisplayDevice(){
        let device = UIDevice.current.modelName
        setDisplayDevice(name: device)
    }
    
    func findDisplayOrientation(){
        var orientation = ""
        let orient = UIApplication.shared.statusBarOrientation
        if orient == UIInterfaceOrientation.landscapeLeft{
            orientation = "landscapeLeft"
        }
        if orient == UIInterfaceOrientation.landscapeRight{
            orientation = "landscapeRight"
        }
        if orient == UIInterfaceOrientation.portrait{
            orientation = "portrait"
        }
        if orient == UIInterfaceOrientation.portraitUpsideDown{
            orientation = "portraitUpsideDown"
        }
        print(UIDevice.current.orientation)
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            orientation = "landscapeLeft"
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            orientation = "landscapeRight"
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            orientation = "portrait"
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            orientation = "portraitUpsideDown"
        }
        
        setDeviceOrientation(name: orientation)
    }
    
    func getTMREntry ( _ resourceIndex : Int) -> TMREntry? {
        for entry in getTMRProjectTuple().tmrEntries {
            if resourceIndex == entry.soundimageIndex {
                return entry
            }
        }
        return nil
    }
    
    func setTMREntry ( _ resourceIndex : Int, _ entry : TMREntry) {
        let tp = getTMRProjectTuple()
        for i in 0..<tp.tmrEntries.count {
            if tp.tmrEntries[i].soundimageIndex ==  resourceIndex {
                tp.tmrEntries[i] = entry
                return
            }
        }
        tp.tmrEntries.append(entry)
    }
    
    func getTMREntryKeys() -> [Int] {
        var keys : [Int] = []
        for entry in getTMRProjectTuple().tmrEntries {
            keys.append(entry.soundimageIndex)
        }
        return keys
    }
    
    func getBeginTime () -> String {
        return projectTuple.beginTime;
    }
    
    func setBeginTime(beginTime:Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: beginTime);
        projectTuple.beginTime = str;
    }
    
    func setBeginTime(beginTime:String) {
        
        projectTuple.beginTime = beginTime
    }
    
    func getEndTime () -> String {
        return projectTuple.endTime;
    }
    
    func setEndTime(endTime:Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: endTime);
        projectTuple.endTime = str;
    }
    
    func setEndTime(endTime:String) {
        
        projectTuple.endTime = endTime;
    }
    
    
    func setTMRResource(resourceName:String) {
        tmrResource = TMRResourceFactory.getTMRResource(resourceName: resourceName);
    }
    
    func setExperimentCompleted(){
        projectTuple.experimentCompleted = true
    }
    
    func getExperimentCompleted() -> Bool {
        return projectTuple.experimentCompleted
    }
    
    func getPictureName(resourceIndex : Int) -> String {
        return tmrResource.getPictureName(index: resourceIndex)
    }
    
    func getGuiSetting() -> GuiSetting {
        let guiSettingCopy : GuiSetting = projectTuple.guiSetting.copy() as! GuiSetting
        return guiSettingCopy
    }
    
    func getNickName(resourceIndex : Int)->String{
        return tmrResource.getNickName(index: resourceIndex)
    }
    
    func setGuiSetting(guiSetting : GuiSetting) {
        projectTuple.guiSetting = guiSetting.copy() as! GuiSetting
    }
    func getUser() -> UserAccount {
        return user!
    }
    func setUser(user : UserAccount ) {
        self.user = user
    }
    
    func getAudioUrl(resourceIndex : Int) -> URL? {
        return tmrResource.getAudioURL(index:resourceIndex)
    }
    
    func getSoundName(resourceIndex : Int) -> String {
        return tmrResource.getSoundName(index: resourceIndex)
    }
    
    func getIsTargeted(resourceIndex : Int) -> Bool {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getIsTargeted()
        }
        return false
    }
    
    //Round1
    func getDistance1(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistance1()
        }
        return 0
    }
    
    func setDistance1(resourceIndex:Int, distance : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistance1(distance1: distance)
        }
    }
    
    func getDistancePercent1(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistancePercent1()
        }
        return 0
    }
    
    func setDistancePercent1(resourceIndex:Int, distancePercent : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistancePercent1(distancePercent1: distancePercent)
        }
    }
    
    func getDistanceCM1(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceCM1()
        }
        return 0
    }
    
    func setDistanceCM1(resourceIndex:Int, distanceCM : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceCM1(distanceCM1: distanceCM)
        }
    }
    
    func getTimeBegin1(resourceIndex: Int) -> String {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBegin1()
        }
        return ""
    }
    
    func getTimeBegin1(resourceIndex: Int) -> Date {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBegin1Date()
        }
        return Date()
    }
    
    func setTimeBegin1(resourceIndex: Int, time: Date) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setTimeBegin1(time: time)
        }
    }
    
    func getReactionTime1(resourceIndex: Int) -> Float {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getReactionTime1()
        }
        return 0
    }
    
    func setReactionTime1(resourceIndex: Int, time: Float) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setReactionTime1(time: time)
        }
    }
    
    func getX1(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getX1()
        }
        return 0
    }
    
    func setX1(resourceIndex: Int, x: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setX1(x: x)
        }
    }
    
    func getY1(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getY1()
        }
        return 0
    }
    
    func setY1(resourceIndex: Int, y: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setY1(y: y)
        }
    }
    
    func getIsCorrect1(resourceIndex: Int) -> Bool {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getIsCorrect1()
        }
        return false
    }
    
    func setIsCorrect1(resourceIndex: Int, correct: Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrect1(correct: correct)
        }
    }
    
    func getTimeStart1() -> String {
        return projectTuple.timeStart1
    }
    
    func setTimeStart1(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeStart1 = str
    }
    
    func getTimeEnd1() -> String {
        return projectTuple.timeEnd1
    }
    
    func setTimeEnd1(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeEnd1 = str
    }
    
    //Round2
    func getDistance2(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistance2()
        }
        return 0
    }
    
    func setDistance2(resourceIndex:Int, distance : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistance2(distance2: distance)
        }
    }
    
    func getDistancePercent2(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistancePercent2()
        }
        return 0
    }
    
    func setDistancePercent2(resourceIndex:Int, distancePercent : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistancePercent2(distancePercent2: distancePercent)
        }
    }
    
    func getDistanceCM2(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceCM2()
        }
        return 0
    }
    
    func setDistanceCM2(resourceIndex:Int, distanceCM : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceCM2(distanceCM2: distanceCM)
        }
    }
    
    func getTimeBegin2(resourceIndex: Int) -> String {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBegin2()
        }
        return ""
    }
    
    func getTimeBegin2(resourceIndex: Int) -> Date {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBegin2Date()
        }
        return Date()
    }
    
    func setTimeBegin2(resourceIndex: Int, time: Date) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setTimeBegin2(time: time)
        }
    }
    
    func getReactionTime2(resourceIndex: Int) -> Float {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getReactionTime2()
        }
        return 0
    }
    
    func setReactionTime2(resourceIndex: Int, time: Float) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setReactionTime2(time: time)
        }
    }
    
    func getX2(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getX2()
        }
        return 0
    }
    
    func setX2(resourceIndex: Int, x: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setX2(x: x)
        }
    }
    
    func getY2(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getY2()
        }
        return 0
    }
    
    func setY2(resourceIndex: Int, y: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setY2(y: y)
        }
    }
    
    func getIsCorrect2(resourceIndex: Int) -> Bool {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getIsCorrect2()
        }
        return false
    }
    
    func setIsCorrect2(resourceIndex: Int, correct: Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrect2(correct: correct)
        }
    }
    
    func getTimeStart2() -> String {
        return projectTuple.timeStart2
    }
    
    func setTimeStart2(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeStart2 = str
    }
    
    func getTimeEnd2() -> String {
        return projectTuple.timeEnd2
    }
    
    func setTimeEnd2(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeEnd2 = str
    }
    
    //Prenap
    func getDistanceBeforeSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceBeforeSleep()
        }
        return 0
    }
    
    func setDistanceBeforeSleep(resourceIndex:Int, distance : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceBeforeSleep(distanceBeforeSleep: distance)
        }
    }
    
    func getDistancePercentBeforeSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistancePercentBeforeSleep()
        }
        return 0
    }
    
    func setDistancePercentBeforeSleep(resourceIndex:Int, distancePercent : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistancePercentBeforeSleep(distancePercentBeforeSleep: distancePercent)
        }
    }
    
    func getDistanceCMBeforeSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceCMBeforeSleep()
        }
        return 0
    }
    
    func setDistanceCMBeforeSleep(resourceIndex:Int, distanceCM : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceCMBeforeSleep(distanceCMBeforeSleep: distanceCM)
        }
    }
    
    func getTimeBeginBeforeSleep(resourceIndex: Int) -> String {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBeginBeforeSleep()
        }
        return ""
    }
    
    func getTimeBeginBeforeSleep(resourceIndex: Int) -> Date {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBeginBeforeSleepDate()
        }
        return Date()
    }
    
    func setTimeBeginBeforeSleep(resourceIndex: Int, time: Date) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setTimeBeginBeforeSleep(time: time)
        }
    }
    
    func getReactionTimeBeforeSleep(resourceIndex: Int) -> Float {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getReactionTimeBeforeSleep()
        }
        return 0
    }
    
    func setReactionTimeBeforeSleep(resourceIndex: Int, time: Float) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setReactionTimeBeforeSleep(time: time)
        }
    }
    
    func getXBeforeSleep(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getXBeforeSleep()
        }
        return 0
    }
    
    func setXBeforeSleep(resourceIndex: Int, x: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setXBeforeSleep(x: x)
        }
    }
    
    func getYBeforeSleep(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getYBeforeSleep()
        }
        return 0
    }
    
    func setYBeforeSleep(resourceIndex: Int, y: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setYBeforeSleep(y: y)
        }
    }
    
    func getIsCorrectBeforeSleep(resourceIndex: Int) -> Bool {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getIsCorrectBeforeSleep()
        }
        return false
    }
    
    func setIsCorrectBeforeSleep(resourceIndex: Int, correct: Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrectBeforeSleep(isCorrectBeforeSleep: correct)
        }
    }
    
    func getTimeStartBeforeSleep() -> String {
        return projectTuple.timeStartBeforeSleep
    }
    
    func setTimeStartBeforeSleep(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeStartBeforeSleep = str
    }
    
    func getTimeEndBeforeSleep() -> String {
        return projectTuple.timeEndBeforeSleep
    }
    
    func setTimeEndBeforeSleep(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeEndBeforeSleep = str
    }
    
    //Postnap
    func setDistanceAfterSleep(resourceIndex:Int, distance : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceAfterSleep(distanceAfterSleep: distance)
        }
    }
    
    
    func getDistanceAfterSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceAfterSleep()
        }
        return 0
    }
    
    func getDistancePercentAfterSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistancePercentAfterSleep()
        }
        return 0
    }
    
    func setDistancePercentAfterSleep(resourceIndex:Int, distancePercent : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistancePercentAfterSleep(distancePercentAfterSleep: distancePercent)
        }
    }
    
    func getDistanceCMAfterSleep(resourceIndex : Int) -> Float  {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getDistanceCMAfterSleep()
        }
        return 0
    }
    
    func setDistanceCMAfterSleep(resourceIndex:Int, distanceCM : Float ) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setDistanceCMAfterSleep(distanceCMAfterSleep: distanceCM)
        }
    }
    
    func getTimeBeginAfterSleep(resourceIndex: Int) -> String {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBeginAfterSleep()
        }
        return ""
    }
    
    func getTimeBeginAfterSleep(resourceIndex: Int) -> Date {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getTimeBeginAfterSleepDate()
        }
        return Date()
    }
    
    func setTimeBeginAfterSleep(resourceIndex: Int, time: Date) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setTimeBeginAfterSleep(time: time)
        }
    }
    
    func getReactionTimeAfterSleep(resourceIndex: Int) -> Float {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getReactionTimeAfterSleep()
        }
        return 0
    }
    
    func setReactionTimeAfterSleep(resourceIndex: Int, time: Float) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setReactionTimeAfterSleep(time: time)
        }
    }
    
    func getXAfterSleep(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getXAfterSleep()
        }
        return 0
    }
    
    func setXAfterSleep(resourceIndex: Int, x: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setXAfterSleep(x: x)
        }
    }
    
    func getYAfterSleep(resourceIndex: Int) -> Int {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getYAfterSleep()
        }
        return 0
    }
    
    func setYAfterSleep(resourceIndex: Int, y: Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setYAfterSleep(y: y)
        }
    }
    
    func getTimeStartAfterSleep() -> String {
        return projectTuple.timeStartAfterSleep
    }
    
    func setTimeStartAfterSleep(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeStartAfterSleep = str
    }
    
    func getIsCorrectAfterSleep(resourceIndex: Int) -> Bool {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getIsCorrectAfterSleep()
        }
        return false
    }
    
    func setIsCorrectAfterSleep(resourceIndex: Int, correct: Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrectAfterSleep(isCorrectAfterSleep: correct)
        }
    }
    
    func getTimeEndAfterSleep() -> String {
        return projectTuple.timeEndAfterSleep
    }
    
    func setTimeEndAfterSleep(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.timeEndAfterSleep = str
    }
    
    ////////
    
    func setIsTargeted(resourceIndex : Int, isTargeted : Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsTargeted(isTargeted: isTargeted)
        }
    }
    
    func setResultForTestBeforeSleep(resourceIndex:Int, result:Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrectBeforeSleep(isCorrectBeforeSleep: result)
        }
    }
    
    func setResultForTestAfterSleep(resourceIndex:Int, result:Bool) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setIsCorrectAfterSleep(isCorrectAfterSleep: result)
        }
    }
    
    //
    
    func getCueTimeBegin() -> String {
        return projectTuple.cueTimeBegin
    }
    func setCueTimeBegin(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.cueTimeBegin = str
    }
    func getCueTimeEnd() -> String {
        return projectTuple.cueTimeEnd
    }
    func setCueTimeEnd(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.cueTimeEnd = str
    }
    func getCueTimeBegin2() -> String {
        return projectTuple.cueTimeBegin2
    }
    func setCueTimeBegin2(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.cueTimeBegin2 = str
    }
    func getCueTimeEnd2() -> String {
        return projectTuple.cueTimeEnd2
    }
    func setCueTimeEnd2(time: Date) {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        projectTuple.cueTimeEnd2 = str
    }
    func getSubjectNapped() -> Int {
        return projectTuple.subjectNapped
    }
    func setSubjectNapped(num: Int) {
        projectTuple.subjectNapped = num
    }
    
    func getNumOfCorrectRecordsBeforeSleep() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectBeforeSleep()) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsBeforeSleep: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecordsAfterSleep() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectAfterSleep()) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsAfterSleep: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecordsBeforeSleepForTargeted() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectBeforeSleep() && tmrEntry.getIsTargeted() ) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsBeforeSleepForTargeted: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecordsAfterSleepForTargeted() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectAfterSleep() && tmrEntry.getIsTargeted()) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsAfterSleepForTargeted: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecordsBeforeSleepForUnTargeted() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectBeforeSleep() && (!tmrEntry.getIsTargeted()) ) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsBeforeSleepForTargeted: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecordsAfterSleepForUnTargeted() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrectAfterSleep() && (!tmrEntry.getIsTargeted()) ) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecordsAfterSleepForTargeted: \(ret)")
        return ret
    }
    
    func getNumOfEntries() -> Int {
        return projectTuple.tmrEntries.count
    }
    
    func setResourceIndexEntries(resourceIndexEntries : [Int]) {
        projectTuple.tmrEntries.removeAll()
        for i in 0..<resourceIndexEntries.count {
            let resourceIndex = resourceIndexEntries[i]
            print("resourceIndex is \(resourceIndex)")
            let tmrEntry = TMREntry(resourceEntryIndex : resourceIndex)
            setTMREntry(resourceIndex, tmrEntry)
        }
    }
    
    func getResourceIndexEntries() -> [Int] {
        var retEntries = [Int]()
        for resourceIndex in getTMREntryKeys() {
            retEntries.append(resourceIndex)
        }
        return retEntries
    }
    
    
    
    func setTargetIndexEntries(resourceIndexEntries : [Int]) {
        for i in 0..<resourceIndexEntries.count {
            let resourceIndex = resourceIndexEntries[i]
            print("resourceIndex is \(resourceIndex)")
            if let tmrEntry = getTMREntry(resourceIndex)  {
                tmrEntry.setIsTargeted(isTargeted: true)
            }
        }
        
        setTargetedBaseSounds()
        
    }
    
    func setTargetedBaseSounds() {
        print("setTargetedBaseSound entered")
        var unSelectedResourceIndexEntries = getUnSelectedResourceIndexEntries()
        print("unSelectedResourceIndexEntries count is \(unSelectedResourceIndexEntries.count)")
        
        let targetedIndexEntries : [Int] = getTargetIndexEntries()
        
        var numOfBaseSoundSetForTargeted = 0;
        
        while ( numOfBaseSoundSetForTargeted < targetedIndexEntries.count ) {
            unSelectedResourceIndexEntries.shuffle()
            print("numOfBaseSoundSetForTargeted is \(numOfBaseSoundSetForTargeted)")
            var numOfIncrements = 0
            for (i,j) in zip(numOfBaseSoundSetForTargeted..<targetedIndexEntries.count, 0..<unSelectedResourceIndexEntries.count) {
                let entryKey = targetedIndexEntries[i]
                let tmrEntry = getTMREntry(entryKey)
                let unSelectedSoundImageIndex = unSelectedResourceIndexEntries[j]
                tmrEntry?.setBaseSoundName(baseSoundName: tmrResource.getSoundName(index: unSelectedSoundImageIndex))
                tmrEntry?.setBaseSoundNickname(unSelectedSoundImageIndex)
                if ( numOfBaseSoundSetForTargeted + j + 1 >= targetedIndexEntries.count ) {
                    numOfIncrements = j + 1
                    break;
                }
                
            }
            numOfBaseSoundSetForTargeted = numOfBaseSoundSetForTargeted + numOfIncrements
        }
    }
    
    func getTargetIndexEntries() -> [Int] {
        var retEntries = [Int]()
        for tmrEntry in projectTuple.tmrEntries {
            if ( tmrEntry.getIsTargeted()) {
                retEntries.append(tmrEntry.getSoundImageIndex())
            }
        }
        return retEntries
    }
    
    
    func getUnSelectedResourceIndexEntries() -> [Int] {
        
        let unSelectedResourceIndexEntries : [Int] = tmrResource.getUnSelectedResourceIndexEntries(selectedResourceIndexEntries: getResourceIndexEntries())
        
        return unSelectedResourceIndexEntries
    }
    
    func getPosition(resourceIndex : Int) -> (Int, Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            return tmrEntry.getPosition()
        }
        else {
            return (5,5)
        }
    }
    
    func setPosition(resourceIndex : Int, posX : Int, posY : Int) {
        if let tmrEntry = getTMREntry(resourceIndex) {
            tmrEntry.setPosition(posX: posX, posY: posY)
        }
    }
    
    func getPercentOfCorrectionBeforeSleep() -> Int {
        let ret = Int(getNumOfCorrectRecordsBeforeSleep()*100/getNumOfEntries())
        print("getPercentOfCorrectionBeforeSleep: \(ret)")
        return ret
    }
    func getPercentOfCorrectionAfterSleep() -> Int {
        let ret = Int(getNumOfCorrectRecordsAfterSleep()*100/getNumOfEntries())
        print("getPercentOfCorrectionAfterSleep: \(ret)")
        return ret
    }
    
    func getPercentOfCorrection1() -> Int {
        let ret = Int(getNumOfCorrectRecords1()*100/getNumOfEntries())
        print("getPercentOfCorrection1: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecords1() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrect1()) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecords1: \(ret)")
        return ret
    }
    
    func getPercentOfCorrection2() -> Int {
        let ret = Int(getNumOfCorrectRecords2()*100/getNumOfEntries())
        print("getPercentOfCorrection2: \(ret)")
        return ret
    }
    
    func getNumOfCorrectRecords2() -> Int {
        var ret:Int = 0
        for tmrEntry in projectTuple.tmrEntries {
            if (tmrEntry.getIsCorrect2()) {
                ret = ret+1
            }
        }
        print("getNumOfCorrectionRecords2: \(ret)")
        return ret
    }
    
    func getPercentOfCorrectionBeforeSleepForTargeted() -> Int {
        let ret = Int(getNumOfCorrectRecordsBeforeSleepForTargeted()*100/getTargetIndexEntries().count)
        print("getPercentOfCorrectionBeforeSleepForTargeted: \(ret)")
        return ret
    }
    func getPercentOfCorrectionAfterSleepForTargeted() -> Int {
        let ret = Int(getNumOfCorrectRecordsAfterSleepForTargeted()*100/getTargetIndexEntries().count)
        print("getPercentOfCorrectionAfterSleepForTargeted: \(ret)")
        return ret
    }
    
    func getPercentOfCorrectionBeforeSleepForUnTargeted() -> Int {
        let ret = Int(getNumOfCorrectRecordsBeforeSleepForUnTargeted()*100/(getNumOfEntries()-getTargetIndexEntries().count))
        print("getPercentOfCorrectionBeforeSleepForUnTargeted: \(ret)")
        return ret
    }
    func getPercentOfCorrectionAfterSleepForUnTargeted() -> Int {
        let ret = Int(getNumOfCorrectRecordsAfterSleepForUnTargeted()*100/(getNumOfEntries()-getTargetIndexEntries().count))
        print("getPercentOfCorrectionAfterSleepForUnTargeted: \(ret)")
        return ret
    }
    
    func getBasedSoundsForTargeted() -> [URL] {
        var basedSounds = [URL]()
        for tmrEntry in projectTuple.tmrEntries {
            if ( tmrEntry.getIsTargeted()) {
                let baseSound = tmrEntry.getBaseSound()
                basedSounds.append(baseSound!)
            }
        }
        return basedSounds
    }
    
    func getBasedSoundNames() -> [String]{
        var basedSounds = [String]()
        for tmrEntry in projectTuple.tmrEntries {
            if ( tmrEntry.getIsTargeted()) {
                let baseSound = tmrEntry.getBaseSoundName()
                basedSounds.append(baseSound)
            }
        }
        return basedSounds
    }
    
    func getPreNapEntries() -> TMRExportAllEntry {
        return getExportEntries(isPreNap: true)
    }
    
    func getPostNapEntries() -> TMRExportAllEntry {
        return getExportEntries(isPreNap: false)
    }
    
    func getExportEntries(isPreNap: Bool) -> TMRExportAllEntry {
        print("project getExportEntries entered")
        var listTargeted : [TMRExportEntry] = [TMRExportEntry]()
        var listUnTargeted : [TMRExportEntry] = [TMRExportEntry]()
        
        for tmrEntry in projectTuple.tmrEntries {
            if ( tmrEntry.getIsTargeted() ) {
                if ( isPreNap ) {
                    let tmrExportEntry = TMRExportEntry(pictureName: getPictureName(resourceIndex: (tmrEntry.getSoundImageIndex())), soundName: getSoundName(resourceIndex: (tmrEntry.getSoundImageIndex())), isCorrect: tmrEntry.getIsCorrectBeforeSleep(), distance: tmrEntry.getDistanceBeforeSleep(), distancePercent: tmrEntry.getDistancePercentBeforeSleep(), baseSoundName: tmrEntry.getBaseSoundName())
                    listTargeted.append(tmrExportEntry)
                } else {
                    let tmrExportEntry = TMRExportEntry(pictureName: getPictureName(resourceIndex: (tmrEntry.getSoundImageIndex())), soundName: getSoundName(resourceIndex: (tmrEntry.getSoundImageIndex())), isCorrect: tmrEntry.getIsCorrectAfterSleep(), distance: tmrEntry.getDistanceAfterSleep(), distancePercent: tmrEntry.getDistancePercentAfterSleep(), baseSoundName: tmrEntry.getBaseSoundName())
                    listTargeted.append(tmrExportEntry)
                }
            }
            else {
                if ( isPreNap ) {
                    let tmrExportEntry = TMRExportEntry(pictureName: getPictureName(resourceIndex: (tmrEntry.getSoundImageIndex())), soundName: getSoundName(resourceIndex: (tmrEntry.getSoundImageIndex())), isCorrect: tmrEntry.getIsCorrectBeforeSleep(), distance: tmrEntry.getDistanceBeforeSleep(), distancePercent: tmrEntry.getDistancePercentBeforeSleep(), baseSoundName: tmrEntry.getBaseSoundName())
                    listUnTargeted.append(tmrExportEntry)
                } else {
                    let tmrExportEntry = TMRExportEntry(pictureName: getPictureName(resourceIndex: (tmrEntry.getSoundImageIndex())), soundName: getSoundName(resourceIndex: (tmrEntry.getSoundImageIndex())), isCorrect: tmrEntry.getIsCorrectAfterSleep(), distance: tmrEntry.getDistanceAfterSleep(), distancePercent: tmrEntry.getDistancePercentAfterSleep(), baseSoundName: tmrEntry.getBaseSoundName())
                    listUnTargeted.append(tmrExportEntry)
                }
            }
        }
        let tmrExportAllEntry = TMRExportAllEntry()
        tmrExportAllEntry.listTargetedEntries = listTargeted
        tmrExportAllEntry.listUnTargetedEntries = listUnTargeted
        
        print("project getExportEntries exitedd")
        return tmrExportAllEntry
    }
    /*
     func toJSON() -> [String:Any] {
     tmrResource = TMRResourceFactory.getTMRResource();
     var dictionary: [String : Any] = [:]
     
     dictionary["projectName"] = projectTuple.tmrProjectName
     dictionary["note"] = projectTuple.tmrNote
     dictionary["user"] = user?.toJSON()
     dictionary["guiSetting"] = projectTuple.guiSetting?.toJSON()
     
     var tmrEntriesDictionary: [String : Any] = [:]
     
     var i : Int = 0
     for tmrEntry in projectTuple.tmrEntries.values {
     let nickName = getNickName(resourceIndex: tmrEntry.getSoundImageIndex())
     tmrEntriesDictionary["\(nickName)"] = tmrEntry.toJSON()
     i = i+1
     }
     print("protect:toJSON, array end")
     dictionary["tmrEntries"] = tmrEntriesDictionary
     if ( projectTuple.experimentCompleted ) {
     dictionary["experimentCompleted"] = "True"
     }
     else {
     dictionary["experimentCompleted"] = "False"
     }
     return dictionary
     }
     
     func fromJson (dictionary : [String : Any]) {
     self.tmrResource = TMRResourceFactory.getTMRResource();
     var stringName : String = dictionary["projectName"] as! String
     projectTuple.tmrProjectName = stringName
     stringName = dictionary["note"] as! String
     projectTuple.tmrNote = stringName
     var _user : [String: Any]  = dictionary["user"] as! [String : Any]
     self.user?.fromJson(dictionary: _user)
     var _guiSetting : [String : Any] = dictionary["guiSetting"] as! [String : Any]
     projectTuple.guiSetting?.fromJson(dictionary: _guiSetting)
     
     var _tmrEntries = dictionary["tmrEntries"] as! [[String: Any]]
     for i in 0..<_tmrEntries.count {
     var _tmrEntry : [String : Any] = _tmrEntries[i]
     var tmrEntry = TMREntry()
     tmrEntry.fromJson(dictionary: _tmrEntry)
     projectTuple.tmrEntries[tmrEntry.getSoundImageIndex()] = tmrEntry
     }
     
     var stringNum = dictionary["experimentCompleted"] as! String
     if stringNum == "True" {
     projectTuple.experimentCompleted = true
     }
     else {
     projectTuple.experimentCompleted = false
     }
     }
     */
    
    
}
