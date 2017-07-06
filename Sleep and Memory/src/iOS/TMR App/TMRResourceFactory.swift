//
//  TMRResourceFactory.swift
//  TMR App
//
//  Created by Robert Zhang on 6/16/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class TMRResourceFactory {
    
    static var listTMRResource = [TMRResourceImpl]()
    static func getTMRResource(resourceName : String) -> TMRResource {
        
        for i in 0..<listTMRResource.count{
            let resource:TMRResourceImpl = listTMRResource[i]
            if ( resource.resourceName == resourceName ) {
                return resource;
            }
        }
        
        let retResource:TMRResourceImpl = TMRResourceImpl(name:resourceName)
        retResource.getAllResources()
        listTMRResource.append(retResource)
        return retResource
    }
    
    static func getTMRResource() -> TMRResource {
        return getTMRResource(resourceName: "default")
    }
    
}
