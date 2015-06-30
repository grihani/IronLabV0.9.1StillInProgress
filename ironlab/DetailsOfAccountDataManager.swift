//
//  DetailsOfAccountDataManager.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfAccountDataManager: NSObject {
    let dateFormatter = NSDateFormatter()
    
    func contactsOfMeeting(meeting: MeetingsModel) -> [ContactsModel]{
        var contactsOfMeeting: [ContactsModel] = []
        let elementsOfContact = ContactsModel.DescriptionInDataBase
        
        var querySQL = createQuery(elementsOfContact, tableName: ContactsModel.TableName)
        querySQL += " WHERE idContact IN (Select idContact FROM Meetings_Contacts WHERE idMeeting = \(meeting.idMeeting))"
//        println("querySQL : \(querySQL)")
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfContact {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                let contact = ContactsModel(idContact: dataToReturn[0].value.toInt()!, elementsOfContact: dataToReturn)
                contactsOfMeeting.append(contact)
            }
        }
        return contactsOfMeeting
    }
    
    func getFirstAccountToShow() -> AccountsModel! {
        var accountData: [InitializationData] = []
        let elementsOfAccount = AccountsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfAccount, tableName: AccountsModel.TableName)
        querySQL += " WHERE idAccount IN (SELECT idAccount FROM \(MeetingsModel.TableName) WHERE date(dateBeginMeeting) >= date('now') LIMIT 1)"
        let results : FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next() {
                var i: Int32 = 0
                for element in elementsOfAccount {
                    accountData.append((element, results.stringForColumnIndex(i)))
                    i++
                }
            }
        }
        if accountData.count != 0 {
            return AccountsModel(idAccount: accountData[0].value.toInt()!, elementsOfAccount: accountData)
        } else {
            var querySQL = createQuery(elementsOfAccount, tableName: "Account")
            querySQL += " LIMIT 1"
            let results : FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
            if let results = results {
                if results.next() {
                    var i: Int32 = 0
                    for element in elementsOfAccount {
                        accountData.append((element, results.stringForColumnIndex(i)))
                        i++
                    }
                }
            }
            if accountData.count != 0 {
                return AccountsModel(idAccount: accountData[0].value.toInt()!, elementsOfAccount: accountData)
            }
        }
        return nil
    }
    
    func getWholeAccountFromAccount(account: AccountsModel) -> AccountsModel! {
        var accountData: [InitializationData] = []
        let elementsOfAccount = AccountsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfAccount, tableName: "Account")
        querySQL += " WHERE idAccount = \(account.idAccount)"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            if results.next(){
                var i: Int32 = 0
                for element in elementsOfAccount {
                    accountData.append((element, results.stringForColumnIndex(i)))
                    i++
                }
            }
        }
        if accountData.count != 0 {
            return AccountsModel(idAccount: accountData[0].value.toInt()!, elementsOfAccount: accountData)
        }
        return nil
    }
    
    func getContactsOfAccount(account: AccountsModel) -> [ContactsModel] {
        var contactsOfAccount: [ContactsModel] = []
        
        let elementsOfContact = ContactsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfContact, tableName: ContactsModel.TableName)
        querySQL += " WHERE idContact in ("
        querySQL += createQuery(["idContact"], tableName: "Account_Contacts")
        querySQL += " WHERE idAccount = \(account.idAccount)) ORDER BY firstNameContact"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfContact: [InitializationData] = []
                for element in elementsOfContact {
                    dataOfContact.append((element, results.stringForColumn(element)))
                }
                let contact = ContactsModel(idContact: dataOfContact[0].value.toInt()!, elementsOfContact: dataOfContact)
                contactsOfAccount.append(contact)
            }
        }
        return contactsOfAccount
    }
    
    func getAllContacts() -> [ContactsModel] {
        var allContacts: [ContactsModel] = []
        
        let elementsOfContact = ContactsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfContact, tableName: ContactsModel.TableName)
        querySQL += " ORDER BY firstNameContact"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfContact: [InitializationData] = []
                for element in elementsOfContact {
                    dataOfContact.append((element, results.stringForColumn(element)))
                }
                let contact = ContactsModel(idContact: dataOfContact[0].value.toInt()!, elementsOfContact: dataOfContact)
                allContacts.append(contact)
            }
        }
        return allContacts
    }
    
    func getTopOpportunitiesOfAccount(account: AccountsModel, limit: Int!) -> [OpportunityModel] {
        var topOpportunitiesOfAccount: [OpportunityModel] = []
        
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) ORDER BY potentialAmountOpportunity DESC "
        if let limit = limit {
            querySQL += " LIMIT \(limit)"
        }
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                topOpportunitiesOfAccount.append(opportunity)
            }
        }
        return topOpportunitiesOfAccount
    }
    
    func getMeetingsOfAccount(account: AccountsModel!) -> [MeetingsModel] {
        var meetingsOfAccount: [MeetingsModel] = []
        var meetingData: [InitializationData] = []
        let elementsOfMeeting = MeetingsModel.DescriptionInDataBase
        if let account = account {
            var querySQL = createQuery(elementsOfMeeting, tableName: MeetingsModel.TableName)
            querySQL += " WHERE idAccount = \(account.idAccount) ORDER BY DATETIME(dateBeginMeeting)"
            let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
            if let results = results {
                while results.next() {
                    var dataOfMeetings: [InitializationData] = []
                    for element in elementsOfMeeting {
                        dataOfMeetings.append((element, results.stringForColumn(element)))
                    }
                    let meeting = MeetingsModel(idMeeting: dataOfMeetings[0].value.toInt()!, elementsOfMeeting: dataOfMeetings)
                    meetingsOfAccount.append(meeting)
                }
            }
        }
        return meetingsOfAccount
    }
    
    
    typealias MeetingsAndContacts = (meeting: MeetingsModel, contacts: [ContactsModel])
    
    func getMeetingsOfDay(date: NSDate) -> [MeetingsAndContacts] {
        var meetingsOfDay: [MeetingsAndContacts] = []
        
        var meetingData: [InitializationData] = []
        let elementsOfMeeting = MeetingsModel.DescriptionInDataBase
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringFromDate = dateFormatter.stringFromDate(date)
        var querySQL = createQuery(elementsOfMeeting, tableName: "Meetings")
        querySQL += " WHERE date(dateBeginMeeting) = date('\(stringFromDate)')"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfMeeting {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                let meeting = MeetingsModel(idMeeting: dataToReturn[0].value.toInt()!, elementsOfMeeting: dataToReturn)
                
                let contacts = contactsOfMeeting(meeting)
                
                meetingsOfDay.append((meeting,contacts))
            }
        }
        return meetingsOfDay
    }
    
    typealias MeetingsAndAccounts = (account: AccountsModel, meeting: MeetingsModel)
    func getMeetingsAndAccountsOfDay(date: NSDate) -> [MeetingsAndAccounts] {
        var meetingsOfDay: [MeetingsAndAccounts] = []
        
        var meetingData: [InitializationData] = []
        let elementsOfMeeting = MeetingsModel.DescriptionInDataBase
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringFromDate = dateFormatter.stringFromDate(date)
        var querySQL = createQuery(elementsOfMeeting, tableName: MeetingsModel.TableName)
        querySQL += " WHERE date(dateBeginMeeting) = date('\(stringFromDate)')"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataToReturn: [InitializationData] = []
                for element in elementsOfMeeting {
                    dataToReturn.append((element, results.stringForColumn(element)))
                }
                let meeting = MeetingsModel(idMeeting: dataToReturn[0].value.toInt()!, elementsOfMeeting: dataToReturn)
                
                let account = getAccountOfMeeting(meeting)
                
                meetingsOfDay.append((account, meeting))
            }
        }
        return meetingsOfDay
    }
    
    func getAccountOfMeeting(meeting: MeetingsModel) -> AccountsModel {
        var accountOfMeeting: AccountsModel!
        
        let elementsOfAccount = AccountsModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfAccount, tableName: AccountsModel.TableName)
        querySQL += " WHERE idAccount = \(meeting.idAccount)"
        let results = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
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
    
    func getOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        var opportunitiesOfAccount: [OpportunityModel] = []
        
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) ORDER BY date(expectedCloseDateOpportunity), date(closeDateOpportunity)"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                opportunitiesOfAccount.append(opportunity)
            }
        }
        return opportunitiesOfAccount
    }
    
    func getWonOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        var opportunitiesOfAccount: [OpportunityModel] = []
        println("won")
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) AND (statusOpportunity like '%won%' or statusOpportunity like '%win%') ORDER BY date(expectedCloseDateOpportunity), date(closeDateOpportunity)"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                opportunitiesOfAccount.append(opportunity)
            }
        }
        return opportunitiesOfAccount
    }
    
    func getLostOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        var opportunitiesOfAccount: [OpportunityModel] = []
        println("lost")
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) AND (statusOpportunity like '%lost%' or statusOpportunity like '%loss%') ORDER BY date(expectedCloseDateOpportunity), date(closeDateOpportunity)"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                opportunitiesOfAccount.append(opportunity)
            }
        }
        return opportunitiesOfAccount
    }
    
    func getDraftOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        var opportunitiesOfAccount: [OpportunityModel] = []
        println("draft")
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) AND (statusOpportunity like '%Draft%' OR statusOpportunity LIKE '%Identification%') ORDER BY date(expectedCloseDateOpportunity), date(closeDateOpportunity)"
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                opportunitiesOfAccount.append(opportunity)
            }
        }
        return opportunitiesOfAccount
    }
    
    func getOpenOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        var opportunitiesOfAccount: [OpportunityModel] = []
        println("open")
        let elementsOfOpportunities = OpportunityModel.DescriptionInDataBase
        var querySQL = createQuery(elementsOfOpportunities, tableName: OpportunityModel.TableName)
        querySQL += " WHERE idOpportunity IN (SELECT idOpportunite FROM Account_Opportunites WHERE idAccount = \(account.idAccount)) AND (statusOpportunity NOT LIKE '%Draft%' OR statusOpportunity NOT LIKE '%Identification%') AND closeDateOpportunity = '' ORDER BY date(expectedCloseDateOpportunity), date(closeDateOpportunity)"
        println(querySQL)
        let results: FMResultSet! = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var dataOfOpportunity: [InitializationData] = []
                for element in elementsOfOpportunities {
                    dataOfOpportunity.append((element, results.stringForColumn(element)))
                }
                let opportunity = OpportunityModel(idOpportunity: dataOfOpportunity[0].value.toInt()!, elementsOfOpportunity: dataOfOpportunity)
                opportunitiesOfAccount.append(opportunity)
            }
        }
        return opportunitiesOfAccount
    }
    
    func findParentAccount ( account: AccountsModel) -> String {
        var nameOfParent: String = " "
        if account.idAccount1 == 0 {
            return "None"
        } else {
            
            var querySQLHeader = "SELECT nameAccount FROM Account WHERE idAccount = \(account.idAccount1)"
            
            let results: FMResultSet? = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
            if (results!.next()) {
                let nameParentAccount = results!.stringForColumn("nameAccount")
                return nameParentAccount
            }
            return ""
        }
    }
    
    func saveMeeting(meeting: MeetingsModel) -> Int {
        var idInsert = 0
        let querySQL = createQuerySaveMeeting(meeting)
        if DataBase.executeUpdate(querySQL, withArgumentsInArray: meeting.getValuesInArrayForInsert()) {
            idInsert = Int(DataBase.lastInsertRowId())
        }
        return idInsert
    }
    
    func createQuerySaveMeeting(meeting: MeetingsModel) -> String {
        var querySQL = "INSERT INTO  " + MeetingsModel.TableName + " ("
        for arg in MeetingsModel.DescriptionForInsert {
            querySQL += arg + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += ") VALUES ("
        for arg in MeetingsModel.DescriptionForInsert {
            querySQL += "?,"
        }
        querySQL = dropLast(querySQL)
        return querySQL + ")"
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
    
    func createInsertQuery(args: [String], tableName: String) -> String {
        
        return ""
    }
}
