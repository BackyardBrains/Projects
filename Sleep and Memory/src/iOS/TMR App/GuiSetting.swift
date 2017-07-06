//
//  guiSetting.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class GuiSetting : NSCopying{
    private var numColumns : Int = 10
    private var numRows : Int = 6
    private var sampleSize : Int = 2
    private var resource : TMRResource
    private var distanceThreshold : Int = 15 // 15%
    
    // timer values:
    private var trainingInterval : Int  = 3
    private var intertrainingInterval : Int = 1
    private var testingInterval : Int = 3
    private var sleepInterval : Int = 5
    
    // testing repeat times
    private var repeatTimesForTestAfterTraining : Int = 2
    
    private var json : Float = 2
    private var software : Float = 4.1
    
    func toJSON() -> [String:Any] {
        var dictionary: [String : Any] = [:]
        
        dictionary["numColumns"] = "\(self.numColumns)"
        dictionary["numRows"] = "\(self.numRows)"
        dictionary["sampleSize"] = "\(self.sampleSize)"
        dictionary["distanceThreshold"] = "\(self.distanceThreshold)"
        dictionary["trainingInterval"] = "\(self.trainingInterval)"
        dictionary["testingInterval"] = "\(self.testingInterval)"
        dictionary["sleepInterval"] = "\(self.sleepInterval)"
        dictionary["repeatTimesForTestAfterTraining"] = self.repeatTimesForTestAfterTraining
        dictionary["intertrialInterval"] = self.intertrainingInterval
        return dictionary
    }
    
    func fromJson (dictionary : [String : Any]) {
        var stringNum : String = dictionary["numColumns"] as! String
        var num : Int = Int(stringNum)!
        self.numColumns = num
        stringNum = dictionary["numRows"] as! String
        num = Int(stringNum)!
        self.numRows = num
        stringNum = dictionary["sampleSize"] as! String
        num = Int(stringNum)!
        self.sampleSize = num
        stringNum = dictionary["distanceThreshold"] as! String
        num = Int(stringNum)!
        self.distanceThreshold = num
        stringNum = dictionary["trainingInterval"] as! String
        num = Int(stringNum)!
        self.trainingInterval = num
        stringNum = dictionary["repeatTimesForTestAfterTraining"] as! String
        num = Int(stringNum)!
        self.repeatTimesForTestAfterTraining = num
        stringNum = dictionary["testingInterval"] as! String
        num = Int(stringNum)!
        self.testingInterval = num
        stringNum = dictionary["sleepInterval"] as! String
        num = Int(stringNum)!
        self.sleepInterval = num
        stringNum = dictionary["intertrialInterval"] as! String
        num = Int(stringNum)!
        self.intertrainingInterval = num
    }
    
    func getJSONVersion() -> Float{
        return json
    }
    func setJSONVersion(version:Float){
        json = version
    }
    
    func getSoftwareVersion() -> Float{
        return software
    }
    func setSoftwareVersion(version:Float){
        software = version
    }

    func getNumColumns() -> Int {
        return numColumns
    }
    
    func getNumRows() -> Int {
        return numRows
    }
    
    func getSampleSize() -> Int {
        return sampleSize
    }
    
    func getResource() -> TMRResource {
        return resource
    }
    
    func getDistanceThreshold() -> Int {
        return distanceThreshold
    }
    
    func getTrainingInterval() -> Int {
        return trainingInterval
    }
    
    func getTestingInterval() -> Int {
        return testingInterval
    }
    
    func getSleepInterval() -> Int {
        return sleepInterval
    }
    
    func getInterTrainingInterval() -> Int {
        return intertrainingInterval
    }
    
    func setInterTrainingInterval(interTrainingInterval:Int){
        self.intertrainingInterval = interTrainingInterval
    }
    
    func getRepeatTimesForTestAfterTraining() -> Int {
        return repeatTimesForTestAfterTraining
    }
    
    func setTrainingInterval(trainingInterval : Int) {
        self.trainingInterval = trainingInterval
    }
    
    func setTestingInterval(testingInterval : Int) {
        self.testingInterval = testingInterval
    }
    
    func setSleepInterval(sleepSoundInterval : Int) {
        self.sleepInterval = sleepSoundInterval
    }
    
    func setNumColumns(numOfColumns : Int) {
        numColumns = numOfColumns
    }
    
    func setNumRows(numOfRows : Int ) {
        numRows = numOfRows
    }
    
    func setSampleSize(sampleSize : Int) {
        self.sampleSize = sampleSize
    }
    
    func setTMRResource(tmrResource : TMRResource) {
        self.resource = tmrResource
    }
    
    func setDistanceThreshold(threshold : Int) {
        self.distanceThreshold = threshold
    }
    
    func setRepeatTimesForTestAfterTraining(repeatTimes : Int) {
        self.repeatTimesForTestAfterTraining = repeatTimes
    }
    
    init() {
        resource = TMRResourceFactory.getTMRResource();
    }
    
    init(numColumns:Int, numRows:Int, sampleSize:Int, resource : TMRResource) {
        self.numColumns = numColumns
        self.numRows = numRows
        self.sampleSize = sampleSize
        self.resource = resource.copy() as! TMRResourceImpl;
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GuiSetting(numColumns: numColumns, numRows: numRows, sampleSize: sampleSize,resource: resource)
        return copy
    }
}
