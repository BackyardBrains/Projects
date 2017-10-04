//
//  TMREntry.swift
//  TMR App
//
//  Created by Robert Zhang on 6/15/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import EVReflection



class TMREntry : EVObject {
    var soundimageIndex:Int = 0
    var positionX:Int = 5
    var positionY:Int = 5
    var isTargeted:Bool = false
    var baseSoundName:String = "baseline.wave"
    var baseSoundNickName:String = "baseline.wave"
    
    //Stats
    //1
    var distance1:Float = 0
    var distancePercent1:Float = 0
    var distanceCM1:Float = 0
    var timeBegin1:String = ""
    var timeBegin1Date:Date = Date()
    var reactionTime1:Float = 0
    var x1:Int = 0
    var y1:Int = 0
    var isCorrect1:Bool = false
    
    //2
    var distance2:Float = 0
    var distancePercent2:Float = 0
    var distanceCM2:Float = 0
    var timeBegin2:String = ""
    var timeBegin2Date:Date = Date()
    var reactionTime2:Float = 0
    var x2:Int = 0
    var y2:Int = 0
    var isCorrect2:Bool = false
    
    //pre
    var distanceBeforeSleep:Float = 0
    var distancePercentBeforeSleep:Float = 0
    var distanceCMBeforeSleep:Float = 0
    var reactionTimeBeforeSleep:Float = 0
    var timeBeginBeforeSleep:String = ""
    var timeBeginBeforeSleepDate:Date = Date()
    var xBeforeSleep:Int = 0
    var yBeforeSleep:Int = 0
    var isCorrectBeforeSleep:Bool = false
    
    //post
    var distanceAfterSleep:Float = 0
    var distancePercentAfterSleep:Float = 0
    var distanceCMAfterSleep:Float = 0
    var timeBeginAfterSleep:String = ""
    var timeBeginAfterSleepDate:Date = Date()
    var reactionTimeAfterSleep:Float = 0
    var xAfterSleep:Int = 0
    var yAfterSleep:Int = 0
    var isCorrectAfterSleep:Bool = false
    
    init(resourceEntryIndex : Int) {
        soundimageIndex = resourceEntryIndex
        positionX = 5
        positionY = 5
        isTargeted = false
        isCorrectBeforeSleep  = false
        isCorrectAfterSleep  = false
    }
    
    required init() {
        //fatalError("init() has not been implemented")
        soundimageIndex = 0 //resourceEntryIndex
        positionX = 5
        positionY = 5
        isTargeted = false
        isCorrectBeforeSleep  = false
        isCorrectAfterSleep  = false
        super.init()
    }
    
    func getBaseSound() -> URL? {
        if let path = Bundle.main.path(forResource: baseSoundName, ofType:nil) {
            return URL(fileURLWithPath: path)
        }
        print("getAudioURL: \(baseSoundName)")
        return nil
    }
    
    func setBaseSoundNickname(_ index: Int){
        baseSoundNickName = TMRSoundImage.nickNames[index]
    }
    
    func getBaseSoundNickname()->String{
        return baseSoundNickName
    }
    
    func getBaseSoundName() -> String {
        return baseSoundName
    }
    
    func setBaseSoundName(baseSoundName : String) {
        self.baseSoundName = baseSoundName
    }
    
    //1
    func getDistance1() -> Float {
        return distance1
    }
    func setDistance1(distance1 : Float) {
        self.distance1 = distance1
    }
    func getDistancePercent1() -> Float {
        return distancePercent1
    }
    func setDistancePercent1(distancePercent1 : Float) {
        self.distancePercent1 = distancePercent1
    }
    func getDistanceCM1() -> Float {
        return distanceCM1
    }
    func setDistanceCM1(distanceCM1 : Float) {
        self.distanceCM1 = distanceCM1
    }
    func getTimeBegin1() -> String{
        return timeBegin1
    }
    func getTimeBegin1Date() -> Date{
        return timeBegin1Date
    }
    func setTimeBegin1(time:Date){
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        timeBegin1 = str
        timeBegin1Date = time
    }

    func getReactionTime1()->Float{
        return reactionTime1
    }
    func setReactionTime1(time:Float){
        reactionTime1 = time
    }
    func getX1()->Int{
        return x1
    }
    func setX1(x:Int){
        x1 = x
    }
    func getY1()->Int{
        return y1
    }
    func setY1(y:Int){
        y1 = y
    }
    func getIsCorrect1()->Bool{
        return isCorrect1
    }
    func setIsCorrect1(correct:Bool){
        isCorrect1 = correct
    }
    
    //2
    func getDistance2() -> Float {
        return distance2
    }
    func setDistance2(distance2 : Float) {
        self.distance2 = distance2
    }
    func getDistancePercent2() -> Float {
        return distancePercent2
    }
    func setDistancePercent2(distancePercent2 : Float) {
        self.distancePercent2 = distancePercent2
    }
    func getDistanceCM2() -> Float {
        return distanceCM2
    }
    func setDistanceCM2(distanceCM2 : Float) {
        self.distanceCM2 = distanceCM2
    }
    func getTimeBegin2() -> String{
        return timeBegin2
    }
    func getTimeBegin2Date() -> Date{
        return timeBegin2Date
    }
    func setTimeBegin2(time:Date){
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        timeBegin2 = str
        timeBegin2Date = time
    }
    func getReactionTime2()->Float{
        return reactionTime2
    }
    func setReactionTime2(time:Float){
        reactionTime2 = time
    }
    func getX2()->Int{
        return x2
    }
    func setX2(x:Int){
        x2 = x
    }
    func getY2()->Int{
        return y2
    }
    func setY2(y:Int){
        y2 = y
    }
    func getIsCorrect2()->Bool{
        return isCorrect2
    }
    func setIsCorrect2(correct:Bool){
        isCorrect2 = correct
    }
    
