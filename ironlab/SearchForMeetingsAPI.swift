//
//  SearchForMeetingsAPI.swift
//  ironlab
//
//  Created by CSC on 21/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForMeetingsAPI: NSObject {
    class var sharedInstance: SearchForMeetingsAPI {
        struct Singleton {
            static let instance = SearchForMeetingsAPI()
        }
        return Singleton.instance
    }
    
    var searchForMeetingsDataManager: SearchForMeetingsDataManager
    
    override init() {
        searchForMeetingsDataManager = SearchForMeetingsDataManager()
    }
    
    typealias AllMeetings = [SearchForMeetingsDataManager.AllMeetings]
    
    func getAllMeetings() -> AllMeetings {
        return searchForMeetingsDataManager.getAllMeetings()
    }
    
}
