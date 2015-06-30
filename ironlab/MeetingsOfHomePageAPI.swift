//
//  MeetingsOfHomePage.swift
//  IronLab
//
//  Created by ghassane rihani on 24/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class MeetingsOfHomePageAPI: NSObject {
    
    typealias TypeData = HomePageDataManager.TypeDataToReturn
    
    class var sharedInstance: MeetingsOfHomePageAPI {
        struct Singleton {
            static let instance = MeetingsOfHomePageAPI()
        }
        return Singleton.instance
    }
    
    private var homePageDataManager: HomePageDataManager
    
    override init() {
        homePageDataManager = HomePageDataManager()
    }
    
    func getMeetingsOfDate(date: NSDate) -> [TypeData]{
        return homePageDataManager.getMeetingsOfDay(date)
    }
    
    func getNextMeetings() -> [TypeData] {
        return homePageDataManager.getNextMeetings()
    }
    
    typealias DataOfMissingDocs = [HomePageDataManager.DataOfMissingDocs]
    
    func getMissingDocuments() -> DataOfMissingDocs {
        return homePageDataManager.getMissingDocs()
    }
    
    
    func getOpportunities() -> [OpportunityModel] {
        return SearchListOfOpportunityAPI.sharedInstance.getNextOpportunities()
    }
    
    typealias DataOfAccountsToFollow = HomePageDataManager.DataOfAccountsToFollow
    func getAccountsToFollow() -> [DataOfAccountsToFollow]
    {
        return  homePageDataManager.getAccountsToFollow()
    }
}
