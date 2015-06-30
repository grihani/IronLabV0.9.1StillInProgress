//
//  MeetingsOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class MeetingsOfAccountViewController: UIViewController {
    
    var account: AccountsModel! {
        didSet {
            updateMeeting()
        }
    }
    
    
    let dateFormatter = NSDateFormatter()
    typealias DataOfTableView = [MeetingsOfHomePageAPI.TypeData]
    var meetingsOfDate = DataOfTableView()
    
    @IBOutlet weak var meetingsOfDayTableView: UITableView! {
        didSet {
            meetingsOfDayTableView.dataSource = self
            meetingsOfDayTableView.delegate = self
        }
    }
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var chosenDateLabel: UILabel!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenDateLabel.text = calendarView.stringFromChosenDay
        calendarView.chosenButton = calendarView.buttons[calendarView.index]
        meetingsOfDate = MeetingsOfHomePageAPI.sharedInstance.getMeetingsOfDate(NSDate())
        meetingsOfDayTableView.estimatedRowHeight = meetingsOfDayTableView.rowHeight
        meetingsOfDayTableView.rowHeight = UITableViewAutomaticDimension
        meetingsOfDayTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - actions related to calendar
    @IBAction func chooseADay(sender: UIButton) {
        calendarView.chosenButton = sender
        chosenDateLabel.text = calendarView.stringFromChosenDay
        let chosenDate = calendarView.chosenDay
        meetingsOfDate = MeetingsOfHomePageAPI.sharedInstance.getMeetingsOfDate(chosenDate)
        meetingsOfDayTableView.reloadData()
    }

    private struct segueIdentifiers {
        static let segueOfContainer = "show meetings of account"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var destinationTableViewController: ContainedMeetingsTableViewController?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.segueOfContainer {
            destinationTableViewController = segue.destinationViewController.topViewController as? ContainedMeetingsTableViewController
            updateMeeting()
        }
    }
    
    func updateMeeting() {
        destinationTableViewController?.account = account
    }
}
extension MeetingsOfAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingsOfDate.count
    }
    private struct cellIdentifiers {
        static let LeftDetails = "meetings of day"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.LeftDetails, forIndexPath: indexPath) as! HomePageMeetingsTableViewCell
        let row = indexPath.row
        let account = meetingsOfDate[row].account
        let meeting = meetingsOfDate[row].meeting
        cell.dateBeginMeeting.text = translateDatesToHours(meeting.dateBeginMeeting)
        cell.dateEndMeeting.text = translateDatesToHours(meeting.dateEndMeeting)
        cell.nameAccount.text = account.nameAccount
        cell.subjectMeeting.text = meeting.subjectMeeting
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(meetingsOfDate.count) + " Meeting(s)"
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func translateDatesToHours(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .MediumStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
extension MeetingsOfAccountViewController: UITableViewDelegate {
    
}
