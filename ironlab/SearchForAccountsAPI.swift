//
//  SearchForAccountsAPI.swift
//  IronLab
//
//  Created by ghassane rihani on 25/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForAccountsAPI: NSObject {
    typealias TypeDataSearchPerMeetings = SearchForAccountsDataManager.SearchPerMeetings
    typealias TypeDataSearchPerName = SearchForAccountsDataManager.SearchPerName
    
    class var sharedInstance: SearchForAccountsAPI {
        struct Singleton {
            static let instance = SearchForAccountsAPI()
        }
        return Singleton.instance
    }
    var searchForAccountsDataManager: SearchForAccountsDataManager
    
    override init() {
        searchForAccountsDataManager = SearchForAccountsDataManager()
    }
    
    func getAccountsPerMeetings() -> [TypeDataSearchPerMeetings] {
        return searchForAccountsDataManager.getAccountsPerMeetings()
    }
    
    func getAccountsPerName(#ascendant: Bool) -> [TypeDataSearchPerName]  {
        return searchForAccountsDataManager.getAllAccounts(ascendant: ascendant)
    }
    
    func searchAccountByNAmeAccount(nameAccount: String) -> [TypeDataSearchPerName] {
        return searchForAccountsDataManager.searchAccountByNAmeAccount(nameAccount)
    }
}
