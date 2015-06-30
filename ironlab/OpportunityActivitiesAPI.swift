//
//  OpportunityActivitiesAPI.swift
//  IronLab
//
//  Created by Formation iOS on 03/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class OpportunityActivitiesAPI: NSObject {
    typealias TypeData = OpportunityActivitiesDataManager.TypeToReturnForSearchList
    class var sharedInstance: OpportunityActivitiesAPI {
        struct Singleton {
            static let instance = OpportunityActivitiesAPI()
        }
        return Singleton.instance
    }
    
    private var opportunityActivitiesDataManager: OpportunityActivitiesDataManager
    
    override init() {
        opportunityActivitiesDataManager = OpportunityActivitiesDataManager()
    }
    
    func getActivitiesFromIdOpportunity(#idOpportunity: Int) -> TypeData {
        return opportunityActivitiesDataManager.getActivitiesFromIdOpportunity(idOpportunity: idOpportunity)
    }
}