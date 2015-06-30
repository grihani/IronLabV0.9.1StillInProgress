//
//  AddTask.swift
//  IronLab
//
//  Created by cscuser on 22/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class AddTask: UIViewController {

    @IBOutlet var assignedToNewTask: UITextField!
    @IBOutlet var subjectOfNewTask: UITextField!
    @IBOutlet var dueDateOfNewTask: UIDatePicker!
    @IBOutlet var priorityOfNewTask: UISegmentedControl!
    var textVide: String = " "
    
    var meeting: MeetingsModel!
    var windowOfTasks: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        subjectOfNewTask.becomeFirstResponder()
        textVide = subjectOfNewTask.text
        dueDateOfNewTask.minimumDate =  NSDate()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNewTask(sender: UIBarButtonItem) {
        
        if (subjectOfNewTask.text != textVide)
        {
            var flag = 0
            if windowOfTasks == 3 {
                flag = 1
            }
            if(assignedToNewTask.text == textVide)
            {
                assignedToNewTask.text = " Moi "
            }
            var priorityText = priorityOfNewTask.titleForSegmentAtIndex(priorityOfNewTask.selectedSegmentIndex)!
            var dueDateFormat = NSDateFormatter()
            dueDateFormat.dateFormat = "yyyy-MM-dd HH:mm"
            var dueDateInString = dueDateFormat.stringFromDate(dueDateOfNewTask.date)
            var querySQLHeader = "INSERT INTO Activity (subjectActivity, dueDateActivity, statusActivity, priorityActivity, creationDateActivity, assignedToActivity, typeActivity, commentsActivity , attachmentActivity, assignedByIdToActivity, flagActivity, idMeeting, IdAccount, idContact ) VALUES ('\(subjectOfNewTask.text)', '\(dueDateInString)', 'To do', '\(priorityText)', datetime(),'\(assignedToNewTask.text)',' ', ' ', ' ', 0 ,\(flag), \(meeting.idMeeting) , \(meeting.idAccount), \(meeting.idContact))"
            DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
            
            
            if let presentingViewController = self.presentingViewController as? TaskViewController {
                presentingViewController.refreshTheTabOfTask()
            }
            if let presentingViewController = self.presentingViewController as? ActivitiesOfAccountViewController {
                presentingViewController.withoutFlag.refreshTheTabOfTask()
            }
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            subjectOfNewTask.attributedPlaceholder = NSAttributedString(string:"Subject missing",
                attributes:[NSForegroundColorAttributeName: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7)])
        }
        
    }
    
    /* ('\(dueDateInString)'
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension NSDate {
    var localTime: String {
        return descriptionWithLocale(NSLocale.currentLocale())!
    }
}
