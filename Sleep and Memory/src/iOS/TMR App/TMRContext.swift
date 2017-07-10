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
    case None,
        Home,MetaData,ExpData,TimingData,ExpOptions,CueingSetup,CueingSetupAuto,CueingSetupManual,Settings,Training,Testing,PreNapTest,PreNapResult,
        Queuing,Control,Retest,Result,Comments,End
}

// current running context
class TMRContext {
    var userAccount : UserAccount
    var userNameList : [String] = []
    var selUserName : String = "default"
    
    var project     : TMRProject
    var projNameList : [String] = []// list in file
    var selProjName : String = "default"
    
    var controlModel = 1
    var setupPassed = [false,false,false,false,false,false,false] //0meta,1expdata,2timing,3expop,4cueingset,5auto,6manual
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
        userAccount = UserAccountFactory.createUserAccount(userName: "Robert", password: "")
        UserAccountFactory.save(name: userAccount.getUserName(), user: userAccount.getUserAccountTuple())
        project = TMRProjectFactory.getTMRProject(userAccount : userAccount)
        
        model  = TMRModelHome() as TMRModel // initial model
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
        case .Home:
            self.model = TMRModelHome()
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
    
}
