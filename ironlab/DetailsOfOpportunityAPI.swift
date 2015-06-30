//
//  DetailsOfOpportunityAPI.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class DetailsOfOpportunityAPI: NSObject {
    typealias TypeData = DetailsOfOpportunityDataManager.TypeDataToReturn
    class var sharedInstance: DetailsOfOpportunityAPI {
        struct Singleton {
            static let instance = DetailsOfOpportunityAPI()
        }
        return Singleton.instance
    }
    
    private var detailsOfOpportunityDataManager: DetailsOfOpportunityDataManager
    
    override init() {
        detailsOfOpportunityDataManager = DetailsOfOpportunityDataManager()
    }
    
    func getOpportunityFirstClosingDate() -> TypeData {
        return detailsOfOpportunityDataManager.getOpportunityFirstClosingDate()
    }
    
    func getOpportunityParametersFrom (opportunity: OpportunityModel) -> OpportunityModel {
        return detailsOfOpportunityDataManager.getOpportunityParametersFrom(opportunity)
    }
    func getAccountOfOpportunity(opportunity: OpportunityModel) -> AccountsModel {
        return detailsOfOpportunityDataManager.getAccountOfOpportunity(opportunity)
    }
}