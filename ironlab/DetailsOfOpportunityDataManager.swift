//
//  DetailsOfOpportunityDataManager.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class DetailsOfOpportunityDataManager: NSObject {
    typealias TypeDataToReturn = OpportunityModel
    
    private let dateFormatter = NSDateFormatter()
    private let TypeOfDateInSQLiteDataBase = "yyyy-MM-dd HH:mm"
    
    var opportunity: OpportunityModel!
    
    override init() {
        super.init()
    }
    
    func getOpportunityFirstClosingDate() -> TypeDataToReturn {
        var dataToReturn: TypeDataToReturn = TypeDataToReturn()
        let elementsOfOpportunity = OpportunityModel.DescriptionInDataBase
        var querySQL = createQueryFromString(elementsOfOpportunity)
        
        querySQL += " ORDER BY datetime(expectedCloseDateOpportunity) ASC LIMIT 1"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() {
                var opportunityArgs = [InitializationData]()
                let idOpportunity = Int(result.intForColumn("idOpportunity"))
                for i in 1..<elementsOfOpportunity.count {
                    let attribute = elementsOfOpportunity[i]
                    let opportunityArg: InitializationData = (attribute, result.stringForColumn(attribute))
                    opportunityArgs.append(opportunityArg)
                }
                let opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
                dataToReturn = opportunity
            }
        }
        return dataToReturn
    }
    
    func getOpportunityParametersFrom (opportunity: OpportunityModel) -> OpportunityModel {
        var opportunityToReturn: OpportunityModel!
        let elementsOfOpportunity = OpportunityModel.DescriptionInDataBase
        var querySQL = createQueryFromString(elementsOfOpportunity)
        
        querySQL += "WHERE idOpportunity = \(opportunity.idOpportunity)"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            if result.next() {
                var opportunityArgs = [InitializationData]()
                let idOpportunity = Int(result.intForColumn("idOpportunity"))
                for i in 1..<elementsOfOpportunity.count {
                    let attribute = elementsOfOpportunity[i]
                    let opportunityArg: InitializationData = (attribute, result.stringForColumn(attribute))
                    opportunityArgs.append(opportunityArg)
                }
                opportunityToReturn = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
            }
        }
        return opportunityToReturn
    }
    
    func getAccountOfOpportunity(opportunity: OpportunityModel) -> AccountsModel {
        var account: AccountsModel!
        let elementsOfAccount = AccountsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfAccount, tableName: AccountsModel.TableName)
        querySQL += " WHERE idAccount IN (SELECT idAccount FROM Account_Opportunites WHERE idOpportunite = \(opportunity.idOpportunity))"
        println(querySQL)
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next() {
                var accountArgs = [InitializationData]()
                let idAccount = Int(results.intForColumn("idAccount"))
                for i in 1..<elementsOfAccount.count {
                    let attribute = elementsOfAccount[i]
                    let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    accountArgs.append(accountArg)
                }
                account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
            }
        }
        return account
    }
    
    func createQueryFromString(elementsOfTables: [String]) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTables {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM Opportunity "
        return querySQL
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