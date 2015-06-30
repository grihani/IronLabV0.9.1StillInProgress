//
//  SearchForContactsDataManager.swift
//  IronLab
//
//  Created by CSC CSC on 09/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForContactsDataManager: NSObject {
   
    typealias SearchResult = (String, [ContactsModel])
    
    func getContacts() -> [SearchResult] {
        var contacts: [SearchResult] = []
        var elementsOfAccount = ["idAccount", "nameAccount"]
        var elementsOfContact = ["idContact", "lastNameContact", "firstNameContact"]

        var querySQL = createQuery(elementsOfAccount, tableName: AccountsModel.TableName)
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var contactsOfAccount: [ContactsModel] = []
                
                
            }
        }
        return contacts
    }
    
    func createQuery(args: [String], tableName: String) -> String {
        var querySQL = "SELECT "
        for arg in args {
            querySQL += arg + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM " + tableName + " "
        return querySQL
    }
}
