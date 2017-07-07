//
//  TMRSoundImage.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class TMRSoundImage : NSCopying{
    
    private var index:Int = 0
    private var pictureName:String = ""
    private var soundName:String = ""
    private var nickName = ""
    static var nickNames = ["DynamiteExplosion","ClockTicking","TrainGoingBy","PopcornPopping","SwampCrickets","AirplaneFlyBy",
                             "BaconFrying","BoomerangWhipping","BowlingPinsFalling","ShatteringWineGlass","CarStarting","CardsShuffling",
                             "CatMeow","PoppigChampagneCork","CityHornHonking","HandsClapping","CokeCanOpening","Photocopying",
                             "CrowdSpeaking","ToiletFlushing","DoorCreaking","MoneyJingling","FluteNote","GongCrash","SawBackForth",
                             "Heartbeat","VinylSkipping","Helicopter","HorseRunning","IceCubeIceInGlass","SpringBoing","Keys","ChildGulping",
                             "WaterInSink","Thunder","MatchStriking","BellRinging","ZippingUp","OwlHooting","HighHeels",
                             "ScissorsCuttingPaper","WomanLaughing","WomanSneezing","WaterSplash","Stapling","ManSnoring","KettleWhistling",
                             "RacquetHitting","LockTurning","Kissing","AccordianPlaying","BabyCrying","Bagpipe","BeeBuzz","CameraShutter",
                             "Chicken","WindChime","CowMeow","DogBarking","Drilling","GuitarStrum","GunShot","Hammering","Motorcycle","Piano",
                             "Sheep","TelephoneRinging","Toothbrushing","Violin","Whip","Whistle","Husky"]
    
    
    func getIndex() -> Int {
        return index
    }
    
    func getPictureName() -> String {
        return pictureName
    }
    
    func getSoundName() -> String {
        return soundName
    }
    
    func getNickName() -> String{
        return nickName
    }
    
    func setPictureName(pictureName : String) {
        self.pictureName = pictureName
    }
    
    func setSoundName(soundName : String) {
        self.soundName = soundName
    }
    
    init(index:Int) {
        self.index = index;
        pictureName = "p\(index+1)"
        soundName = "s\(index+1).wav"
        nickName = TMRSoundImage.nickNames[index]
    }
    
    init(index:Int, pictureName:String, soundName:String, nickName: String) {
        self.index = index;
        self.pictureName = pictureName;
        self.soundName = soundName;
        self.nickName = nickName
    }
    
    func getSoundImageSKSpriteNode(pos:CGPoint, pictureWidth:CGFloat, pictureHeight:CGFloat) -> SKSpriteNode {
        let texture:SKTexture = SKTexture(imageNamed:pictureName)
        let retNode:SKSpriteNode = SKSpriteNode(texture:texture, color:.clear, size:texture.size())
        retNode.zPosition = 1
        retNode.size = CGSize(width:pictureWidth, height:pictureHeight)
        retNode.anchorPoint = CGPoint(x:0,y:0)
        retNode.position = pos
        return retNode;
        
    }
    
        
    func getAudioPlayer() -> AVAudioPlayer?  {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        
        do {
            return (try (AVAudioPlayer(contentsOf: url)))
        } catch {
            return nil
        }
        
    }
    
    func getAudioURL() -> URL? {
        if let path = Bundle.main.path(forResource: soundName, ofType:nil) {
            return URL(fileURLWithPath: path)
        }
        print("getAudioURL: \(soundName)")
        return nil
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TMRSoundImage(index: index, pictureName: pictureName, soundName: soundName, nickName : nickName)
        return copy
    }

}
