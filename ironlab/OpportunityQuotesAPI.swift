//
//  OpportunityQuotesAPI.swift
//  IronLab
//
//  Created by Formation iOS on 04/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class OpportunityQuotesAPI: NSObject {
    typealias TypeData = OpportunityQuotesDataManager.TypeToReturnForSearchList
    class var sharedInstance: OpportunityQuotesAPI {
        struct Singleton {
            static let instance = OpportunityQuotesAPI()
        }
        return Singleton.instance
    }
    
    private var opportunityQuotesDataManager: OpportunityQuotesDataManager
    
    override init() {
        opportunityQuotesDataManager = OpportunityQuotesDataManager()
    }
    
    func getContratsFromIdOpportunity(#idOpportunity: Int) -> [ContratModel] {
        return opportunityQuotesDataManager.getContratsFromIdOpportunity(idOpportunity: idOpportunity)
    }
}