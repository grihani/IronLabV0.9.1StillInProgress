//
//  ContratModel.swift
//  IronLab
//
//  Created by Formation iOS on 04/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class ContratModel: NSObject {
    
    var idContrat: Int!
    var nameContrat: String!
    var startDateContrat: String!
    var expiresOnContrat: String!
    var totalAmountDiscountContrat: String!
    var totalPercentageDiscountContrat: String!
    var statusContrat: String!
    
    override init() {
        super.init()
    }
    
    init(idContrat: Int, elementsOfContrat: [InitializationData]!) {
        super.init()
        self.idContrat = idContrat
        for element in elementsOfContrat {
            if element.name == "nameContrat" {
                nameContrat = element.value
            }
            else if element.name == "startDateContrat" {
                startDateContrat = element.value
            }
            else if element.name == "expiresOnContrat" {
                expiresOnContrat = element.value
            }
            else if element.name == "totalAmountDiscountContrat" {
                totalAmountDiscountContrat = element.value
            }
            else if element.name == "totalPercentageDiscountContrat" {
                totalPercentageDiscountContrat = element.value
            }
            else if element.name == "statusContrat" {
                statusContrat = element.value
            }
        }
    }
    
    override var description: String {
        return "idContrat: \(idContrat), " +
            "nameContrat: \(nameContrat), " +
            "startDateContrat: \(startDateContrat), " +
            "expiresOnContrat: \(expiresOnContrat), " +
            "totalAmountDiscountContrat: \(totalAmountDiscountContrat), " +
            "totalPercentageDiscountContrat: \(totalPercentageDiscountContrat), " +
            "statusContrat: \(statusContrat)"
    }
    
    static let DescriptionInDataBase = [
        "idContrat",
        "nameContrat",
        "startDateContrat",
        "expiresOnContrat",
        "totalAmountDiscountContrat",
        "totalPercentageDiscountContrat",
        "statusContrat"
    ]
    static let DescriptionForInsert = [
        "nameContrat",
        "startDateContrat",
        "expiresOnContrat",
        "totalAmountDiscountContrat",
        "totalPercentageDiscountContrat",
        "statusContrat"
    ]
    
    static let TableName = "Contrats"
}