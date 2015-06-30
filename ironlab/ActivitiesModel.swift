//
//  ActivitiesModel.swift
//  IronLab
//
//  Created by cscuser on 15/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ActivitiesModel: NSObject {
    
    var idActivity: Int!
    var subjectActivity: String!
    var dueDateActivity: String!
    var priorityActivity: String!
    var assignedToActivity: String!
    var statusActivity: String!
    var typeActivity: String!
    var commentsActivity: String!
    var attachmentActivity: String!
    var assignedByIdToActivity: String!
    var idMeeting: Int!
    var idContact: Int!
    var idAccount: Int!
    var creationDateActivity: String!
    var flagActivity: Int!
    
    
    init(idActivity: Int, elementsOfActivities: [InitializationData]!) {
        super.init()
        self.idActivity = idActivity
        for element in elementsOfActivities {
            if element.name == "subjectActivity" {
                subjectActivity = element.value
            }
            else if element.name == "dueDateActivity" {
                dueDateActivity = element.value
            }
            else if element.name == "priorityActivity" {
                priorityActivity = element.value
            }
            else if element.name == "assignedToActivity" {
                assignedToActivity = element.value
            }
            else if element.name == "statusActivity" {
                statusActivity = element.value
            }
            else if element.name == "typeActivity" {
                typeActivity = element.value
            }
            else if element.name == "commentsActivity" {
                commentsActivity = element.value
            }
            else if element.name == "attachmentActivity" {
                attachmentActivity = element.value
            }
            else if element.name == "idMeeting" {
                idMeeting = element.value.toInt()!
            }
            else if element.name == "idContact" {
                idContact = element.value.toInt()!
            }
            else if element.name == "idAccount" {
                idAccount = element.value.toInt()!
            }
            else if element.name == "creationDateActivity" {
                creationDateActivity = element.value
            }
            else if element.name == "flagActivity" {
                flagActivity = element.value.toInt()!
            }
        }
    }
    
    override var description: String {
        return "idActivity: \(idActivity), " +
            "subjectActivity: \(subjectActivity), " +
            "dueDateActivity: \(dueDateActivity)" +
            "priorityActivity: \(priorityActivity), " +
            "assignedToActivity: \(assignedToActivity), " +
            "statusActivity: \(statusActivity), " +
            "typeActivity: \(typeActivity), " +
            "commentsActivity: \(commentsActivity), " +
            "attachmentActivity: \(attachmentActivity), " +
            "idMeeting: \(idMeeting), " +
            "idContact: \(idContact), " +
        "idAccount: \(idAccount), " +
        "creationDateActivity: \(creationDateActivity), " +
        "flagActivity: \(flagActivity), "
    }
    
    static let DescriptionInDataBase = [
        "idActivity",
        "subjectActivity",
        "dueDateActivity",
        "priorityActivity",
        "assignedToActivity",
        "statusActivity",
        "typeActivity",
        "commentsActivity",
        "attachmentActivity",
        "idMeeting",
        "idContact",
        "idAccount",
        "creationDateActivity",
        "flagActivity",
    ]
    static let DescriptionForInsert = [
        "subjectActivity",
        "dueDateActivity",
        "priorityActivity",
        "assignedToActivity",
        "statusActivity",
        "typeActivity",
        "commentsActivity",
        "attachmentActivity",
        "idMeeting",
        "idContact",
        "idAccount",
        "creationDateActivity",
        "flagActivity",
    ]
    
    static let TableName = "Activity"
    static let SubjectActivity = "subjectActivity"
    static let dueDateActivity = "dueDateActivities"
    static let priorityActivity = "priorityActivity"
    static let assingedToActivity = "assingedToActivity"
    static let statusActivity = "statusActivity"
    static let typeActivity = "typeActivity"
    static let commentsActivity = "commentsActivity"
    static let attachementActivity = "attachementActivity"
    static let idMeeting = "idMeeting"
    static let idContact = "idContact"
    static let idAccount = "idAccount"
    static let creationDateActivity = "creationDateActivity"
    static let flagActivity = "flagActivity"
}
