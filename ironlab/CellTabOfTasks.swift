//
//  cellTabOfTasks.swift
//  IronLab
//
//  Created by cscuser on 17/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class CellTabOfTasks: UITableViewCell {
   
    @IBOutlet var subject: UILabel!
    @IBOutlet var dueDate: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var priority: UILabel!
    @IBOutlet var assingTo: UILabel!
    
    var colorLabels: UIColor = UIColor.blackColor() {
        didSet {
            subject?.textColor = colorLabels
            dueDate?.textColor = colorLabels
            status?.textColor = colorLabels
            priority?.textColor = colorLabels
            assingTo?.textColor = colorLabels
        }
    }
    
   
    
    
}
