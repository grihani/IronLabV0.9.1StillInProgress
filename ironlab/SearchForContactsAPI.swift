//
//  SearchForContactsAPI.swift
//  IronLab
//
//  Created by CSC CSC on 09/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForContactsAPI: NSObject {
    class var sharedInstance: SearchForContactsAPI {
        struct Singleton {
            static let instance = SearchForContactsAPI()
        }
        return Singleton.instance
    }
    var searchForContactsDataManager: SearchForContactsDataManager
    
    override init() {
        searchForContactsDataManager = SearchForContactsDataManager()
    }
}
