//
//  TMRResourceImpl.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import SpriteKit

class TMRResourceImpl : TMRResource {
    
    var resourceName:String = ""
    var listSoundImage = [TMRSoundImage]()
    
    func getResourceName() -> String {return resourceName}
    
    func getNickName(index : Int) -> String{
        return listSoundImage[index].getNickName()
    }
    
    func getPictureName(index : Int) -> String{
        return listSoundImage[index].getPictureName()
    }
    
    func getAudioURL(index : Int) -> URL? {
        return listSoundImage[index].getAudioURL()
    }
    
    func getSoundName(index : Int) -> String {
        return listSoundImage[index].getSoundName()
    }
    
    init (name:String) {
        self.resourceName = name;
    }
    
    func getNumberOfResourceEntries() -> Int {
        return listSoundImage.count
    }
    
    func getAllResources() {
        if (resourceName == "default") {
            for i in 0...71 {
                let soundImage:TMRSoundImage = TMRSoundImage(index:i)
                listSoundImage.append(soundImage)
                
            }
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TMRResourceImpl(name: resourceName)
        for i in 0..<listSoundImage.count {
            let soundImageCopy : TMRSoundImage = listSoundImage[i].copy() as! TMRSoundImage
            copy.listSoundImage.append(soundImageCopy)
        }
        return copy
    }
    
    func getUnSelectedResourceIndexEntries(selectedResourceIndexEntries : [Int]) -> [Int] {
        print("getUnSelectedResourceIndexEntries entered, input size is \(selectedResourceIndexEntries.count)")
        var retEntries = [Int]()
        for i in 0..<listSoundImage.count {
            let soundImageIndex = listSoundImage[i].getIndex();
            //print("soundImageIndex is \(soundImageIndex)")
            if  !selectedResourceIndexEntries.contains(soundImageIndex) {
                //print("adding index\(soundImageIndex)")
                retEntries.append(soundImageIndex)
            }
        }
        
        return retEntries
    }

}
