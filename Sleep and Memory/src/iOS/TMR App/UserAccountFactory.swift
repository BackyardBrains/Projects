//
//  UserAccountFactory.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class UserAccountFactory {
    static var listUserAccount = [UserAccount]()
    static func createUserAccount(userName : String, password : String ) -> UserAccount {
        
        for i in 0..<listUserAccount.count{
            let account:UserAccount = listUserAccount[i]
            if ( account.getUserName() == userName ) {
                print("old")
                return account;
            }
        }
        print("new")
        let retAccount:UserAccount = UserAccount(userName:userName,password:password)
        listUserAccount.append(retAccount)
        return retAccount;
    }
    
    static func getUserAccount(userName : String ) -> UserAccount? {
        var account:UserAccount? = nil
        
        for i in 0..<listUserAccount.count{
            if ( listUserAccount[i].getUserName() == userName ) {
                account = listUserAccount[i]
                break
            }
        }
        return account
    }
    
    static func getUserAccount(tuple : UserAccountTuple) -> UserAccount {
        for i in 0..<listUserAccount.count{
            let account:UserAccount = listUserAccount[i]
            if ( account.getUserName() == tuple.userName ) {
                return account;
            }
        }
        
        let retAccount:UserAccount = UserAccount(tuple: tuple)
        print("Tuple:\(tuple)")
        listUserAccount.append(retAccount)
        return retAccount;
    }
    
    static func importAllUserAccountssFromFiles() {
        print("entering importAllUserAccountssFromFiles")
        let files = getNameList()
        for file in files  {            
            let accountTuple = load(name: file)
            getUserAccount(tuple: accountTuple!)
        }
        
    }
    
    static func importUserAccountFromFile(userName : String) -> UserAccount {
        let accountTuple = load(name: userName)
        return getUserAccount(tuple: accountTuple!)
    }
    
    static func exportAllUserAccountToFile() {
        for userAccount in listUserAccount {
            save(name: userAccount.getUserName(), user: userAccount.getUserAccountTuple())
        }
    }
    
    
    static func save(name:String,user: UserAccountTuple){
        del(name: name)
        user.saveToDocuments(name+".user")
    }
    
    static func load(name:String) -> UserAccountTuple? {
        return UserAccountTuple(fileNameInDocuments: name+".user")
    }
    
    static func getNameList() -> [String]{
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let files = directoryContents.filter{ $0.pathExtension == "user" }
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
            let fileUrl = documentsUrl.appendingPathComponent(name + ".user")
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
