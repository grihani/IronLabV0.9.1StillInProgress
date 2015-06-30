//
//  OpportunityModel.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class OpportunityModel: NSObject {
    
    var idOpportunity: Int!
    var nameOpportunity: String!
    var statusOpportunity: String!
    var ownerOpportunity: String!
    var relatedContactOpportunity: String!
    var relatedAccountOpportunity: String!
    var probabilityOpportunity: Int!
    var expectedCloseDateOpportunity: String!
    var competitorsOpportunity: String!
    var potentialAmountOpportunity: Int!
    var amountOpportunity: Int!
    var typeOpportunity: String!
    var teamOpportunity: String!
    var campaignSourceOpportunity: String!
    var closeDateOpportunity: String!
    var descriptionOpportunity: String!
    var businessUnitOpportunity: String!
    var accountContextOpportunity: String!
    var rolePropositionOpportunity: String!
    var priorityOpportunity: String!
    
    override init() {
        super.init()
    }
    
    init(idOpportunity: Int, elementsOfOpportunity: [InitializationData]!) {
        super.init()
        self.idOpportunity = idOpportunity
        if elementsOfOpportunity != nil {
            for element in elementsOfOpportunity {
                if element.name == "nameOpportunity" {
                    nameOpportunity = element.value
                }
                else if element.name == "statusOpportunity" {
                    statusOpportunity = element.value
                }
                else if element.name == "ownerOpportunity" {
                    ownerOpportunity = element.value
                }
                else if element.name == "relatedContactOpportunity" {
                    relatedContactOpportunity = element.value
                }
                else if element.name == "relatedAccountOpportunity" {
                    relatedAccountOpportunity = element.value
                }
                else if element.name == "probabilityOpportunity" {
                    probabilityOpportunity = element.value.toInt()
                }
                else if element.name == "expectedCloseDateOpportunity" {
                    expectedCloseDateOpportunity = element.value
                }
                else if element.name == "competitorsOpportunity" {
                    competitorsOpportunity = element.value
                }
                else if element.name == "potentialAmountOpportunity" {
                    potentialAmountOpportunity = element.value.toInt()
                }
                else if element.name == "amountOpportunity" {
                    amountOpportunity = element.value.toInt()
                }
                else if element.name == "typeOpportunity" {
                    typeOpportunity = element.value
                }
                else if element.name == "teamOpportunity" {
                    teamOpportunity = element.value
                }
                else if element.name == "campaignSourceOpportunity" {
                    campaignSourceOpportunity = element.value
                }
                else if element.name == "closeDateOpportunity" {
                    closeDateOpportunity = element.value
                }
                else if element.name == "descriptionOpportunity" {
                    descriptionOpportunity = element.value
                }
                else if element.name == "businessUnitOpportunity" {
                    businessUnitOpportunity = element.value
                }
                else if element.name == "accountContextOpportunity" {
                    accountContextOpportunity = element.value
                }
                else if element.name == "rolePropositionOpportunity" {
                    rolePropositionOpportunity = element.value
                }
                else if element.name == "priorityOpportunity" {
                    priorityOpportunity = element.value
                }
            }
        }
    }
    
    override var description: String {
        return "idOpportunity: \(idOpportunity), " +
            "nameOpportunity: \(nameOpportunity), " +
            "statusOpportunity: \(statusOpportunity), " +
            "ownerOpportunity: \(ownerOpportunity), " +
            "relatedContactOpportunity: \(relatedContactOpportunity), " +
            "relatedAccountOpportunity: \(relatedAccountOpportunity), " +
            "probabilityOpportunity: \(probabilityOpportunity), " +
            "expectedCloseDateOpportunity: \(expectedCloseDateOpportunity), " +
            "competitorsOpportunity: \(competitorsOpportunity), " +
            "potentialAmountOpportunity: \(potentialAmountOpportunity), " +
            "amountOpportunity: \(amountOpportunity), " +
            "typeOpportunity: \(typeOpportunity), " +
            "teamOpportunity: \(teamOpportunity), " +
            "campaignSourceOpportunity: \(campaignSourceOpportunity), " +
            "closeDateOpportunity: \(closeDateOpportunity), " +
            "descriptionOpportunity: \(descriptionOpportunity), " +
            "businessUnitOpportunity: \(businessUnitOpportunity), " +
            "accountContextOpportunity: \(accountContextOpportunity), " +
        "rolePropositionOpportunity: \(rolePropositionOpportunity)"
    }
    
    static let DescriptionInDataBase = [
        "idOpportunity",
        "nameOpportunity",
        "statusOpportunity",
        "ownerOpportunity",
        "relatedContactOpportunity",
        "relatedAccountOpportunity",
        "probabilityOpportunity",
        "expectedCloseDateOpportunity",
        "competitorsOpportunity",
        "potentialAmountOpportunity",
        "amountOpportunity",
        "typeOpportunity",
        "teamOpportunity",
        "campaignSourceOpportunity",
        "closeDateOpportunity",
        "descriptionOpportunity",
        "businessUnitOpportunity",
        "accountContextOpportunity",
        "rolePropositionOpportunity",
        "priorityOpportunity"
    ]
    static let DescriptionForInsert = [
        "nameOpportunity",
        "statusOpportunity",
        "ownerOpportunity",
        "relatedContactOpportunity",
        "relatedAccountOpportunity",
        "probabilityOpportunity",
        "expectedCloseDateOpportunity",
        "competitorsOpportunity",
        "potentialAmountOpportunity",
        "amountOpportunity",
        "typeOpportunity",
        "teamOpportunity",
        "campaignSourceOpportunity",
        "closeDateOpportunity",
        "descriptionOpportunity",
        "businessUnitOpportunity",
        "accountContextOpportunity",
        "rolePropositionOpportunity",
        "priorityOpportunity"
    ]
    
    static let TableName = "Opportunity"
    static let TableConnectedActivity = "Opportunity_Activities"
}