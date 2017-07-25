//
//  UserAccount.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation
import EVReflection

class UserAccountTuple : EVObject{
    var userName : String = "Robert"
    var password : String = ""
    var guiSetting : GuiSetting = GuiSetting()
    var currentID:Int = 0
}

class UserAccount {
    private var userAccountTuple : UserAccountTuple = UserAccountTuple()
    private var listTMRProject = [TMRProject]()
    private var listTMRResource = [TMRResource]()
    
    init(userName:String, password:String) {
        userAccountTuple.userName = userName;
        userAccountTuple.password = password;
        let resource = TMRResourceFactory.getTMRResource()
        listTMRResource.append(resource)
        userAccountTuple.guiSetting = GuiSetting()
    }
    
    init() {
        userAccountTuple.userName = "Robert"
        userAccountTuple.password = "Robert"
        let resource = TMRResourceFactory.getTMRResource()
        listTMRResource.append(resource)
        userAccountTuple.guiSetting = GuiSetting()
    }
    
    init(tuple : UserAccountTuple ) {
        userAccountTuple.guiSetting = tuple.guiSetting.copy() as! GuiSetting
        userAccountTuple.userName = tuple.userName
        userAccountTuple.password = tuple.password
        let resource = TMRResourceFactory.getTMRResource()
        listTMRResource.append(resource)
    }
    
    func getID()->Int{return userAccountTuple.currentID}
    func setID(ID:Int){userAccountTuple.currentID = ID}
    func getGuiSetting() -> GuiSetting { return userAccountTuple.guiSetting }
    func setGuiSetting(guiSetting : GuiSetting) {userAccountTuple.guiSetting = guiSetting }
    func getUserName() -> String { return userAccountTuple.userName }
    func setUserName(userName : String) { userAccountTuple.userName = userName }
    func getPassword() -> String { return userAccountTuple.password }
    func setPassword(password : String ) { userAccountTuple.password = password }
    func getUserAccountTuple() -> UserAccountTuple { return userAccountTuple }
    func setUserAccountTuple(tuple : UserAccountTuple) { userAccountTuple = tuple }
    
    func getAllResources() -> [TMRResource] {
        return listTMRResource
    }
    
    func getAllProjects() -> [TMRProject] {
        return listTMRProject
    }
    
    func addTMRResource(resource : TMRResource) {listTMRResource.append(resource)}
    
    func removeTMRResource(resource : TMRResource) {
        var index:Int = -1
        for i in 0..<listTMRResource.count  {
            let nameInList = listTMRResource[i].getResourceName()
            let nameInput = resource.getResourceName()
            if (nameInList == nameInput ) {
                index = i
                break;
            }
        }
        if (index >= 0 ) {
            listTMRResource.remove(at: index)
        }
    }
    
    func addTMRRecord(project : TMRProject) {listTMRProject.append(project) }
    
    func removeTMRProject(project : TMRProject) {
        var index:Int = -1
        for i in 0..<listTMRProject.count  {
            let nameInList = listTMRProject[i].getTMRProjectName()
            let nameInput = project.getTMRProjectName()
            if (nameInList == nameInput ) {
                index = i
                break;
            }
        }
        if (index >= 0 ) {
            listTMRProject.remove(at: index)
        }
    }
    
}
