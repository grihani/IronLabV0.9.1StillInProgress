//
//  SearchForMeetingsDataManager.swift
//  ironlab
//
//  Created by CSC on 21/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForMeetingsDataManager: NSObject {
    
    typealias MeetingAndAccount = (account: AccountsModel, meeting: MeetingsModel)
    typealias AllMeetings = (date: String, meetingsAndAccounts: [MeetingAndAccount])
    
    
    let dateFormatter = NSDateFormatter()
    
    func getAllMeetings() -> [AllMeetings] {
        var accountsPerMeetings: [AllMeetings] = []
        var querySQL = "SELECT date(dateBeginMeeting) as dateBeginMeeting FROM \(MeetingsModel.TableName) WHERE date(dateBeginMeeting) >= date('now') GROUP BY date(dateBeginMeeting) ORDER BY date(dateBeginMeeting) ASC"
        let results: FMResultSet? = DataBase.executeQuery(querySQL, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var accountsAndMeetings = [MeetingAndAccount]()
                
                let headerAsSQLiteDate = results.stringForColumn("dateBeginMeeting")
                
                let elementsOfAccounts = ["idAccount", "nameAccount"]
                let elementsOfMeetings = ["idMeeting", "subjectMeeting", "dateBeginMeeting", "dateEndMeeting"]
                var querySearchForAccounts = "SELECT Account.idAccount, nameAccount, idMeeting, subjectMeeting, dateBeginMeeting, dateEndMeeting From Account, Meetings WHERE Account.idAccount = Meetings.idAccount AND date(dateBeginMeeting) = date('\(headerAsSQLiteDate)') order by dateTime(dateBeginMeeting)"
                
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
                        let idMeeting = Int(results.intForColumn("idMeeting"))
                        for i in 1..<elementsOfMeetings.count {
                            let attribute = elementsOfMeetings[i]
                            let meetingArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            meetingArgs.append(meetingArg)
                        }
                        let meeting = MeetingsModel(idMeeting: idMeeting, elementsOfMeeting: meetingArgs)
                        let accountAndMeeting: MeetingAndAccount = (account, meeting)
                        accountsAndMeetings.append(accountAndMeeting)
                    }
                }
                let elementOfDataToReturn: AllMeetings = (translateDates(headerAsSQLiteDate), accountsAndMeetings)
                accountsPerMeetings.append(elementOfDataToReturn)
            }
        }
        return accountsPerMeetings
    }
    
    func translateDates(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
