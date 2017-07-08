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
    static func getTMRProject(projectName : String, userAccount : UserAccount,
                              resourceName : String ) -> TMRProject {
        
        if let project = listTMRProject[projectName] {
                return project;
        }
        
        var _projectName = projectName
        
        if projectName.isEmpty {
            print("projectName is empty")
            _projectName = "project_0\(listTMRProject.count)"
        }
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, resourceName: resourceName, user: userAccount)
        
        listTMRProject[projectName] = retProject
        return retProject;
    }
    
    static func getTMRProject(userAccount : UserAccount,
                              resourceName : String ) -> TMRProject {
        
        let _projectName = "project_0\(listTMRProject.count)"
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, resourceName: resourceName, user: userAccount)
        
        listTMRProject[_projectName] = retProject
        return retProject;
    }
    
    static func getTMRProject(projectName : String, userAccount : UserAccount) -> TMRProject {
        
        if let project = listTMRProject[projectName] {
                return project;
        }
        
        var _projectName = projectName
        
        if projectName.isEmpty {
            print("projectName is empty")
            _projectName = "project_0\(listTMRProject.count)"
        }
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, user: userAccount)
        
        listTMRProject[_projectName] = retProject
        return retProject;
    }
    
    static func getTMRProject(tuple : TMRProjectTuple) -> TMRProject {
        
        if let project = listTMRProject[tuple.tmrProjectName] {
            return project;
        }
        
        let retProject:TMRProjectImpl = TMRProjectImpl(tuple: tuple)
        
        listTMRProject[tuple.tmrProjectName] = retProject
        return retProject;
    }

    static func getTMRProject(userAccount : UserAccount) -> TMRProject {
        
        let _projectName = "project_0\(listTMRProject.count)"
        
        let retProject:TMRProjectImpl = TMRProjectImpl(projectName: _projectName, user: userAccount)
        
        listTMRProject[_projectName] = retProject
        return retProject;
    }
    
    static func getTMRProject(projectName : String) -> TMRProject? {
        
        if let project = listTMRProject[projectName] {
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
        //var tmrExportProject = TMRExportProject(projectName: project.getTMRProjectName(), listPreNapEntries: project.getPreNapEntries(), listPostNapEntries: project.getPostNapEntries())
    
        var tmrSession = Session(project: project,screen:screen)
    
        let file = "\(project.getTMRProjectName())Exported.project.txt"
        //let session = tmrSession.toDictionary()
        let session = tmrSession.toJsonString()
       // let jsonObj = tmrExportProject.toJSON()
        //let jsonObj = project.toJSON()
        //print("jsonObj: \(session.beautify)")
        
        
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: session,
//            options: .prettyPrinted) {
//            let theJSONText = String(data: theJSONData,
//                                     encoding: .ascii)
//            print("JSON string = \(theJSONText!)")
//            
//            retString = theJSONText!
//            
//            /*
//            let filemgr = FileManager.default
//            if filemgr.fileExists(atPath: "/\(file)") {
//                print("File exists")
//                do {
//                    try filemgr.removeItem(atPath: "/\(file)")
//                    print("Removal successful")
//                } catch let error {
//                    print("Error: \(error.localizedDescription)")
//                }
//            } else {
//                print("File not found")
//            }
//            
//            filemgr.createFile(atPath: "/\(file)", contents: theJSONData, attributes: nil)
//            */
//            
//        }
//        
//        /*
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: project.toJSON(),
//            options: []) {
//            let theJSONText = String(data: theJSONData,
//                                     encoding: .ascii)
//            print("JSON string = \(theJSONText!)")
//            
//            let fileInternal = "\(project.getTMRProjectName())ExportedInternal.project.txt"
//            let filemgr = FileManager.default
//            if filemgr.fileExists(atPath: "/\(fileInternal)") {
//                print("File exists")
//                do {
//                    try filemgr.removeItem(atPath: "/\(fileInternal)")
//                    print("Removal successful")
//                } catch let error {
//                    print("Error: \(error.localizedDescription)")
//                }
//            } else {
//                print("File not found")
//            }
//            
//            filemgr.createFile(atPath: "/\(fileInternal)", contents: theJSONData, attributes: nil)
//           
//            
//        }
//        */
        
        print("Exiting exportProjectToFile")
        return session
    }
    
    /*
    static func exportAllProjectsToFile() {
        var tmrExportAllProject : TMRExportAllProjects = mapAllProjects();
        let file = "projectsExported.txt"
        
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: tmrExportAllProject.toJSON(),
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let filemgr = FileManager.default
            if filemgr.fileExists(atPath: "/\(file)") {
                print("File exists")
                do {
                    try filemgr.removeItem(atPath: "/\(file)")
                    print("Removal successful")
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("File not found")
            }
            
            filemgr.createFile(atPath: "/\(file)", contents: theJSONData, attributes: nil)
            
            
        }
        
        let fileInternal = "projectsExportedInternal.txt"
        var dictionary: [String : Any] = [:]
        var tmrProjectsDictionary: [String : Any] = [:]
        
        for (projectName, project) in listTMRProject {
            tmrProjectsDictionary[projectName] = project.toJSON()
        }
        dictionary["AllProjects"] = tmrProjectsDictionary
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            
            
            let filemgr = FileManager.default
            if filemgr.fileExists(atPath: "/\(fileInternal)") {
                print("File exists")
                do {
                    try filemgr.removeItem(atPath: "/\(fileInternal)")
                    print("Removal successful")
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("File not found")
            }
            
            filemgr.createFile(atPath: "/\(fileInternal)", contents: theJSONData, attributes: nil)
            
            
        }
        
        
    }
    */
    static func mapAllProjects() -> TMRExportAllProjects {
        var tmrExportAllProject = TMRExportAllProjects()
        
        for (projectName, project ) in listTMRProject {
            var tmrExportProject = TMRExportProject(projectName: projectName, listPreNapEntries: project.getPreNapEntries(), listPostNapEntries: project.getPostNapEntries())
            tmrExportAllProject.addProject(project: tmrExportProject)
        }
        
        return tmrExportAllProject
    }
    
    static func save(name:String,proj : TMRProjectTuple){
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