    //pre
    func getDistanceBeforeSleep() -> Float {
        return distanceBeforeSleep
    }
    func setDistanceBeforeSleep(distanceBeforeSleep : Float) {
        self.distanceBeforeSleep = distanceBeforeSleep
    }
    func getDistancePercentBeforeSleep() -> Float {
        return distancePercentBeforeSleep
    }
    func setDistancePercentBeforeSleep(distancePercentBeforeSleep : Float) {
        self.distancePercentBeforeSleep = distancePercentBeforeSleep
    }
    func getDistanceCMBeforeSleep() -> Float {
        return distanceCMBeforeSleep
    }
    func setDistanceCMBeforeSleep(distanceCMBeforeSleep : Float) {
        self.distanceCMBeforeSleep = distanceCMBeforeSleep
    }
    func getTimeBeginBeforeSleep() -> String{
        return timeBeginBeforeSleep
    }
    func getTimeBeginBeforeSleepDate() -> Date{
        return timeBeginBeforeSleepDate
    }
    func setTimeBeginBeforeSleep(time:Date){
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        timeBeginBeforeSleep = str
        timeBeginBeforeSleepDate = time
    }
    func getReactionTimeBeforeSleep()->Float{
        return reactionTimeBeforeSleep
    }
    func setReactionTimeBeforeSleep(time:Float){
        reactionTimeBeforeSleep = time
    }
    func getXBeforeSleep()->Int{
        return xBeforeSleep
    }
    func setXBeforeSleep(x:Int){
        xBeforeSleep = x
    }
    func getYBeforeSleep()->Int{
        return yBeforeSleep
    }
    func setYBeforeSleep(y:Int){
        yBeforeSleep = y
    }
    
    
    //post
    func getDistanceAfterSleep() -> Float {
        return distanceAfterSleep
    }
    func setDistanceAfterSleep(distanceAfterSleep : Float) {
        self.distanceAfterSleep = distanceAfterSleep
    }
    func getDistancePercentAfterSleep() -> Float {
        return distancePercentAfterSleep
    }
    func setDistancePercentAfterSleep(distancePercentAfterSleep : Float) {
        self.distancePercentAfterSleep = distancePercentAfterSleep
    }
    func getDistanceCMAfterSleep() -> Float {
        return distanceCMAfterSleep
    }
    func setDistanceCMAfterSleep(distanceCMAfterSleep : Float) {
        self.distanceCMAfterSleep = distanceCMAfterSleep
    }
    func getTimeBeginAfterSleep() -> String{
        return timeBeginAfterSleep
    }
    func getTimeBeginAfterSleepDate() -> Date{
        return timeBeginAfterSleepDate
    }
    func setTimeBeginAfterSleep(time:Date){
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss";
        formatter.timeZone = TimeZone.current
        let str = formatter.string(from: time);
        timeBeginAfterSleep = str
        timeBeginAfterSleepDate = time
    }
    func getReactionTimeAfterSleep()->Float{
        return reactionTimeAfterSleep
    }
    func setReactionTimeAfterSleep(time:Float){
        reactionTimeAfterSleep = time
    }
    func getXAfterSleep()->Int{
        return xAfterSleep
    }
    func setXAfterSleep(x:Int){
        xAfterSleep = x
    }
    func getYAfterSleep()->Int{
        return yAfterSleep
    }
    func setYAfterSleep(y:Int){
        yAfterSleep = y
    }
    
    
    func getSoundImageIndex() -> Int {
        return soundimageIndex;
    }
    
    func setSoundImageIndex(soundimageIndex : Int) {
        self.soundimageIndex = soundimageIndex
    }
    
    func getPositionX() -> Int {
        return positionX
    }
    
    func setPositionX(x : Int) {
        positionX = x
    }
    
    func getPositionY() -> Int {
        return positionY
    }

    func setPositionY(y : Int) {
        positionY = y
    }
    
    func getPosition() -> (Int, Int) {
        return (positionX, positionY)
    }
    
    func setPosition(posX : Int, posY : Int) {
        positionX = posX
        positionY = posY
    }
    
    func getIsTargeted() -> Bool {
        return isTargeted
    }
    
    func getIsCorrectBeforeSleep() -> Bool {
        return isCorrectBeforeSleep
    }

    func getIsCorrectAfterSleep() -> Bool {
        return isCorrectAfterSleep
    }
    
    func setIsTargeted(isTargeted : Bool) {
        self.isTargeted = isTargeted    }
    
    func setIsCorrectBeforeSleep(isCorrectBeforeSleep: Bool) {
        self.isCorrectBeforeSleep = isCorrectBeforeSleep
    }
    
    func setIsCorrectAfterSleep(isCorrectAfterSleep : Bool) {
        self.isCorrectAfterSleep = isCorrectAfterSleep
    }

}
