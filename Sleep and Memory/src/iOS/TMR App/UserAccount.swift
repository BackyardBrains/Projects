//
//  UserAccount.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class UserAccount {
    private var userName : String
    private var password : String
    private var listTMRProject = [TMRProject]()
    private var guiSetting : GuiSetting
    private var listTMRResource = [TMRResource]()
    
    init(userName:String, password:String) {
        self.userName = userName;
        self.password = password;
        let resource = TMRResourceFactory.getTMRResource()
        listTMRResource.append(resource)
        self.guiSetting = GuiSetting()
    }
    
    init() {
        self.userName = "Robert"
        self.password = "Robert"
        let resource = TMRResourceFactory.getTMRResource()
        listTMRResource.append(resource)
        self.guiSetting = GuiSetting()
    }
    
    func getGuiSetting() -> GuiSetting { return guiSetting }
    func setGuiSetting(guiSetting : GuiSetting) {self.guiSetting = guiSetting }
    func getUserName() -> String { return userName }
    func setUserName(userName : String) { self.userName = userName }
    func getPassword() -> String { return password }
    func setPassword(password : String ) { self.password = password }
    
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
    
    func toJSON() -> [String:Any] {
        var dictionary: [String : Any] = [:]
        
        dictionary["userName"] = userName
        dictionary["password"] = password
        return dictionary
    }
    
    func fromJson (dictionary : [String : Any]) {
        var stringName : String = dictionary["userName"] as! String
        self.userName = stringName
        stringName = dictionary["password"] as! String
        self.password = stringName
    }
    
}
