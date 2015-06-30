//
//  AgendaMeetingModel.swift
//  ironlab
//
//  Created by CSC on 20/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class AgendaMeetingModel: NSObject {
   
    var idAgenda: Int!
    var titleAgenda: String!
    var coveredAgenda: Int!
    var idMeeting: Int!
    var position: Int!
    
    init(idAgenda: Int, elementsOfAgenda: [InitializationData]!) {
        super.init()
        self.idAgenda = idAgenda
        if elementsOfAgenda != nil {
            for element in elementsOfAgenda {
                if element.name == "titleAgenda" {
                    titleAgenda = element.value
                }
                else if element.name == "coveredAgenda" {
                    coveredAgenda = element.value.toInt()!
                }
                else if element.name == "idMeeting" {
                    idMeeting = element.value.toInt()!
                }
                else if element.name == "position" {
                    position = element.value.toInt()!
                }
            }
        }
    }
    
    override var description: String {
        return "idAgenda: \(idAgenda), " +
            "titleAgenda: \(titleAgenda), " +
            "coveredAgenda: \(coveredAgenda)" +
            "idMeeting: \(idMeeting), " +
            "position: \(position), "
    }
    
    static let DescriptionInDataBase = [
        "idAgenda",
        "titleAgenda",
        "coveredAgenda",
        "idMeeting",
        "position"
    ]
    static let DescriptionForInsert = [
        "titleAgenda",
        "coveredAgenda",
        "idMeeting",
        "position"
    ]
    
    static let TableName = "AgendaMeeting"
    static let IdAgenda = "idAgenda"
    static let TitleAgenda = "titleAgenda"
    static let CoveredAgenda = "coveredAgenda"
    static let IdMeeting = "idMeeting"
    static let Position = "position"
}
