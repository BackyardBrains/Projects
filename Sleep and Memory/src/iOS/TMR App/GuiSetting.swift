//
//  guiSetting.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import EVReflection

class GuiSetting : EVObject, NSCopying {
    //Interesting to add a set of default return values as well, that can be editing in a general "user setting" GUI
    
    var numColumns : Int = 10
    var numRows : Int = 6
    var sampleSize : Int = 2
    /*
    var resource : TMRResource
    */
    
    var distanceThreshold : Int = 15 // 15%
    
    // timer values:
    var trainingInterval : Int  = 0
    var intertrainingInterval : Int = 0
    var testingInterval : Int = 0
    var sleepInterval : Int = 0
    
    // testing repeat times
    var repeatTimesForTestAfterTraining : Int = 2
    
    var json : Float = 2
    var software : Float = 4.1
    
    //Treatment Option 1-sleep cueing
    var treatmentNum : Int = 1
    
    //Percent of images cued
    var percentCued : Int = 50
    
    func reset(){
        numColumns = 10
        numRows = 6
        sampleSize = 2
        distanceThreshold = 15
        trainingInterval = 0
        intertrainingInterval = 0
        testingInterval = 0
        sleepInterval = 0
        repeatTimesForTestAfterTraining = 2
        json = 2
        software = 4.1
        treatmentNum = 1
        percentCued = 50
    }
    
    /*
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
    */
    
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
    
    /*
    func getResource() -> TMRResource {
        return resource
    }
    */
    
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
    
    /*
    func setTMRResource(tmrResource : TMRResource) {
        self.resource = tmrResource
    }
    */
    
    func setDistanceThreshold(threshold : Int) {
        self.distanceThreshold = threshold
    }
    
    func setRepeatTimesForTestAfterTraining(repeatTimes : Int) {
        self.repeatTimesForTestAfterTraining = repeatTimes
    }
    
    func setTreatmentNum(num:Int){
        self.treatmentNum = num
    }
    
    func getTreatmentNum()->Int{
        return treatmentNum
    }
    
    func setCuedPercent(num:Int){
        self.percentCued = num
    }
    
    func getCuedPercent()->Int{
        return percentCued
    }
    
    required init() {
        /*
        resource = TMRResourceFactory.getTMRResource();
        */
    }
    
    /*
    init(numColumns:Int, numRows:Int, sampleSize:Int, resource : TMRResource) {
    */
    init(numColumns:Int, numRows:Int, sampleSize:Int) {
        self.numColumns = numColumns
        self.numRows = numRows
        self.sampleSize = sampleSize
        /*
        self.resource = resource.copy() as! TMRResourceImpl;
        */
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GuiSetting(numColumns: numColumns, numRows: numRows, sampleSize: sampleSize)
        copy.setDistanceThreshold(threshold: distanceThreshold)
        copy.setTrainingInterval(trainingInterval: trainingInterval)
        copy.setInterTrainingInterval(interTrainingInterval: intertrainingInterval)
        copy.setTestingInterval(testingInterval: testingInterval)
        copy.setSleepInterval(sleepSoundInterval: sleepInterval)
        copy.setCuedPercent(num: percentCued)
        copy.setTreatmentNum(num: treatmentNum)
        return copy
    }
}
