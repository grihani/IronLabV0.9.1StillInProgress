//
//  SearchForMeetingsViewController.swift
//  IronLab
//
//  Created by CSC CSC on 11/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForMeetingsViewController: UIViewController {
    
    typealias AllMeetings = SearchForMeetingsAPI.AllMeetings
    @IBOutlet var meetingsTableView: UITableView!
    // MARK: - model
    
    var meetings: AllMeetings {
        return SearchForMeetingsAPI.sharedInstance.getAllMeetings()
    }
    
    
    @IBOutlet weak var meetingsSearchResults: UITableView! {
        didSet {
            meetingsSearchResults.dataSource = self
            meetingsSearchResults.estimatedRowHeight = meetingsSearchResults.rowHeight
            meetingsSearchResults.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController.topViewController as? DetailsOfMeetingViewController {
            
            if let indexPath = meetingsSearchResults.indexPathForSelectedRow() {
                destinationViewController.meeting = meetings[indexPath.section].meetingsAndAccounts[indexPath.row].meeting
            }
        }
    }
    

}

extension SearchForMeetingsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return meetings.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meetings[section].date
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings[section].meetingsAndAccounts.count
    }
    
    private struct CellIdentifiers {
        static let Meetings = "search for meetings"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let meeting = meetings[section].meetingsAndAccounts[row].meeting
        let account = meetings[section].meetingsAndAccounts[row].account
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Meetings, forIndexPath: indexPath) as! SearchAccountsPerMeetingsTableViewCell
        cell.dateBeginMeeting.text = "From "  + translateDatesToHours(meeting.dateBeginMeeting)
        cell.dateEndMeeting.text = "To " + translateDatesToHours(meeting.dateEndMeeting)
        cell.nameAccount.text = account.nameAccount
        cell.subjectMeeting.text = meeting.subjectMeeting
        return cell
    }
    
    func translateDatesToHours(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
