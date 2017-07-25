//
//  TMRProjectFactory.swift
//  TMR App
//
//  Created by Robert Zhang on 6/18/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class TMRProjectFactory {
    
    static var listTMRProject : [String : TMRProject] = [:]
    
    /*
     static func getTMRProject(userAccount : UserAccount,
     resourceName : String ) -> TMRProject {
     
     let _projectName = "project_0\(listTMRProject.count)"
     
     let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, resourceName: resourceName, user: userAccount)
     
     listTMRProject[_projectName] = retProject
     return retProject;
     }
     */
    
    static func getTMRProject(projectName : String, ID:Int, userAccount : UserAccount) -> TMRProject {
        
        let ID = "proj"+String(ID)
        
        if let project = listTMRProject[ID] {
            print("old")
            return project;
        }
        
        var _projectName = projectName
        
        if projectName.isEmpty {
            print("projectName is empty")
            _projectName = "project_0\(listTMRProject.count)"
        }
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, ID:ID, user: userAccount)
        print("new")
        listTMRProject[ID] = retProject
        return retProject;
    }
    
    static func getTMRProject(tuple : TMRProjectTuple) -> TMRProject {
        
        if let project = listTMRProject[tuple.tmrID] {
            return project;
        }
        
        let retProject:TMRProjectImpl = TMRProjectImpl(tuple: tuple)
        
        listTMRProject[tuple.tmrID] = retProject
        return retProject;
    }
    
    static func getTMRProject(userAccount : UserAccount,ID:Int) -> TMRProject {
        
        let _projectName = "project_0\(listTMRProject.count)"
        
        let ID = "proj"+String(ID)
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, ID:ID, user: userAccount)
        
        listTMRProject[ID] = retProject
        return retProject;
    }
    
    static func getTMRProject(ID : String) -> TMRProject? {
        
        if let project = listTMRProject[ID] {
            return project;
        }
        
        return nil;
    }
    
    
    
    static func getAllTMRProjects () -> [String :TMRProject] {
        return self.listTMRProject;
    }
    
    static func importAllProjectsFromFiles() {
        print("entering importAllProjectFromFiles")
        let files = getNameList()
        for file in files  {
            
            let projectTuple = load(name: file)
            getTMRProject(tuple: projectTuple)
        }
        
    }
    
    static func importProjectFromFile(projectName : String) ->TMRProject {
        let projectTuple = load(name: projectName)
        return getTMRProject(tuple: projectTuple)
    }
    
    static func exportAllProjectsToFile() {
        for project in listTMRProject {
            save(name: project.key, proj: project.value.getTMRProjectTuple())
        }
    }
    
    
    static func exportProjectToFile(project: TMRProject, screen:TMRScreen) -> String {
        print("Entering exportProjectToFile")
        var retString = "default"
        var tmrSession = Session(project: project)
        let file = "\(project.getTMRID())Exported.project.txt"
        let session = tmrSession.toJsonString()
        print("Exiting exportProjectToFile")
        return session
    }
    
    static func mapAllProjects() -> TMRExportAllProjects {
        var tmrExportAllProject = TMRExportAllProjects()
        
        for (projectName, project ) in listTMRProject {
            var tmrExportProject = TMRExportProject(projectName: projectName, listPreNapEntries: project.getPreNapEntries(), listPostNapEntries: project.getPostNapEntries())
            tmrExportAllProject.addProject(project: tmrExportProject)
        }
        
        return tmrExportAllProject
    }
    
    static func save(name:String,proj : TMRProjectTuple){
        del(name: name)
        proj.saveToDocuments(name+".proj")
    }
    
    static func load(name:String) -> TMRProjectTuple {
        return TMRProjectTuple(fileNameInDocuments: name+".proj")
    }
    
    static func getNameList() -> [String]{
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let files = directoryContents.filter{ $0.pathExtension == "proj" }
            //print("user urls:",files)
            let fileNames = files.map{ $0.deletingPathExtension().lastPathComponent }
            //print("user list:", fileNames)
            return fileNames
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return []
    }
    
    static func del(name:String){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileUrl = documentsUrl.appendingPathComponent(name + ".proj")
            try FileManager.default.removeItem(at: fileUrl)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func delAll() {
        for file in getNameList() {
            del(name: file)
        }
    }
    
}
