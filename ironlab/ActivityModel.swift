//
//  ActivityModel.swift
//  IronLab
//
//  Created by Formation iOS on 03/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import Foundation

class ActivityModel: NSObject {
    
    var idActivity: Int!
    var subjectActivity: String!
    var dueDateActivity: String!
    var priorityActivity: String!
    var assignedToActivity: String!
    var statusActivity: String!
    var typeActivity: String!
    var commentsActivity: String!
    var attachmentActivity: String!
    
    override init() {
        super.init()
    }
    
    init(idActivity: Int, elementsOfActivity: [InitializationData]!) {
        super.init()
        self.idActivity = idActivity
        for element in elementsOfActivity {
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
        }
    }
    
    override var description: String {
        return "idActivity: \(idActivity), " +
            "subjectActivity: \(subjectActivity), " +
            "dueDateActivity: \(dueDateActivity), " +
            "priorityActivity: \(priorityActivity), " +
            "assignedToActivity: \(assignedToActivity), " +
            "statusActivity: \(statusActivity), " +
            "typeActivity: \(typeActivity), " +
            "commentsActivity: \(commentsActivity), " +
            "attachmentActivity: \(attachmentActivity)"
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
        "attachmentActivity"
    ]
    static let DescriptionForInsert = [
        "subjectActivity",
        "dueDateActivity",
        "priorityActivity",
        "assignedToActivity",
        "statusActivity",
        "typeActivity",
        "commentsActivity",
        "attachmentActivity"
    ]
    
    static let TableName = "Activity"
    static let TableConnectedOpportunity = "Opportunity_Activities"
}