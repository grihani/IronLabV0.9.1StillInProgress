//
//  SearchForAccountsDataManager.swift
//  IronLab
//
//  Created by ghassane rihani on 25/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForAccountsDataManager: NSObject {
    typealias SearchPerMeetings = (headerDates: String, accounts: [AccountsModel], meetings: [MeetingsModel])
    typealias SearchPerName = (headerIndex: String, accounts: [AccountsModel])
    
    
    var allAccounts = [AccountsModel]()
    private let dateFormatter = NSDateFormatter()
    
    func getAccountsPerMeetings() -> [SearchPerMeetings] {
        var accountsPerMeetings: [SearchPerMeetings] = []
        var querySQL = "SELECT date(dateBeginMeeting) as dateBeginMeeting FROM \(MeetingsModel.TableName) WHERE date(dateBeginMeeting) >= date('now') GROUP BY date(dateBeginMeeting) "
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accounts = [AccountsModel]()
                var meetings = [MeetingsModel]()
                let headerAsSQLiteDate = results.stringForColumn("dateBeginMeeting")
                
                let elementsOfAccounts = ["Account.idAccount", "nameAccount", "industryAccount"]
                let elementsOfMeetings = ["idMeeting", "subjectMeeting", "dateBeginMeeting", "dateEndMeeting"]
                var querySearchForAccounts = createQueryForAccountMeeting(elementsOfAccounts + elementsOfMeetings)
                querySearchForAccounts += " WHERE date(dateBeginMeeting) = date('\(headerAsSQLiteDate)') AND Account.idAccount = Meetings.idAccount ORDER BY date(dateBeginMeeting)"
                
                let results: FMResultSet? = DataBase.executeQuery(querySearchForAccounts, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var accountArgs = [InitializationData]()
                        var meetingArgs = [InitializationData]()
                        let idAccount = Int(results.intForColumn("idAccount"))
                        for i in 1..<elementsOfAccounts.count {
                            let attribute = elementsOfAccounts[i]
                            let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            accountArgs.append(accountArg)
                        }
                        let account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
                        accounts.append(account)
                        let idMeeting = Int(results.intForColumn("idMeeting"))
                        for i in 1..<elementsOfMeetings.count {
                            let attribute = elementsOfMeetings[i]
                            let meetingArg: InitializationData = (attribute, results.stringForColumn(attribute))
                          meetingArgs.append(meetingArg)
                        }
                        let meeting = MeetingsModel(idMeeting: idMeeting, elementsOfMeeting: meetingArgs)
                        meetings.append(meeting)
                    }
                }
                let elementOfDataToReturn: SearchPerMeetings = (translateDates(headerAsSQLiteDate), accounts, meetings)
                accountsPerMeetings.append(elementOfDataToReturn)
            }
        }
        return accountsPerMeetings
    }
    
    func getAllAccounts(#ascendant: Bool) -> [SearchPerName] {
        var accountsPerName: [SearchPerName] = []
        var querySQL = "SELECT substr(nameAccount,1,1) as firstLetter FROM Account GROUP BY substr(nameAccount,1,1) ORDER BY substr(nameAccount,1,1) "
        if !ascendant {
            querySQL += " DESC"
        }
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accounts = [AccountsModel]()
                let header = results.stringForColumn("firstLetter")
                let elementsOfAccounts = ["idAccount", "nameAccount", "favoriteAccount"]
                var querySearchForAccounts = createQueryForAccounts(elementsOfAccounts)
                querySearchForAccounts += " WHERE substr(nameAccount,1,1) = '\(header)' ORDER BY nameAccount "
                if !ascendant {
                    querySearchForAccounts += " DESC"
                }
                let results: FMResultSet? = DataBase.executeQuery(querySearchForAccounts, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var accountArgs = [InitializationData]()
                        let idAccount = Int(results.intForColumn("idAccount"))
                        for i in 1..<elementsOfAccounts.count {
                            let attribute = elementsOfAccounts[i]
                            let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            accountArgs.append(accountArg)
                        }
                        let account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
                        accounts.append(account)
                    }
                }
                let elementOfDataToReturn: SearchPerName = (header, accounts)
                accountsPerName.append(elementOfDataToReturn)
            }
        }
        return accountsPerName
    }
    
    
    
    func searchAccountByNAmeAccount(nameAccount: String) -> [SearchPerName] {
        
        var accountsByName: [SearchPerName] = []
        
        var querySQL = "SELECT substr(nameAccount,1,1) as firstLetter FROM Account WHERE nameAccount LIKE '%\(nameAccount)%' OR shortNameAccount LIKE '%\(nameAccount)%' OR adressAccount LIKE '%\(nameAccount)%' GROUP BY substr(nameAccount,1,1) ORDER BY substr(nameAccount,1,1)"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accounts = [AccountsModel]()
                let header = results.stringForColumn("firstLetter")
                let elementsOfAccounts = ["idAccount", "nameAccount", "favoriteAccount"]
                var querySearchForAccounts = createQueryForAccounts(elementsOfAccounts)
                querySearchForAccounts += " WHERE substr(nameAccount,1,1) = '\(header)' AND (nameAccount LIKE '%\(nameAccount)%' OR shortNameAccount LIKE '%\(nameAccount)%' OR adressAccount LIKE '%\(nameAccount)%') ORDER BY nameAccount"
                let results: FMResultSet? = DataBase.executeQuery(querySearchForAccounts, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var accountArgs = [InitializationData]()
                        let idAccount = Int(results.intForColumn("idAccount"))
                        for i in 1..<elementsOfAccounts.count {
                            let attribute = elementsOfAccounts[i]
                            let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            accountArgs.append(accountArg)
                        }
                        let account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
                        accounts.append(account)
                    }
                }
                let elementOfDataToReturn: SearchPerName = (header, accounts)
                accountsByName.append(elementOfDataToReturn)
            }
        }
        return accountsByName
    }

    
    func translateDates(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .NoStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
    
    func createQueryForAccounts(elementsOfTables: [String]) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTables {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM Account "
        return querySQL
    }
    
    func createQueryForAccountMeeting(elementsOfTables: [String]) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTables {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM \(AccountsModel.TableName), \(MeetingsModel.TableName) "
        return querySQL
    }
}
