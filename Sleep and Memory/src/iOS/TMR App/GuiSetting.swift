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
