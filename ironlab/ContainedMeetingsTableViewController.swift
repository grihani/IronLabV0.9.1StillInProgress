//
//  ContainedMeetingsTableViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 27/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ContainedMeetingsTableViewController: UITableViewController {

    var account: AccountsModel! {
        didSet {
            tableView.reloadData()
            navigationItem.title = "My meetings at \(account.nameAccount)"
        }
    }
    var meetings: [MeetingsModel]! {
        return DetailsOfAccountAPI.sharedInstance.getMeetingsOfAccount(account)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return meetings.count
    }

    private struct cellIdentifiers {
        static let SimpleMeeting = "meetings of Account"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.SimpleMeeting, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let meeting = meetings[row]
        cell.textLabel?.text = meeting.subjectMeeting
        cell.detailTextLabel?.text = meeting.dateBeginMeeting
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    private struct segueIdentifiers {
        static let AddMeetingOfAccount = "add a meeting of account"
        static let ShowMeeting = "show meeting"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifiers.AddMeetingOfAccount {
            if let destinationViewController = segue.destinationViewController.topViewController as? FirstStepCreatingMeetingOfAccount {
                destinationViewController.account = account
            }
        }
        if segue.identifier == segueIdentifiers.ShowMeeting {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let indexPath = tableView.indexPathForSelectedRow()
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(meetings[indexPath!.row].idMeeting, forKey: "meeting")
                println(defaults.integerForKey("meeting"))
            }
        }
    }
    
    @IBAction func unwindSegueToMeetingsOfAccount(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    

}
