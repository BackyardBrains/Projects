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
                return account;
            }
        }
        
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
    
    
    
}
