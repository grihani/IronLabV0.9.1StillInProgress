//
//  DetailsOfAccountAPI.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfAccountAPI: NSObject {
    class var sharedInstance: DetailsOfAccountAPI {
        struct Singleton {
            static let instance = DetailsOfAccountAPI()
        }
        return Singleton.instance
    }
    
    var detailsOfAccountDataManager: DetailsOfAccountDataManager
    
    override init() {
        detailsOfAccountDataManager = DetailsOfAccountDataManager()
    }
    
    func getFirstAccountToShow() -> AccountsModel {
        return detailsOfAccountDataManager.getFirstAccountToShow()
    }
    
    func getWholeAccountFromAccount(account: AccountsModel) -> AccountsModel {
        return detailsOfAccountDataManager.getWholeAccountFromAccount(account)
    }
    
    func getContactsOfAccount(account: AccountsModel) -> [ContactsModel] {
        return detailsOfAccountDataManager.getContactsOfAccount(account)
    }
    
    func getAllContacts() -> [ContactsModel] {
        return detailsOfAccountDataManager.getAllContacts()
    }
    
    func getTopOpportunitiesOfAccount(account: AccountsModel, limit: Int!) -> [OpportunityModel] {
        return detailsOfAccountDataManager.getTopOpportunitiesOfAccount(account, limit: limit)
    }
    
    func getMeetingsOfAccount(account: AccountsModel!) -> [MeetingsModel] {
        return detailsOfAccountDataManager.getMeetingsOfAccount(account)
    }
    
    typealias MeetingsAndContacts = [DetailsOfAccountDataManager.MeetingsAndContacts]
    
    func getMeetingsOfDay(date: NSDate) -> MeetingsAndContacts {
        return detailsOfAccountDataManager.getMeetingsOfDay(date)
    }
    
    typealias MeetingsAndAccounts = [DetailsOfAccountDataManager.MeetingsAndAccounts]
    
    func getMeetingsAndAccountsOfDay(date: NSDate) -> MeetingsAndAccounts {
        return detailsOfAccountDataManager.getMeetingsAndAccountsOfDay(date)
    }
    
    func getDraftOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        return detailsOfAccountDataManager.getDraftOpportunitiesOfAccount(account)
    }
    
    func getOpenOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        return detailsOfAccountDataManager.getOpenOpportunitiesOfAccount(account)
    }
    
    func getWonOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        return detailsOfAccountDataManager.getWonOpportunitiesOfAccount(account)
    }
    
    func getLostOpportunitiesOfAccount(account: AccountsModel)  -> [OpportunityModel] {
        return detailsOfAccountDataManager.getLostOpportunitiesOfAccount(account)
    }
    
    func getOpportunitiesOfAccount(account: AccountsModel) -> [OpportunityModel] {
        return detailsOfAccountDataManager.getOpportunitiesOfAccount(account)
    }
    
    func getContactsOfMeeting(meeting:MeetingsModel) -> [ContactsModel] {
        return detailsOfAccountDataManager.contactsOfMeeting(meeting)
    }

    func findParentAccount (account: AccountsModel) -> String {
        return detailsOfAccountDataManager.findParentAccount(account)
    }
    
    func saveMeeting(meeting: MeetingsModel) -> Int {
        return detailsOfAccountDataManager.saveMeeting(meeting)
    }
}
