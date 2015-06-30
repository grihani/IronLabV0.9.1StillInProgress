//
//  AccountsModel.swift
//  IronLab
//
//  Created by ghassane rihani on 24/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class AccountsModel: NSObject {
    
    var idAccount: Int!
    var nameAccount: String!
    var shortNameAccount: String!
    var leadSource: String!
    var statusAccount: String!
    var industryAccount: String!
    var segmentAccount: String!
    var websiteAccount: String!
    var phoneAccount: String!
    var faxAccount: String!
    var coverageAccount: String!
    var regionAccount: String!
    var adressAccount: String!
    var idAccount1: Int!
    var countryAccount: String!
    var typeAccount: String!
    var favoriteAccount: Int!
    var turnoverAccount: String!
    var numberEmployeesAccount: Int!
    var logoUrlAccount: String!
    
    override init() {
        super.init()
    }
    
    init(idAccount: Int, elementsOfAccount: [InitializationData]!) {
        super.init()
        self.idAccount = idAccount
        if elementsOfAccount != nil {
            for element in elementsOfAccount {
                if element.name == "nameAccount" {
                    nameAccount = element.value
                }
                else if element.name == "shortNameAccount" {
                    shortNameAccount = element.value
                }
                else if element.name == "leadSource" {
                    leadSource = element.value
                }
                else if element.name == "statusAccount" {
                    statusAccount = element.value
                }
                else if element.name == "industryAccount" {
                    industryAccount = element.value
                }
                else if element.name == "segmentAccount" {
                    segmentAccount = element.value
                }
                else if element.name == "websiteAccount" {
                    websiteAccount = element.value
                }
                else if element.name == "phoneAccount" {
                    phoneAccount = element.value
                }
                else if element.name == "faxAccount" {
                    faxAccount = element.value
                }
                else if element.name == "coverageAccount" {
                    coverageAccount = element.value
                }
                else if element.name == "regionAccount" {
                    regionAccount = element.value
                }
                else if element.name == "adressAccount" {
                    adressAccount = element.value
                }
                else if element.name == "typeAccount" {
                    typeAccount = element.value
                }
                else if element.name == "countryAccount" {
                    countryAccount = element.value
                }
                else if element.name == "idAccount1" {
                    idAccount1 = element.value.toInt()!
                }
                else if element.name == "favoriteAccount" {
                    favoriteAccount = element.value.toInt()!
                }
                else if element.name == "turnoverAccount" {
                    turnoverAccount = element.value
                }
                else if element.name == "numberEmployeesAccount" {
                    numberEmployeesAccount = element.value.toInt()!
                }
                else if element.name == "logoUrlAccount" {
                    logoUrlAccount = element.value
                }
            }
        }
    }
    
    override var description: String {
        return "idAccount: \(idAccount), " +
            "nameAccount: \(nameAccount), " +
            "shortNameAccount: \(shortNameAccount)" +
            "leadSource: \(leadSource), " +
            "statusAccount: \(statusAccount), " +
            "industryAccount: \(industryAccount), " +
            "segmentAccount: \(segmentAccount), " +
            "websiteAccount: \(websiteAccount), " +
            "phoneAccount: \(phoneAccount), " +
            "faxAccount: \(faxAccount), " +
            "coverageAccount: \(coverageAccount), " +
            "regionAccount: \(regionAccount), " +
            "adressAccount: \(adressAccount), " +
            "typeAccount: \(typeAccount), " +
            "countryAccount: \(countryAccount), " +
        "idAccount1: \(idAccount1), "
    }
    
    static let DescriptionInDataBase: [String] = [
        "idAccount",
        "nameAccount",
        "shortNameAccount",
        "leadSource",
        "statusAccount",
        "industryAccount",
        "segmentAccount",
        "websiteAccount",
        "phoneAccount",
        "faxAccount",
        "coverageAccount",
        "regionAccount",
        "adressAccount",
        "typeAccount",
        "countryAccount",
        "idAccount1",
        "turnoverAccount",
        "turnoverAccount",
        "numberEmployeesAccount",
        "logoUrlAccount"
    ]
    static let TableName: String = "Account"
}
