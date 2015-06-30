//
//  HomePageDataManager.swift
//  IronLab
//
//  Created by ghassane rihani on 24/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class HomePageDataManager: NSObject {
    
    typealias TypeDataToReturn = (account: AccountsModel, meeting: MeetingsModel)
    
    private let dateFormatter = NSDateFormatter()
    private let TypeOfDateInSQLiteDataBase = "yyyy-MM-dd HH:mm"

    var meetings = [MeetingsModel]()
    var accounts = [AccountsModel]()
    override init() {
        super.init()
    }
    
    func getMeetingsOfDay(date: NSDate) -> [TypeDataToReturn] {
        var dataToReturn = [TypeDataToReturn]()
        
        
        let elementsOfAccounts = ["Account.idAccount", "nameAccount"]
        let elementsOfMeetings = ["idMeeting", "subjectMeeting", "dateBeginMeeting", "dateEndMeeting"]
        let meetingsWithAccounts = elementsOfAccounts + elementsOfMeetings
        
        var querySQL = createQueryFromString(meetingsWithAccounts)
        
        dateFormatter.dateFormat = TypeOfDateInSQLiteDataBase
        let dateFromSQL = dateFormatter.stringFromDate(date)
        
        querySQL += " WHERE date(dateBeginMeeting) = date('\(dateFromSQL)') AND Account.idAccount = Meetings.idAccount"
        
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accountArgs = [InitializationData]()
                var meetingArgs = [InitializationData]()
                let idAccount = Int(results.intForColumn("idAccount"))
                let idMeeting = Int(results.intForColumn("idMeeting"))
                for i in 1..<elementsOfAccounts.count {
                    let attribute = elementsOfAccounts[i]
                    let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    accountArgs.append(accountArg)
                }
                let account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
                for i in 1..<elementsOfMeetings.count {
                    let attribute = elementsOfMeetings[i]
                    let meetingArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    meetingArgs.append(meetingArg)
                }
                let meeting = MeetingsModel(idMeeting: idMeeting, elementsOfMeeting: meetingArgs)
                let elementOfDataToReturn: TypeDataToReturn = (account, meeting)
                dataToReturn.append(elementOfDataToReturn)
            }
        }
        
        return dataToReturn
    }
    
    func getNextMeetings() -> [TypeDataToReturn] {
        var dataToReturn = [TypeDataToReturn]()
        
        
        let elementsOfAccounts = ["Account.idAccount", "nameAccount"]
        let elementsOfMeetings = ["idMeeting", "subjectMeeting", "dateBeginMeeting", "dateEndMeeting"]
        let meetingsWithAccounts = elementsOfAccounts + elementsOfMeetings
        
        var querySQL = createQueryFromString(meetingsWithAccounts)
        
        dateFormatter.dateFormat = TypeOfDateInSQLiteDataBase
        
        querySQL += " WHERE date(dateBeginMeeting) >= date('now') AND Account.idAccount = Meetings.idAccount ORDER BY dateTime(dateBeginMeeting)"
        
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accountArgs = [InitializationData]()
                var meetingArgs = [InitializationData]()
                let idAccount = Int(results.intForColumn("idAccount"))
                let idMeeting = Int(results.intForColumn("idMeeting"))
                for i in 1..<elementsOfAccounts.count {
                    let attribute = elementsOfAccounts[i]
                    let accountArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    accountArgs.append(accountArg)
                }
                let account = AccountsModel(idAccount: idAccount, elementsOfAccount: accountArgs)
                for i in 1..<elementsOfMeetings.count {
                    let attribute = elementsOfMeetings[i]
                    let meetingArg: InitializationData = (attribute, results.stringForColumn(attribute))
                    meetingArgs.append(meetingArg)
                }
                let meeting = MeetingsModel(idMeeting: idMeeting, elementsOfMeeting: meetingArgs)
                let elementOfDataToReturn: TypeDataToReturn = (account, meeting)
                dataToReturn.append(elementOfDataToReturn)
            }
        }
        return dataToReturn
    }
    
    typealias DataOfMissingDocs = (customer: String, description: String, revenue: Int)
    
    func getMissingDocs() -> [DataOfMissingDocs] {
        var missingDocs: [DataOfMissingDocs] = []
        missingDocs.append(("CRÉDIT AGRICOLE CARDS & PAYMENTS", "Projet Industrialisation du Back-Of", 493))
         missingDocs.append(("GIE CREDIT AGRICOLE TECHNOLOGIES", "NICE 2015", 376))
         missingDocs.append(("AXA", "RUN - MW - offre packagée",370))
         missingDocs.append(("GIE CREDIT AGRICOLE TECHNOLOGIES", "Nice V2 - Conception étape 2",331))
         missingDocs.append(("GIE CREDIT AGRICOLE TECHNOLOGIES", "Nice V2 - Pilotage étape 2 -",317))
         missingDocs.append(("BNP PARIBAS SA", "Projet RADAR",299))
         missingDocs.append(("CRÉDIT AGRICOLE CARDS & PAYMENTS", "Assistance à la Direction de projet BOE",272))
         missingDocs.append(("LA BANQUE POSTALE - DSI", "Euclid Lot 1",266))
         missingDocs.append(("BPCE", "Définition architecture cible MT du",245))
         missingDocs.append(("GIE CREDIT AGRICOLE TECHNOLOGIES", "Assistance ASR",218))
         missingDocs.append(("CRÉDIT AGRICOLE CARDS & PAYMENTS", "PFA avenant n° 2+3+4'suite' du 3147",195))
         missingDocs.append(("CRÉDIT AGRICOLE CARDS & PAYMENTS", "Projet SAE - Avenant 10",155))
        missingDocs.append(("GIE CREDIT AGRICOLE TECHNOLOGIES", "OFF-Nice V2 - Dvlpt étape 2 - ESP",139))
        missingDocs.append(("CRÉDIT AGRICOLE CARDS & PAYMENTS", "MDW packagée - Evolutions - CACP",139))
        return missingDocs
    }
    typealias DataOfAccountsToFollow = (idAccount: Int,nameAccount: String, nbrOfOpportunities: Int, sumOfOpportunities: Double, lastMeeting: String, nextMeeting: String)
    
    func getAccountsToFollow() -> [DataOfAccountsToFollow]
    {
        var accountsToFollow: [DataOfAccountsToFollow] = []
        accountsToFollow.append((8, "Societe Generale", 5, 2360, "2015-03-18 09:30","2015-06-25 10:30" ))
        accountsToFollow.append((1, "Axa", 3, 1036, "2015-04-25 15:30","2015-08-05 11:00" ))
        accountsToFollow.append((7, "Natixis", 3, 590, "2014-11-20 16:45","2015-09-12 14:00" ))
        accountsToFollow.append((18, "La poste", 2, 150, "2015-04-05 10:30","2015-07-20 16:00" ))
        accountsToFollow.append((5, "Europe Assistance", 1, 18, "2015-02-08 15:30","2015-10-18 17:00" ))
        
        
        return accountsToFollow
    }
    func createQueryFromString(elementsOfTables: [String]) -> String {
        var querySQL = "SELECT "
        for element in elementsOfTables {
            querySQL += element + ","
        }
        querySQL = dropLast(querySQL)
        querySQL += " FROM Account, Meetings "
        return querySQL
    }
}
