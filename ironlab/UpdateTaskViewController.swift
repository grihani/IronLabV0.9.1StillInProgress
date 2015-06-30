//
//  UpdateTaskViewController.swift
//  IronLab
//
//  Created by cscuser on 22/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class UpdateTaskViewController: UIViewController {

    var task: ActivitiesModel!
    
    
    @IBOutlet var assignedToUpdateTask: UITextField!
    @IBOutlet var priorityUpdateTask: UISegmentedControl!
    @IBOutlet var dueDateUpdateTask: UIDatePicker!
    @IBOutlet var subjectUpdateTask: UITextField!
    var textVide: String = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textVide = subjectUpdateTask.text
        subjectUpdateTask.text = task.subjectActivity
        assignedToUpdateTask.text = task.assignedToActivity
        var dueDateFormat2 = NSDateFormatter()
        dueDateFormat2.dateFormat = "yyyy-MM-dd HH:mm"
        var date = dueDateFormat2.dateFromString(task.dueDateActivity)
        dueDateUpdateTask.date = date!
        
        if (task.priorityActivity == "Low")
        {
            priorityUpdateTask.selectedSegmentIndex = 0
        }
        else if (task.priorityActivity == "Medium")
        {
            priorityUpdateTask.selectedSegmentIndex = 1
        }
        else
        {
            priorityUpdateTask.selectedSegmentIndex = 2
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    Fonction mettant à jour les données d'une task
    */
    @IBAction func UpdateNewInformationsTask(sender: UIBarButtonItem) {
        
        if ( textVide != subjectUpdateTask.text)
        {
            if( textVide == assignedToUpdateTask.text)
            {
                assignedToUpdateTask.text = " Moi"
            }
            var priorityText = priorityUpdateTask.titleForSegmentAtIndex(priorityUpdateTask.selectedSegmentIndex)!
            var dueDateFormat = NSDateFormatter()
            dueDateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var dueDateInString = dueDateFormat.stringFromDate(dueDateUpdateTask.date)
            var querySQLHeader = "UPDATE Activity SET subjectActivity = '\(subjectUpdateTask.text)', assignedToActivity = '\(assignedToUpdateTask.text)', dueDateActivity = '\(dueDateInString)', priorityActivity = '\(priorityText)' WHERE idActivity = '\(task.idActivity)'"
            DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
            
            
            if let presentingViewController = self.presentingViewController as? TaskViewController {
                println("")
                presentingViewController.refreshTheTabOfTask()
            }
            
            if let presentingViewController = self.presentingViewController as? ActivitiesOfAccountViewController {
                presentingViewController.withoutFlag.refreshTheTabOfTask()
            }
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            subjectUpdateTask.attributedPlaceholder = NSAttributedString(string:"Subject missing",
                attributes:[NSForegroundColorAttributeName: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7)])
        }
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
