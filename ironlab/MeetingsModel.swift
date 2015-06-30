//
//  MeetingsModel.swift
//  IronLab
//
//  Created by ghassane rihani on 24/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class MeetingsModel: NSObject {
    
    var idMeeting: Int!
    var subjectMeeting: String! = ""
    var dateBeginMeeting: String! = ""
    var adressMeeting: String! = ""
    var dateEndMeeting: String! = ""
    var allDayMeeting: Int! = 0
    var priorityMeeting: String! = ""
    var descriptionMeeting: String! = ""
    var regardingMeeting: String! = ""
    var reportMeeting: String! = ""
    var idAccount: Int! = 0
    var idContact: Int! = 0
    var agendaMeeting: String! = ""
    var notesMeeting: String! = ""
    
    init(idMeeting: Int, elementsOfMeeting: [InitializationData]!) {
        super.init()
        self.idMeeting = idMeeting
        if elementsOfMeeting != nil {
            for element in elementsOfMeeting {
                if element.name == "subjectMeeting" {
                    subjectMeeting = element.value
                }
                else if element.name == "dateBeginMeeting" {
                    dateBeginMeeting = element.value
                }
                else if element.name == "adressMeeting" {
                    adressMeeting = element.value
                }
                else if element.name == "dateEndMeeting" {
                    dateEndMeeting = element.value
                }
                else if element.name == "allDayMeeting" {
                    allDayMeeting = element.value.toInt()!
                }
                else if element.name == "priorityMeeting" {
                    priorityMeeting = element.value
                }
                else if element.name == "descriptionMeeting" {
                    descriptionMeeting = element.value
                }
                else if element.name == "regardingMeeting" {
                    regardingMeeting = element.value
                }
                else if element.name == "reportMeeting" {
                    reportMeeting = element.value
                }
                else if element.name == "idAccount" {
                   idAccount = element.value.toInt()!
                }
                else if element.name == "idContact" {
                   idContact = element.value.toInt()!
                }
                else if element.name == "agendaMeeting" {
                    agendaMeeting = element.value
                }
                else if element.name == "notesMeeting" {
                    notesMeeting = element.value
                }
            }
        }
    }
    
    override var description: String {
        return "idMeeting: \(idMeeting), " +
            "subjectMeeting: \(subjectMeeting), " +
            "dateBeginMeeting: \(dateBeginMeeting)" +
            "adressMeeting: \(adressMeeting), " +
            "dateEndMeeting: \(dateEndMeeting), " +
            "allDayMeeting: \(allDayMeeting), " +
            "priorityMeeting: \(priorityMeeting), " +
            "descriptionMeeting: \(descriptionMeeting), " +
            "regardingMeeting: \(regardingMeeting), " +
        "reportMeeting: \(reportMeeting), "
    }
    
    static let DescriptionInDataBase = [
        "idMeeting",
        "subjectMeeting",
        "dateBeginMeeting",
        "adressMeeting",
        "dateEndMeeting",
        "allDayMeeting",
        "priorityMeeting",
        "descriptionMeeting",
        "regardingMeeting",
        "reportMeeting",
        "idAccount",
        "idContact",
        "agendaMeeting",
        "notesMeeting"
    ]
    static let DescriptionForInsert = [
        "subjectMeeting",
        "dateBeginMeeting",
        "adressMeeting",
        "dateEndMeeting",
        "allDayMeeting",
        "priorityMeeting",
        "descriptionMeeting",
        "regardingMeeting",
        "reportMeeting",
        "idAccount",
        "idContact",
        "agendaMeeting",
        "notesMeeting"
    ]
    
    func getValuesInArrayForInsert() -> [String] {
        return [
            subjectMeeting,
            dateBeginMeeting,
            adressMeeting,
            dateEndMeeting,
            String(allDayMeeting),
            priorityMeeting,
            descriptionMeeting,
            regardingMeeting,
            reportMeeting,
            String(idAccount),
            String(idContact),
            agendaMeeting,
            notesMeeting
        ]
    }
    
    static let UpdateAgendaAndNotes = [
        "agendaMeeting",
        "notesMeeting"
    ]
    
    static let TableName = "Meetings"
    static let IdMeeting = "idMeeting"
    static let SubjectMeeting = "subjectMeeting"
    static let DateBeginMeeting = "dateBeginMeeting"
    static let AdressMeeting = "adressMeeting"
    static let DateEndMeeting = "dateEndMeeting"
    static let AllDayMeeting = "allDayMeeting"
    static let PriorityMeeting = "priorityMeeting"
    static let DescriptionMeeting = "descriptionMeeting"
    static let RegardingMeeting = "regardingMeeting"
    static let ReportMeeting = "reportMeeting"
    static let AgendaMeeting = "agendaMeeting"
}
