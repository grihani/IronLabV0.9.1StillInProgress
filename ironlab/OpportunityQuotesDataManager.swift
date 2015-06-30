//
//  OpportunityQuotesDataManager.swift
//  IronLab
//
//  Created by Formation iOS on 04/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class OpportunityQuotesDataManager: NSObject {
    typealias TypeToReturnForSearchList = [(sectionName: String, contrat: [ContratModel])]
    private let dateFormatter = NSDateFormatter()
    private let TypeOfDateInSQLiteDataBase = "yyyy-MM-dd HH:mm"
    
    override init() {
        super.init()
    }
    
    func getContratsFromIdOpportunity(#idOpportunity: Int) -> [ContratModel] {
        var contrats: [ContratModel] = []
        var elementsOfContrats = ContratModel.DescriptionInDataBase
        var querySQL = createQueryFromString(elementsOfContrats, table: "Contrats")
        querySQL += "WHERE idContrat = (SELECT idContrat FROM Opportunites_Contrats WHERE idOpportunity = \(idOpportunity))"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var idContrat = Int(results.intForColumn("idContrat"))
                var contratArgs = [InitializationData]()
                for i in 1..<elementsOfContrats.count {
                    let attribute = elementsOfContrats[i]
                    let contratArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    contratArgs.append(contratArg)
                }
                let contrat = ContratModel(idContrat: idContrat, elementsOfContrat: contratArgs)
                contrats.append(contrat)
            }
        }
        return contrats
    }
    
    func createQueryFromString(elementsOfTables: [String], table: String) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTables {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM \(table) "
        return querySQL
    }
}