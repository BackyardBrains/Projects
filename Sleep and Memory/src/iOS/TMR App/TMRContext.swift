//
//  TMRContext.swift
//  TMR App
//
//  Created by Robert Zhang on 6/17/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum ModelType {
    case None,UserSignIn,Loading,Home,ViewProj,PostTestStats,MetaData,ExpData,TimingData,ExpOptions,CueingSetup,CueingSetupAuto,CueingSetupManual,Settings,Training,Testing,PreNapTest,PreNapResult,
    Queuing,Control,Retest,Result,Comments,End
}

// current running context
class TMRContext {
    var userAccount : UserAccount = UserAccount()
    var userNameList : [String] = []
    var selUserName : String = "default"
    var allProjects : [TMRProject] = []
    
    var project     : TMRProject = TMRProjectImpl()
    var projNameList : [String] = []// list in file
    var selProjName : String = "default"
    
    var controlModel = 1
    var isAuto = true
    
    //resourceIndexList either get from project like training, or the shuffled one for testing
    var resourceIndexList = [Int]()
    
    var currentModel : ModelType = .Home
    private var _nextModelType : ModelType = .Home
    
    var nextModel    : ModelType {
        get {
            return _nextModelType
        }
        set(newType){
            _nextModelType = newType
            modelUpdateFlag = true
        }
    }
    
    var modelUpdateFlag : Bool = false
    var model       : TMRModel
    var repeatCnt : Int = 0
    
    var curIdx = 0;
    
    init() {
        model  = TMRUserSignin() as TMRModel // initial model
    }
    
    func modelUpdate(screen : TMRScreen,view:SKView){
        if !modelUpdateFlag {
            return
        }
        modelUpdateFlag = false
        
        // stop current
        self.model.end(screen: screen, context: self)
        // get next
        switch(self.nextModel){
        case .UserSignIn:
            self.model = TMRUserSignin()
        case .Loading:
            self.model = TMRLoading()
        case .Home:
            self.model = TMRModelHome()
        case .ViewProj:
            self.model = TMRViewProj()
        case .PostTestStats:
            self.model = TMRPostTestStats()
        case .MetaData:
            self.model = TMRModelMetaData()
        case .ExpData:
            self.model = TMRModelExpData()
        case .TimingData:
            self.model = TMRModelTimingData()
        case .ExpOptions:
            self.model = TMRModelExpOptions()
        case .CueingSetup:
            self.model = TMRModelCueingSetup()
        case .CueingSetupAuto:
            self.model = TMRModelCueingSetupAuto()
        case .CueingSetupManual:
            self.model = TMRModelCueingSetupManual()
        case .Settings:
            self.model = TMRModelSettings()
        case .Training:
            self.model = TMRModelTraining()
        case .Testing, .PreNapTest, .Retest:
            self.model = TMRModelTesting()
        case .Queuing:
            self.model = TMRModelQueuing()
        case .Control:
            self.model = TMRModelControl()
        case .PreNapResult:
            self.model = TMRModelStatBefore()
        case .Result:
            self.model = TMRModelResult()
        case .End:
            self.model = TMRModelEnd()
        case .Comments:
            self.model = TMRModelComments()
        default:
            assertionFailure("no model type defined")
        }
        self.currentModel = self.nextModel
        self.model.begin(screen: screen, context: self,view:view)
        // start next
    }
    
    func getResourceIndexList() -> [Int] {
        return resourceIndexList
    }
    
    func setResourceIndexList(resourceIndexList : [Int] ) {
        self.resourceIndexList = resourceIndexList
    }
    
    func reset(){
        controlModel = 1
        isAuto = true
        repeatCnt = 0
        curIdx = 0
    }
    
}
