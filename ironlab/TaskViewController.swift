//
//  taskViewController.swift
//  IronLab
//
//  Created by cscuser on 15/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController,  UITableViewDataSource , UITableViewDelegate{
    
    let textCellIdentifier = "TextCell"
    var windowOfTasks = 0                         // Variable permettant de connaitre dans quel tableau on se situe (Action Plan / Open / Overdue/ Flag)
    
    @IBOutlet var FlagButtonTask: UIButton!
    @IBOutlet var OverduButtonTask: UIButton!
    @IBOutlet var OpenButtonTask: UIButton!
    @IBOutlet var ALLButtonTask: UIButton!
    @IBOutlet var tasksTableHadToBeDone: UITableView!
    typealias SearchPerDate = (headerIndex: String, accounts: [ActivitiesModel])
    var tabTask: [SearchPerDate] = []
    
    // MARK: - Models
    var meeting: MeetingsModel!
    
    var account: AccountsModel!
    
    /*
    ***************
    Fonctions de base
    ***************
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabTask = searchAllActivitiesByDate()
        FlagButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        ALLButtonTask.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        OpenButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OverduButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "update task" {
            if let destinationVC = segue.destinationViewController.topViewController as? UpdateTaskViewController {
                let indexPath = tasksTableHadToBeDone.indexPathForSelectedRow()
                destinationVC.task = tabTask[indexPath!.section].accounts[indexPath!.row]
                
                var minimumSize = destinationVC.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                minimumSize.width = 500
                minimumSize.height = 400
                destinationVC.preferredContentSize = minimumSize
            }
        }
        if segue.identifier == "create task" {
            if let destinationVC = segue.destinationViewController.topViewController as? AddTask {
                destinationVC.meeting = meeting
                destinationVC.windowOfTasks = windowOfTasks
                var minimumSize = destinationVC.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                minimumSize.width = 500
                minimumSize.height = 400
                destinationVC.preferredContentSize = minimumSize
            }
        }
    }
    
    
    /*
    Chargement du tableau en fonction des conditions voulu
    */
    @IBAction func flagTasksButton() {
        tabTask = searchActivitiesFlagByDate()
        FlagButtonTask.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        ALLButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OpenButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OverduButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        tasksTableHadToBeDone.reloadData()
        windowOfTasks = 3
    }
    @IBAction func overdueTasksButton() {
        
        tabTask = searchActivitiesOverdueByDate()
        FlagButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        ALLButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OpenButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OverduButtonTask.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        tasksTableHadToBeDone.reloadData()
        windowOfTasks = 2
    }
    
    @IBAction func openTasksButton() {
        tabTask = searchActivitiesOpenByDate()
        FlagButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        ALLButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OpenButtonTask.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        OverduButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        tasksTableHadToBeDone.reloadData()
        windowOfTasks = 1
    }
    @IBAction func actionPlanTasksButton() {
        tabTask = searchAllActivitiesByDate()
        FlagButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        ALLButtonTask.backgroundColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        OpenButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        OverduButtonTask.backgroundColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        tasksTableHadToBeDone.reloadData()
        windowOfTasks = 0
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header :UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        
        header.contentView.backgroundColor = UIColor(red: 219.0/255.0, green: 238.0/255.0, blue: 244.0/255.0, alpha: 1)
        return header
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        // This should never happen, but is a fail safe
        return tabTask[section].headerIndex
    }
    
    
    /*
    Fonction permettant la gestion du bouton  swipe ( Flag / Undo / Closed / Cancel )
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let row = indexPath.row
        let section = indexPath.section
        
        /*
        Bouton Flag executant une requete SQL permettant de activer ou le désactiver
        */
        var flagRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Flag", handler:{action, indexpath in
            
            if ( self.tabTask[section].accounts[row].flagActivity == 0)
            {
                var querySQLHeader = "UPDATE Activity SET flagActivity =  1, idMeeting = \(self.meeting.idMeeting) WHERE  idActivity = '\(self.tabTask[section].accounts[row].idActivity)' "
                DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
            }
            else
            {
                var querySQLHeader = "UPDATE Activity SET flagActivity = 0  WHERE idActivity  = '\(self.tabTask[section].accounts[row].idActivity)'  "
                DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
            }
            
            self.refreshTheTabOfTask()
            
            
        });
        flagRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 0.5);
        
        /*
        Bouton Done ou Undo, séparer en deux parties en fonction que le status soit close ou non
        */
        
        var doneRowAction: UITableViewRowAction
        if ( self.tabTask[section].accounts[row].statusActivity != "Closed")
        {
            doneRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Done", handler:{action, indexpath in
                let done = "Closed"
                
                
                var querySQLHeader = "UPDATE Activity SET statusActivity = '\(done)' WHERE  idActivity = '\(self.tabTask[section].accounts[row].idActivity)' "
                DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
                
                
                
                self.refreshTheTabOfTask()
            });
            doneRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 0.9);
            
        }
        else
        {
            let toDo = "To do"
            doneRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "To do", handler:{action, indexpath in
                var querySQLHeader = "UPDATE Activity SET statusActivity = '\(toDo)' WHERE  idActivity = '\(self.tabTask[section].accounts[row].idActivity)' "
                DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
                self.refreshTheTabOfTask()
                
            });
            doneRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 0.9);
            
        }
        
        /*
        Bouton Delete permetant de supprimer une task
        */
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Cancel", handler:{action, indexpath in
            
            var querySQLHeader = "DELETE FROM Activity  WHERE  idActivity = '\(self.tabTask[section].accounts[row].idActivity)' "
            DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
            
            
            
            self.refreshTheTabOfTask()
        });
        
        return [deleteRowAction , doneRowAction, flagRowAction];
    }
    
    
    
    /*
    Fonction perettant de rafraichir le tableau
    */
    func refreshTheTabOfTask()
    {
        if(self.windowOfTasks == 0)
        {
            self.tabTask = self.searchAllActivitiesByDate()
        }
        else if(self.windowOfTasks == 1)
        {
            self.tabTask = self.searchActivitiesOpenByDate()
            
        }
        else if(self.windowOfTasks == 2)
        {
            self.tabTask = self.searchActivitiesOverdueByDate()
            
        }
        else
        {
            self.tabTask = self.searchActivitiesFlagByDate()
            
        }
        self.tasksTableHadToBeDone.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tabTask.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabTask[section].accounts.count
    }
    
    /*
    Fonction de remplissage du tableau
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! CellTabOfTasks
        let row = indexPath.row
        let section = indexPath.section
        var dueDateFormat = NSDateFormatter()
        var dueDateFormat2 = NSDateFormatter()
        dueDateFormat2.dateFormat = "yyyy-MM-dd HH:mm"
        dueDateFormat.dateStyle = NSDateFormatterStyle.LongStyle
        var date = dueDateFormat2.dateFromString(tabTask[section].accounts[row].dueDateActivity)
        let date2 = dueDateFormat.stringFromDate(date!)
        
        let dateNow = NSDate()
        if (dateNow.dateIsGreaterThanDate(date!) && tabTask[section].accounts[row].statusActivity != "Closed")
        {
            cell.colorLabels = UIColor.redColor()
            
        }
        else if(date!.dateIsGreaterThanDate(dateNow) && tabTask[section].accounts[row].statusActivity == "Closed"){
            
            cell.colorLabels = UIColor(red: 0.298, green: 0.80, blue: 0.3922, alpha: 2.0);
        }
        else if(dateNow.dateIsGreaterThanDate(date!) && tabTask[section].accounts[row].statusActivity == "Closed"){
            
            cell.colorLabels = UIColor.grayColor()
        }
        else {
            cell.colorLabels = UIColor.blackColor()
        }
        cell.subject.text = tabTask[section].accounts[row].subjectActivity
        cell.status.text = tabTask[section].accounts[row].statusActivity
        cell.priority.text = tabTask[section].accounts[row].priorityActivity
        cell.assingTo.text = tabTask[section].accounts[row].assignedToActivity
        cell.dueDate.text = date2
        
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, tabTask: [SearchPerDate]) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }
    
    /*
    
    
    Fonction qui permet de rechercher toutes les taches d'un meeting
    
    
    */
    
    
    func searchAllActivitiesByDate() -> [SearchPerDate] {
        
        var activitiesPerDate: [SearchPerDate] = []
        let elementsOfActivities = ["idActivity","creationDateActivity", "dueDateActivity" ,"subjectActivity", "flagActivity" , "statusActivity" , "priorityActivity", "assignedToActivity"]
        
        var querySQLHeader = "SELECT date(creationDateActivity) as creationDateActivity FROM Activity   WHERE idAccount = \(account.idAccount) GROUP BY date(creationDateActivity) ORDER BY date(creationDateActivity)"
        let results = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var activities = [ActivitiesModel]()
                let activityArgs = [InitializationData]()
                var header = results.stringForColumn("creationDateActivity")
                var querySearchForMeeting = " SELECT idActivity ,creationDateActivity, dueDateActivity, subjectActivity , statusActivity , priorityActivity, flagActivity, assignedToActivity FROM Activity WHERE idAccount = \(account.idAccount) AND date(creationDateActivity) = '\(header)'  ORDER BY creationDateActivity "
                header = "Created on: " + results.stringForColumn("creationDateActivity")
                let results: FMResultSet? = DataBase.executeQuery(querySearchForMeeting, withArgumentsInArray: nil)
                
                if let results = results {
                    while results.next() {
                        var activityArgs = [InitializationData]()
                        let idActivity = Int(results.intForColumn("idActivity"))
                        for i in 1..<elementsOfActivities.count {
                            let attribute = elementsOfActivities[i]
                            let activityArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            activityArgs.append(activityArg)
                        }
                        let activity = ActivitiesModel(idActivity: idActivity, elementsOfActivities: activityArgs)
                        activities.append(activity)
                    }
                }
                let elementOfDataToReturn: SearchPerDate = (header, activities)
                activitiesPerDate.append(elementOfDataToReturn)
                
            }
        }
        return activitiesPerDate
    }
    
    
    /*
    
    
    Fonction qui permet de rechercher toutes les taches qui ne sont pas "Closed" correspondant à un meeting
    
    
    */
    
    func searchActivitiesOpenByDate() -> [SearchPerDate] {
        
        var activitiesPerDate: [SearchPerDate] = []
        let closed = "Closed"
        let elementsOfActivities = ["idActivity","creationDateActivity", "dueDateActivity" ,"subjectActivity", "statusActivity" , "priorityActivity", "flagActivity","assignedToActivity"]
        
        var querySQLHeader = "SELECT date(creationDateActivity) as creationDateActivity FROM Activity   WHERE idAccount = \(account.idAccount) AND statusActivity <> '\(closed)' GROUP BY date(creationDateActivity) ORDER BY date(creationDateActivity)"
        let results = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var activities = [ActivitiesModel]()
                let activityArgs = [InitializationData]()
                var header = results.stringForColumn("creationDateActivity")
                var querySearchForMeeting = " SELECT idActivity ,creationDateActivity, dueDateActivity, subjectActivity , statusActivity , priorityActivity , flagActivity, assignedToActivity FROM Activity   WHERE idAccount  = \(account.idAccount) AND date(creationDateActivity) = '\(header)' AND statusActivity <> '\(closed)' ORDER BY creationDateActivity "
                
                header = "Created on: " + results.stringForColumn("creationDateActivity")
                let results: FMResultSet? = DataBase.executeQuery(querySearchForMeeting, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var activityArgs = [InitializationData]()
                        let idActivity = Int(results.intForColumn("idActivity"))
                        for i in 1..<elementsOfActivities.count {
                            let attribute = elementsOfActivities[i]
                            let activityArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            activityArgs.append(activityArg)
                        }
                        let activity = ActivitiesModel(idActivity: idActivity, elementsOfActivities: activityArgs)
                        activities.append(activity)
                    }
                }
                let elementOfDataToReturn: SearchPerDate = (header, activities)
                activitiesPerDate.append(elementOfDataToReturn)
                
            }
        }
        return activitiesPerDate
    }
    
    
    /*
    
    
    Fonction qui permet de rechercher toutes les taches qui correspondent au meeting et qui ont depassé la date prévue
    
    
    */
    
    func searchActivitiesOverdueByDate() -> [SearchPerDate] {
        
        var activitiesPerDate: [SearchPerDate] = []
        let elementsOfActivities = ["idActivity","creationDateActivity" , "dueDateActivity" ,"subjectActivity", "statusActivity" , "priorityActivity" , "flagActivity","assignedToActivity"]
        let closed = "Closed"
        var querySQLHeader = "SELECT date(creationDateActivity) as creationDateActivity FROM Activity   WHERE idAccount  = \(account.idAccount) AND statusActivity <> '\(closed)' AND dueDateActivity <= CURRENT_DATE GROUP BY date(creationDateActivity) ORDER BY date(creationDateActivity)"
        let results = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var activities = [ActivitiesModel]()
                let activityArgs = [InitializationData]()
                var header = results.stringForColumn("creationDateActivity")
                var querySearchForMeeting = " SELECT idActivity ,creationDateActivity, dueDateActivity, subjectActivity , statusActivity , priorityActivity, flagActivity, assignedToActivity FROM Activity    WHERE idAccount = \(account.idAccount) AND statusActivity <> '\(closed)' AND  date(creationDateActivity) = '\(header)' AND dueDateActivity <= CURRENT_DATE ORDER BY creationDateActivity "
                
                header = "Created on: " + results.stringForColumn("creationDateActivity")
                let results: FMResultSet? = DataBase.executeQuery(querySearchForMeeting, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var activityArgs = [InitializationData]()
                        let idActivity = Int(results.intForColumn("idActivity"))
                        for i in 1..<elementsOfActivities.count {
                            let attribute = elementsOfActivities[i]
                            let activityArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            activityArgs.append(activityArg)
                        }
                        let activity = ActivitiesModel(idActivity: idActivity, elementsOfActivities: activityArgs)
                        activities.append(activity)
                    }
                }
                let elementOfDataToReturn: SearchPerDate = (header, activities)
                activitiesPerDate.append(elementOfDataToReturn)
                
            }
        }
        return activitiesPerDate
    }
    
    /*
    
    
    Fonction qui permet de rechercher toutes les taches qui ont été selectionné par l'utilisateur pour son meeting
    
    
    */
    
    func searchActivitiesFlagByDate() -> [SearchPerDate] {
        
        var activitiesPerDate: [SearchPerDate] = []
        let elementsOfActivities = ["idActivity","creationDateActivity", "dueDateActivity" ,"subjectActivity", "statusActivity" , "priorityActivity" ,"flagActivity", "assignedToActivity"]
        
        var querySQLHeader = "SELECT date(creationDateActivity) as creationDateActivity FROM Activity   WHERE idAccount = \(account.idAccount) AND flagActivity != 0  GROUP BY date(creationDateActivity) ORDER BY date(creationDateActivity)"
        let results = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
        if let results = results {
            while results.next() {
                var activities = [ActivitiesModel]()
                let activityArgs = [InitializationData]()
                var header = results.stringForColumn("creationDateActivity")
                var querySearchForMeeting = " SELECT idActivity ,creationDateActivity, dueDateActivity, subjectActivity , statusActivity , priorityActivity, flagActivity, assignedToActivity FROM Activity    WHERE idAccount = \(account.idAccount) AND date(creationDateActivity) = '\(header)' AND flagActivity != 0 ORDER BY creationDateActivity "
                
                header = "Created on: " + results.stringForColumn("creationDateActivity")
                let results: FMResultSet? = DataBase.executeQuery(querySearchForMeeting, withArgumentsInArray: nil)
                if let results = results {
                    while results.next() {
                        var activityArgs = [InitializationData]()
                        let idActivity = Int(results.intForColumn("idActivity"))
                        for i in 1..<elementsOfActivities.count {
                            let attribute = elementsOfActivities[i]
                            let activityArg: InitializationData = (attribute, results.stringForColumn(attribute))
                            activityArgs.append(activityArg)
                        }
                        let activity = ActivitiesModel(idActivity: idActivity, elementsOfActivities: activityArgs)
                        activities.append(activity)
                    }
                }
                let elementOfDataToReturn: SearchPerDate = (header, activities)
                activitiesPerDate.append(elementOfDataToReturn)
                
            }
        }
        return activitiesPerDate
    }
    
}

