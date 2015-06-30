//
//  ContactsModel.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ContactsModel: NSObject {
    var idContact: Int!
    var civilityContact: String!
    var firstNameContact: String!
    var lastNameContact: String!
    var jobTitleContact: String!
    var countryContact: String!
    var typeContact: String!
    var birthdateContact: String!
    var phoneBusinessContact: String!
    var phoneMobileContact: String!
    var emailContact: String!
    var preferredLanguageContact: String!
    var workingAdressContact: String!
    var linkedinProfileContact: String!
    var statusContact: Int!
    var favoriteContact: Int!
    var idContact1: Int!
    
    override init() {
        super.init()
    }
    
    init(idContact: Int, elementsOfContact: [InitializationData]!) {
        super.init()
        self.idContact = idContact
        for element in elementsOfContact {
            if element.name == "civilityContact" {
                civilityContact = element.value
            }
            else if element.name == "firstNameContact" {
                firstNameContact = element.value
            }
            else if element.name == "lastNameContact" {
                lastNameContact = element.value
            }
            else if element.name == "jobTitleContact" {
                jobTitleContact = element.value
            }
            else if element.name == "countryContact" {
                countryContact = element.value
            }
            else if element.name == "typeContact" {
                typeContact = element.value
            }
            else if element.name == "birthdateContact" {
                birthdateContact = element.value
            }
            else if element.name == "phoneBusinessContact" {
                phoneBusinessContact = element.value
            }
            else if element.name == "phoneMobileContact" {
                phoneMobileContact = element.value
            }
            else if element.name == "emailContact" {
                emailContact = element.value
            }
            else if element.name == "preferredLanguageContact" {
                preferredLanguageContact = element.value
            }
            else if element.name == "workingAdressContact" {
                workingAdressContact = element.value
            }
            else if element.name == "linkedinProfileContact" {
                linkedinProfileContact = element.value
            }
            else if element.name == "statusContact" {
                statusContact = element.value.toInt()!
            }
            else if element.name == "favoriteContact" {
                favoriteContact = element.value.toInt()!
            }
            else if element.name == "idContact1" {
                idContact1 = element.value.toInt()!
            }
        }
    }
    
    static let DescriptionInDataBase: [String] = [
            "idContact",
            "civilityContact",
            "firstNameContact",
            "lastNameContact",
            "jobTitleContact",
            "countryContact",
            "typeContact",
            "birthdateContact",
            "phoneBusinessContact",
            "phoneMobileContact",
            "emailContact",
            "preferredLanguageContact",
            "workingAdressContact",
            "linkedinProfileContact",
            "statusContact",
            "favoriteContact",
            "idContact1"
        ]
    static let TableName: String = "Contacts"
    
    static let name = [
        "idContact",
        "firstNameContact",
        "lastNameContact"
    ]
}
