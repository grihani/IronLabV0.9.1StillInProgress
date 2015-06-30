//
//  OpportunityActivitiesDataManager.swift
//  IronLab
//
//  Created by Formation iOS on 03/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class OpportunityActivitiesDataManager: NSObject {
    typealias TypeToReturnForSearchList = [(sectionName: String, activity: [ActivityModel])]
    private let dateFormatter = NSDateFormatter()
    private let TypeOfDateInSQLiteDataBase = "yyyy-MM-dd HH:mm"
    
    override init() {
        super.init()
    }
    
    func getActivitiesFromIdOpportunity(#idOpportunity: Int) -> TypeToReturnForSearchList {
        var dataToReturn: TypeToReturnForSearchList = TypeToReturnForSearchList()
        var elementsOfActivity = ActivityModel.DescriptionInDataBase
        var querySQL = createQueryFromString(elementsOfActivity, table: "Activity")
        querySQL += "WHERE idActivity = (SELECT idActivity FROM Opportunity_Activities WHERE idOpportunity = \(idOpportunity)) "
        querySQL += "ORDER BY datetime(dueDateActivity) ASC, statusActivity DESC"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                let dueDateActivity: String = results.stringForColumn("dueDateActivity")
                var activities: [ActivityModel] = []
                querySQL = createQueryFromString(elementsOfActivity, table: "Activity")
                querySQL += "WHERE date(dueDateActivity) = date('\(dueDateActivity)') AND idActivity = (SELECT idActivity FROM Opportunity_Activities WHERE idOpportunity = \(idOpportunity))"
                let resultsActivity: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let resultActivity = resultsActivity {
                    while resultActivity.next() {
                        var idActivity = Int(resultActivity.intForColumn("idActivity"))
                        var activityArgs = [InitializationData]()
                        for i in 1..<elementsOfActivity.count {
                            let attribute = elementsOfActivity[i]
                            let activityArg: InitializationData = (attribute, resultActivity.stringForColumn(attribute))
                            activityArgs.append(activityArg)
                        }
                        let activity = ActivityModel(idActivity: idActivity, elementsOfActivity: activityArgs)
                        activities.append(activity)
                    }
                }
                dataToReturn += [(dueDateActivity, activities)]
            }
        }
        return dataToReturn
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