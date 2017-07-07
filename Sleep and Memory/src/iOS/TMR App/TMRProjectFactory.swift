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
        let filemgr = FileManager.default
        let docs=filemgr.urls(for: .documentDirectory,in: .userDomainMask)[0].path;
        //list all contents of directory and return as [String] OR nil if failed
        let files : [String]? = try? filemgr.contentsOfDirectory(atPath:docs);
        
        if ( files != nil ) {
        for i in 0..<files!.count {
            let fileName : String = "\(files![i])"
            print("file name is \(files?[i])")
            if fileName.contains("ExportedInternal.project.txt") {
                importProjectFromFile(fileName: fileName)
            }
        }
        }
    }
    
    static func importProjectFromFile(fileName : String) {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    let project = TMRProjectImpl()
                    project.fromJson(dictionary: object)
                    self.getTMRProject(projectName: project.getTMRProjectName(), userAccount: project.getUser(), resourceName: project.getTMRResource().getResourceName())
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
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
    
    static func mapAllProjects() -> TMRExportAllProjects {
        var tmrExportAllProject = TMRExportAllProjects()
        
        for (projectName, project ) in listTMRProject {
            var tmrExportProject = TMRExportProject(projectName: projectName, listPreNapEntries: project.getPreNapEntries(), listPostNapEntries: project.getPostNapEntries())
            tmrExportAllProject.addProject(project: tmrExportProject)
        }
        
        return tmrExportAllProject
    }
}
