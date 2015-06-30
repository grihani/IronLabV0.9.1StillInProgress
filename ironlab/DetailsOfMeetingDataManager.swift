//
//  DetailsOfMeetingDataManager.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfMeetingDataManager: NSObject {
    func getNextMeeting() -> MeetingsModel? {
        var nextMeeting: MeetingsModel!
        let elementsOfMeeting = MeetingsModel.DescriptionInDataBase
        println("recherche prochain meeting")
        
        var querySQL = createQuery(args: elementsOfMeeting, tableName: MeetingsModel.TableName)
        querySQL += " WHERE date(dateBeginMeeting) > date('now') LIMIT 1"
//        println(querySQL)
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfMeeting {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                nextMeeting = MeetingsModel(idMeeting: dataToReturn[0].value.toInt()!, elementsOfMeeting: dataToReturn)
            }
        }
        return nextMeeting
    }
    
    func getMeetingDetails(meeting: MeetingsModel) -> MeetingsModel {
        var meetingDetails: MeetingsModel!
        println("remplissage de meeting")
        let elementsOfMeeting = MeetingsModel.DescriptionInDataBase
        
        var querySQL = createQuery(args: elementsOfMeeting, tableName: MeetingsModel.TableName)
        querySQL += " WHERE idMeeting = \(meeting.idMeeting)"
//        println(querySQL)
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfMeeting {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                meetingDetails = MeetingsModel(idMeeting: dataToReturn[0].value.toInt()!, elementsOfMeeting: dataToReturn)
            }
        }
        return meetingDetails
    }
    
    func getAgendaOfMeeting(meeting: MeetingsModel) -> [AgendaMeetingModel] {
        var agendaOfMeeting: [AgendaMeetingModel] = []
        let elementsOfAgenda = AgendaMeetingModel.DescriptionInDataBase
        
        var querySQL = createQuery(args: elementsOfAgenda, tableName: AgendaMeetingModel.TableName)
        querySQL += " WHERE idMeeting = \(meeting.idMeeting) ORDER BY position"
        
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfAgenda {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                let agenda = AgendaMeetingModel(idAgenda: dataToReturn[0].value.toInt()!, elementsOfAgenda: dataToReturn)
                agendaOfMeeting.append(agenda)
            }
        }
        
        return agendaOfMeeting
    }
    
    func getAccountOfMeeting(meeting: MeetingsModel) -> AccountsModel? {
        var accountOfMeeting: AccountsModel!
        let elementsOfAccount = AccountsModel.DescriptionInDataBase
        var querySQL = createQuery(args: elementsOfAccount, tableName: AccountsModel.TableName)
        querySQL += " WHERE idAccount = \(meeting.idAccount)"
//        println("query: \(querySQL)")
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfAccount {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                accountOfMeeting = AccountsModel(idAccount: dataToReturn[0].value.toInt()!, elementsOfAccount: dataToReturn)
            }
        }
        return accountOfMeeting
    }
    
    func updateAgendaAndNotesMeeting(values: [String], meeting: MeetingsModel) {
        var arguments = MeetingsModel.UpdateAgendaAndNotes
        arguments.append(MeetingsModel.IdMeeting)
        var querySQL = createQueryUpdate(args: arguments, tableName: MeetingsModel.TableName)
        var valuesForUpdateQuery = values
        valuesForUpdateQuery.append(String(meeting.idMeeting))
        if DataBase.executeUpdate(querySQL, withArgumentsInArray: valuesForUpdateQuery) {
            println("the update has been done")
        }
    }
    
    func insertAgendaMeeting(agendaItem: String, meeting:MeetingsModel) {
        var querySQL = "SELECT MAX(position) as priority FROM " + AgendaMeetingModel.TableName + " WHERE idMeeting = \(meeting.idMeeting)"
//        println(querySQL)
        let results = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        var priority = 0
        if let results = results {
            if results.next() {
                priority = Int(results.intForColumn("priority"))
            }
        }
        
        var queryInsert = createQueryInsert(args: AgendaMeetingModel.DescriptionForInsert, tableName: AgendaMeetingModel.TableName)
        
        let arrayInsert = [agendaItem, 0, meeting.idMeeting ,priority + 1]
        if DataBase.executeUpdate(queryInsert, withArgumentsInArray: arrayInsert as [AnyObject]) {
            println("insert has been done")
        }
    }
    
    func updateCoveredAgenda(agendaItem: AgendaMeetingModel) {
        var newValueForCovered = 0
        if agendaItem.coveredAgenda == 0 {
            newValueForCovered = 1
        }
        let arguments = [AgendaMeetingModel.CoveredAgenda, AgendaMeetingModel.IdAgenda]
        let valuesForUpdate = [newValueForCovered, agendaItem.idAgenda]
        var querySQL = createQueryUpdate(args: arguments, tableName: AgendaMeetingModel.TableName)
        if DataBase.executeUpdate(querySQL, withArgumentsInArray: valuesForUpdate) {
            println("update done")
        }
    }
    
    func deleteAgendaItem(agendaItem: AgendaMeetingModel) {
        var querySQL = "DELETE FROM \(AgendaMeetingModel.TableName) WHERE idAgenda = \(agendaItem.idAgenda)"
        if DataBase.executeUpdate(querySQL, withArgumentsInArray: nil) {
            println("row deleted")
        }
    }
    
    func updateAgendaItem(title: String, agendaItem: AgendaMeetingModel) {
        var querySQL = "UPDATE \(AgendaMeetingModel.TableName) SET \(AgendaMeetingModel.TitleAgenda) = ? WHERE \(AgendaMeetingModel.IdAgenda) = ? "
        let arrayForUpdate = [title, agendaItem.idAgenda]
        if DataBase.executeUpdate(querySQL, withArgumentsInArray: arrayForUpdate as [AnyObject]) {
            println("update was done")
        }
    }
    
    typealias TasksForCR = (date: String, tasks: [ActivitiesModel])
    
    func getFlaggedActivities(meeting: MeetingsModel) ->  [TasksForCR] {
        
        var flaggedActivities: [TasksForCR] = []
        let elementsOfActivities = ActivitiesModel.DescriptionInDataBase
        
        var queryDates = "SELECT date(dueDateActivity) as dueDateActivity FROM \(ActivitiesModel.TableName) WHERE flagActivity <> 0 AND idMeeting = \(meeting.idMeeting)"
        println(queryDates)
        let results = DataBase.executeQuery(queryDates, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                let dueDateActivity = results.stringForColumn("dueDateActivity")
                var activities: [ActivitiesModel] = []
                var querySQL = createQuery(args: elementsOfActivities, tableName: ActivitiesModel.TableName)
                querySQL += " WHERE idMeeting = \(meeting.idMeeting) AND date(dueDateActivity) = date('\(dueDateActivity)')"
                
                let results = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var dataToReturn: [InitializationData] = []
                        for element in elementsOfActivities {
                            dataToReturn.append((element, results.stringForColumn(element)))
                        }
                        let activity = ActivitiesModel(idActivity: dataToReturn[0].value.toInt()!, elementsOfActivities: dataToReturn)
                        activities.append(activity)
                    }
                }
                flaggedActivities.append((dueDateActivity, activities))
