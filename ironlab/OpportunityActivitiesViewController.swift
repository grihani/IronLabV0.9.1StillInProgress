//
//  OpportunityTasksViewController.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class OpportunityActivitiesViewController: UIViewController {
    
    typealias TypeForSection = [(sectionName: String, activity: [ActivityModel])]
    // MARK: - IBOutlet
    @IBOutlet weak var activitiesTableView: UITableView!
    @IBOutlet weak var subjectActivityLabel: UILabel! {
        didSet {
            if activity != nil {
                self.subjectActivityLabel.text = activity.subjectActivity
            }
        }
    }
    @IBOutlet weak var dueDateActivityLabel: UILabel! {
        didSet {
            if activity != nil {
                self.dueDateActivityLabel.text = activity.dueDateActivity
            }
        }
    }
    @IBOutlet weak var priorityActivityLabel: UILabel! {
        didSet {
            if activity != nil {
                self.priorityActivityLabel.text = activity.priorityActivity
            }
        }
    }
    @IBOutlet weak var assignedToActivityLabel: UILabel! {
        didSet {
            if activity != nil {
                self.assignedToActivityLabel.text = activity.assignedToActivity
            }
        }
    }
    @IBOutlet weak var statusActivityLabel: UILabel! {
        didSet {
            if activity != nil {
                self.statusActivityLabel.text = activity.statusActivity
            }
        }
    }
    @IBOutlet weak var commentsActivityTextView: UITextView! {
        didSet {
            if activity != nil {
                self.commentsActivityTextView.text = activity.commentsActivity
            }
            self.commentsActivityTextView.layer.borderWidth = 2
            self.commentsActivityTextView.layer.borderColor = UIColor.grayColor().CGColor
            self.commentsActivityTextView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var attachementActivityLabel: UITextView! {
        didSet {
            if activity != nil {
                self.attachementActivityLabel.text = activity.attachmentActivity
            }
            self.attachementActivityLabel.layer.borderWidth = 2
            self.attachementActivityLabel.layer.borderColor = UIColor.grayColor().CGColor
            self.attachementActivityLabel.layer.cornerRadius = 8
        }
    }
    // MARK: - Variables
    var activity: ActivityModel! {
        didSet {
            if let activity = activity {
                self.subjectActivityLabel?.text = activity.subjectActivity
                self.dueDateActivityLabel?.text = activity.dueDateActivity
                self.priorityActivityLabel?.text = activity.priorityActivity
                self.assignedToActivityLabel?.text = activity.assignedToActivity
                self.statusActivityLabel?.text = activity.statusActivity
                self.commentsActivityTextView?.text = activity.commentsActivity
                self.commentsActivityTextView?.layer.borderWidth = 2
                self.commentsActivityTextView?.layer.borderColor = UIColor.grayColor().CGColor
                self.commentsActivityTextView?.layer.cornerRadius = 8
                self.attachementActivityLabel?.text = activity.attachmentActivity
                self.attachementActivityLabel?.layer.borderWidth = 2
                self.attachementActivityLabel?.layer.borderColor = UIColor.grayColor().CGColor
                self.attachementActivityLabel?.layer.cornerRadius = 8
            }
        }
    }
    var activitySelected: ActivityModel!
    var idOpportunity: Int!
    var listActivitiesToDisplay: TypeForSection = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if idOpportunity != nil {
            listActivitiesToDisplay = OpportunityActivitiesAPI().getActivitiesFromIdOpportunity(idOpportunity: idOpportunity)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            activitiesTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            tableView(self.activitiesTableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension OpportunityActivitiesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if listActivitiesToDisplay.count != 0 {
            if listActivitiesToDisplay[section].activity.count != 0 {
                activitySelected = listActivitiesToDisplay[section].activity[row]
                self.subjectActivityLabel.text = activitySelected.subjectActivity
                self.dueDateActivityLabel.text = activitySelected.dueDateActivity
                self.priorityActivityLabel.text = activitySelected.priorityActivity
                self.assignedToActivityLabel.text = activitySelected.assignedToActivity
                self.statusActivityLabel.text = activitySelected.statusActivity
                self.commentsActivityTextView.text = activitySelected.commentsActivity
                self.attachementActivityLabel.text = activitySelected.attachmentActivity
            }
        }
    }
}

extension OpportunityActivitiesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = tableView.dequeueReusableCellWithIdentifier("cell opportunity activities", forIndexPath: indexPath) as! OpportunityActivitiesTableViewCell
        cell.subjectTasksLabel.text = listActivitiesToDisplay[section].activity[row].subjectActivity
        cell.typeTasksLabel.text = listActivitiesToDisplay[section].activity[row].typeActivity
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listActivitiesToDisplay[section].activity.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listActivitiesToDisplay[section].sectionName
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listActivitiesToDisplay.count
    }
}