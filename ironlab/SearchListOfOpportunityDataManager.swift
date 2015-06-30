//
//  SearchListOfOpportunityDataManager.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class SearchListOfOpportunityDataManager: NSObject {
    
    typealias TypeToReturnForSearchList = [(sectionName: String, opportunity: [OpportunityModel])]
    
    private let dateFormatter = NSDateFormatter()
    private let TypeOfDateInSQLiteDataBase = "yyyy-MM-dd HH:mm"
    
    override init() {
        super.init()
    }
    
    func getOpportunityFromIdOpportunity(#idOpportunity: Int) -> OpportunityModel {
        var opportunity: OpportunityModel = OpportunityModel()
        let elementsOfOpportunity = OpportunityModel.DescriptionInDataBase
        var querySQL = createQueryFromString(elementsOfOpportunity)
        querySQL += "WHERE idOpportunity = \(idOpportunity)"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() == true {
                var opportunityArgs = [InitializationData]()
                for i in 1..<elementsOfOpportunity.count {
                    let attribute = elementsOfOpportunity[i]
                    let opportunityArg: InitializationData = (attribute, results!.stringForColumn(attribute))
                    opportunityArgs.append(opportunityArg)
                }
                opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
            }
        }
        
        return opportunity
    }
    
    func getSearchListOpportunitiesFromAlphabeticOrder(#order: String) -> TypeToReturnForSearchList {
        var dataToReturn: TypeToReturnForSearchList = TypeToReturnForSearchList()
        let elementsOfOpportunity = ["idOpportunity", "nameOpportunity", "statusOpportunity", "ownerOpportunity", "expectedCloseDateOpportunity"]
        var querySQL = "SELECT substr(nameOpportunity,1,1) as firstLetter FROM Opportunity GROUP BY substr(nameOpportunity,1,1) ORDER BY substr(nameOpportunity,1,1) \(order)"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() == true {
                var lettre: String = result.stringForColumn("firstLetter")
                querySQL = createQueryFromString(elementsOfOpportunity)
                querySQL += "WHERE nameOpportunity LIKE '\(lettre)%' ORDER BY nameOpportunity \(order)"
                var opportunityArgs = [InitializationData]()
                var listOpportunities: [OpportunityModel] = []
                let resultsTemp: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let resultTemp = resultsTemp {
                    while resultTemp.next() == true {
                        let idOpportunity: Int = Int(resultTemp.intForColumn("idOpportunity"))
                        let nameOpportunity: String = resultTemp.stringForColumn("nameOpportunity")
                        let statusOpportunity: String = resultTemp.stringForColumn("statusOpportunity")
                        let ownerOpportunity: String = resultTemp.stringForColumn("ownerOpportunity")
                        for i in 1..<elementsOfOpportunity.count {
                            let attribute = elementsOfOpportunity[i]
                            let opportunityArg: InitializationData = (attribute, resultTemp.stringForColumn(attribute))
                            opportunityArgs.append(opportunityArg)
                        }
                        let opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
                        listOpportunities.append(opportunity)
                    }
                }
                dataToReturn += [(lettre, listOpportunities)]
            }
        }
        return dataToReturn
    }
    
    func getSearchListOpportunitiesFromCloseDate() -> TypeToReturnForSearchList {
        var dataToReturn: TypeToReturnForSearchList = TypeToReturnForSearchList()
        let elementsOfOpportunity = ["idOpportunity", "nameOpportunity", "statusOpportunity", "ownerOpportunity", "expectedCloseDateOpportunity"]
        var querySQL = "SELECT expectedCloseDateOpportunity FROM \(OpportunityModel.TableName) "
        querySQL += "GROUP BY expectedCloseDateOpportunity "
        querySQL += "ORDER BY datetime(expectedCloseDateOpportunity) ASC"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() == true {
                var opportunityArgs = [InitializationData]()
                var listOpportunities: [OpportunityModel] = []
                let expectedCloseDateOpportunity: String = result.stringForColumn("expectedCloseDateOpportunity")
                querySQL = createQueryFromString(elementsOfOpportunity)
                querySQL += "WHERE date(expectedCloseDateOpportunity) = date('\(expectedCloseDateOpportunity)')"
                let resultsTemp: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let resultTemp = resultsTemp {
                    while resultTemp.next() == true {
                        let idOpportunity: Int = Int(resultTemp.intForColumn("idOpportunity"))
                        let nameOpportunity: String = resultTemp.stringForColumn("nameOpportunity")
                        let statusOpportunity: String = resultTemp.stringForColumn("statusOpportunity")
                        let ownerOpportunity: String = resultTemp.stringForColumn("ownerOpportunity")
                        for i in 1..<elementsOfOpportunity.count {
                            let attribute = elementsOfOpportunity[i]
                            let opportunityArg: InitializationData = (attribute, resultTemp.stringForColumn(attribute))
                            opportunityArgs.append(opportunityArg)
                        }
                        let opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
                        listOpportunities.append(opportunity)
                    }
                }
                dataToReturn += [(expectedCloseDateOpportunity, listOpportunities)]
            }
        }
        return dataToReturn
    }
    
    func getSearchListOpportunitiesFromStatus() -> TypeToReturnForSearchList {
        var dataToReturn: TypeToReturnForSearchList = TypeToReturnForSearchList()
        let elementsOfOpportunity = ["idOpportunity", "nameOpportunity", "statusOpportunity", "ownerOpportunity", "expectedCloseDateOpportunity"]
        var querySQL = "SELECT statusOpportunity FROM \(OpportunityModel.TableName) "
        querySQL += "GROUP BY statusOpportunity"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() == true {
                var opportunityArgs = [InitializationData]()
                var listOpportunities: [OpportunityModel] = []
                let statusOpportunity: String = result.stringForColumn("statusOpportunity")
                querySQL = createQueryFromString(elementsOfOpportunity)
                querySQL += "WHERE statusOpportunity LIKE '\(statusOpportunity)'"
                let resultsTemp: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let resultTemp = resultsTemp {
                    while resultTemp.next() == true {
                        let idOpportunity: Int = Int(resultTemp.intForColumn("idOpportunity"))
                        let nameOpportunity: String = resultTemp.stringForColumn("nameOpportunity")
                        let statusOpportunity: String = resultTemp.stringForColumn("statusOpportunity")
                        let ownerOpportunity: String = resultTemp.stringForColumn("ownerOpportunity")
                        for i in 1..<elementsOfOpportunity.count {
                            let attribute = elementsOfOpportunity[i]
                            let opportunityArg: InitializationData = (attribute, resultTemp.stringForColumn(attribute))
                            opportunityArgs.append(opportunityArg)
                        }
                        let opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
                        listOpportunities.append(opportunity)
                    }
                }
                dataToReturn += [(statusOpportunity, listOpportunities)]
            }
        }
        return dataToReturn
    }
    
    func getNextOpportunities() -> [OpportunityModel] {
        
        var listOpportunities: [OpportunityModel] = []
        
        let elementsOfOpportunity = OpportunityModel.DescriptionInDataBase
        var querySQL = createSelectQuery(elementsOfOpportunity, tableName: OpportunityModel.TableName)
        querySQL += "WHERE date(expectedCloseDateOpportunity) >= date('now') "
        querySQL += "ORDER BY datetime(expectedCloseDateOpportunity) ASC"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let result = results {
            while result.next() == true {
                var opportunityArgs = [InitializationData]()
                let idOpportunity: Int = Int(result.intForColumn("idOpportunity"))
                for i in 1..<elementsOfOpportunity.count {
                    let attribute = elementsOfOpportunity[i]
                    let opportunityArg: InitializationData = (attribute, result.stringForColumn(attribute))
                    opportunityArgs.append(opportunityArg)
                }
                let opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: opportunityArgs)
                listOpportunities.append(opportunity)
            }
        }
        return listOpportunities
    }

    func createQueryFromString(elementsOfTables: [String]) -> String {
                var querySQL = "SELECT "
                for element in elementsOfTables {
                querySQL += element + ","
                }
                querySQL = dropLast(querySQL)
                querySQL += " FROM \(OpportunityModel.TableName) "
                return querySQL
    }
    func createSelectQuery(elementsOfTable: [String], tableName: String) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTable {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM  " + tableName + " "
        return querySQL
    }
}