//                println(querySQL)

            }
        }
        
        return flaggedActivities
    }
    
    func getFlaggedActivitiesForAccount(account: AccountsModel) ->  [TasksForCR] {
        
        var flaggedActivities: [TasksForCR] = []
        let elementsOfActivities = ActivitiesModel.DescriptionInDataBase
        
        var queryDates = "SELECT date(dueDateActivity) as dueDateActivity FROM \(ActivitiesModel.TableName) WHERE flagActivity <> 0 AND idAccount = \(account.idAccount)"
        println(queryDates)
        let results = DataBase.executeQuery(queryDates, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                let dueDateActivity = results.stringForColumn("dueDateActivity")
                var activities: [ActivitiesModel] = []
                var querySQL = createQuery(args: elementsOfActivities, tableName: ActivitiesModel.TableName)
                querySQL += " WHERE idAccount = \(account.idAccount) AND date(dueDateActivity) = date('\(dueDateActivity)')"
                
                let results = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var dataToReturn: [InitializationData] = []
                        for element in elementsOfActivities {
                            dataToReturn.append((element, results.stringForColumn(element)))
                        }
                        let activity = ActivitiesModel(idActivity: dataToReturn[0].value.toInt()!, elementsOfActivities: dataToReturn)
                        activities.append(activity)
                    }
                }
                flaggedActivities.append((dueDateActivity, activities))
                //                println(querySQL)
                
            }
        }
        
        return flaggedActivities
    }
    
    func getPrincipalContactOfMeeting(meeting: MeetingsModel) -> ContactsModel? {
        var contactOfMeeting: ContactsModel!
        let elementsOfContact = ContactsModel.DescriptionInDataBase
        
        var querySQL = createQuery(args: elementsOfContact, tableName: ContactsModel.TableName)
        querySQL += " WHERE idContact = \(meeting.idContact)"
        println(querySQL)
        //        println("querySQL : \(querySQL)")
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfContact {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                let contact = ContactsModel(idContact: dataToReturn[0].value.toInt()!, elementsOfContact: dataToReturn)
                contactOfMeeting = contact
            }
        }
        return contactOfMeeting
    }
    
    func createQuery(#args: [String], tableName: String) -> String {
        var querySQL = "SELECT "
        for arg in args {
            querySQL += arg + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM " + tableName + " "
        return querySQL
    }
    
    func createQueryInsert(#args: [String], tableName: String) -> String {
        var querySQL = "INSERT INTO " + tableName + " ("
        for arg in args {
            querySQL += arg + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += ") VALUES ("
        for arg in args {
            querySQL += "? ,"
        }
        querySQL = dropLast(querySQL)
        querySQL += ")"
        return querySQL
    }
    
    func createQueryUpdate(#args: [String], tableName: String) -> String {
        var querySQL = "UPDATE " + tableName + " SET "
        for i in 0..<args.count - 1 {
            querySQL += args[i] + "= ? ,"
        }
        querySQL = dropLast(querySQL)
        querySQL += " WHERE " + args.last! + " = ? "
        return querySQL
    }
}
