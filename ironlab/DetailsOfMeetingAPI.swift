//
//  DetailsOfMeetingAPI.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfMeetingAPI: NSObject {
    class var sharedInstance: DetailsOfMeetingAPI {
        struct Singleton {
            static let instance = DetailsOfMeetingAPI()
        }
        return Singleton.instance
    }
    
    var detailsOfMeetingDataManager: DetailsOfMeetingDataManager
    
    override init() {
        detailsOfMeetingDataManager = DetailsOfMeetingDataManager()
    }
    
    func getNextMeeting() -> MeetingsModel? {
        return detailsOfMeetingDataManager.getNextMeeting()
    }
    
    func getMeetingDetails(meeting: MeetingsModel) -> MeetingsModel {
        return detailsOfMeetingDataManager.getMeetingDetails(meeting)
    }
    
    func getAccountOfMeeting(meeting: MeetingsModel) -> AccountsModel? {
        return detailsOfMeetingDataManager.getAccountOfMeeting(meeting)
    }
    
    func updateAgendaAndNotesMeeting(values: [String], meeting: MeetingsModel) {
        detailsOfMeetingDataManager.updateAgendaAndNotesMeeting(values, meeting: meeting)
    }
    
    func meetingsOfAccount(account: AccountsModel) -> [MeetingsModel] {
        return DetailsOfAccountAPI.sharedInstance.getMeetingsOfAccount(account)
    }
    
    func getOpportunitiesOfAccount(account: AccountsModel) -> [OpportunityModel] {
        return DetailsOfAccountAPI.sharedInstance.getOpportunitiesOfAccount(account)
    }
    
    func getContactsOfAccount(account: AccountsModel) -> [ContactsModel] {
        return DetailsOfAccountAPI.sharedInstance.getContactsOfAccount(account)
    }
    
    func getAgendaOfMeeting(meeting: MeetingsModel) -> [AgendaMeetingModel] {
        return detailsOfMeetingDataManager.getAgendaOfMeeting(meeting)
    }
    
    func insertAgendaMeeting(agendaItem: String, meeting:MeetingsModel) {
        detailsOfMeetingDataManager.insertAgendaMeeting(agendaItem, meeting: meeting)
    }
    
    func updateCoveredAgenda(agendaItem: AgendaMeetingModel) {
        detailsOfMeetingDataManager.updateCoveredAgenda(agendaItem)
    }
    
    func deleteAgendaItem(agendaItem: AgendaMeetingModel) {
        detailsOfMeetingDataManager.deleteAgendaItem(agendaItem)
    }
    
    func updateAgendaItem(title: String, agendaItem: AgendaMeetingModel) {
        detailsOfMeetingDataManager.updateAgendaItem(title, agendaItem: agendaItem)
    }
    
    func getContactsOfMeeting(meeting: MeetingsModel) -> [ContactsModel] {
        return DetailsOfAccountAPI.sharedInstance.getContactsOfMeeting(meeting)
    }
    
    func getPrincipalContactOfMeeting(meeting: MeetingsModel) -> ContactsModel? {
        return detailsOfMeetingDataManager.getPrincipalContactOfMeeting(meeting)
    }
    
    typealias TasksForCR = DetailsOfMeetingDataManager.TasksForCR
    func getFlaggedActivities(meeting: MeetingsModel) ->  [TasksForCR] {
        return detailsOfMeetingDataManager.getFlaggedActivities(meeting)
    }
    
    func getFlaggedActivitiesForAccount(account: AccountsModel) -> [TasksForCR] {
        return detailsOfMeetingDataManager.getFlaggedActivitiesForAccount(account)
    }
    
    func findParentAccount (account: AccountsModel) -> String {
        return DetailsOfAccountAPI.sharedInstance.findParentAccount(account)
    }
}
