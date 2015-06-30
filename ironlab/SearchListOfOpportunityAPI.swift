//
//  SearchListOfOpportunityAPI.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class SearchListOfOpportunityAPI: NSObject {
    typealias TypeDataForSearch = SearchListOfOpportunityDataManager.TypeToReturnForSearchList
    class var sharedInstance: SearchListOfOpportunityAPI {
        struct Singleton {
            static let instance = SearchListOfOpportunityAPI()
        }
        return Singleton.instance
    }
    
    private var searchListOfOpportunityDataManager: SearchListOfOpportunityDataManager
    
    override init() {
        searchListOfOpportunityDataManager = SearchListOfOpportunityDataManager()
    }
    
    func getOpportunityFromIdOpportunity(#idOpportunity: Int) -> OpportunityModel {
        return searchListOfOpportunityDataManager.getOpportunityFromIdOpportunity(idOpportunity: idOpportunity)
    }
    
    func getSearchListOpportunitiesFromAToZ() -> TypeDataForSearch {
        return searchListOfOpportunityDataManager.getSearchListOpportunitiesFromAlphabeticOrder(order: "ASC")
    }
    
    func getSearchListOpportunitiesFromZToA() -> TypeDataForSearch {
        return searchListOfOpportunityDataManager.getSearchListOpportunitiesFromAlphabeticOrder(order: "DESC")
    }
    
    func getSearchListOpportunitiesFromCloseDate() -> TypeDataForSearch {
        return searchListOfOpportunityDataManager.getSearchListOpportunitiesFromCloseDate()
    }
    
    func getSearchListOpportunitiesFromStatus() -> TypeDataForSearch {
        return searchListOfOpportunityDataManager.getSearchListOpportunitiesFromStatus()
    }
    
    func getNextOpportunities() -> [OpportunityModel] {
        return searchListOfOpportunityDataManager.getNextOpportunities()
    }
}