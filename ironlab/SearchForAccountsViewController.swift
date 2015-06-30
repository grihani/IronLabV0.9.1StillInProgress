//
//  SearchForAccountsViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 25/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SearchForAccountsViewController: UIViewController {

    typealias DataOfSearchPerMeeting = [SearchForAccountsAPI.TypeDataSearchPerMeetings]
    typealias DataOfSearchPerName = [SearchForAccountsAPI.TypeDataSearchPerName]
    
    var accountsPerMeetings: DataOfSearchPerMeeting = []
    var accountsPerName: DataOfSearchPerName = []
    
    let dateFormatter = NSDateFormatter()
    var indexPathOfNextMeeting = NSIndexPath(forRow: 0, inSection: 0)
    var foundNextMeeting = false
    
    var meetingAToZ = false
    
    @IBOutlet weak var accountsSearchResults: UITableView! {
        didSet {
            accountsSearchResults.dataSource = self
            accountsSearchResults.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsPerMeetings = SearchForAccountsAPI.sharedInstance.getAccountsPerMeetings()
        accountsSearchResults.estimatedRowHeight = accountsSearchResults.rowHeight
        accountsSearchResults.rowHeight = UITableViewAutomaticDimension
        accountsSearchResults.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func findIndexPathOfNextMeeting() -> NSIndexPath {
//        var indexPathOfNextMeeting = NSIndexPath(forRow: 0, inSection: 0)
//        for i in 0..<accountsPerMeetings.count {
//            for j in 0..<accountsPerMeetings[i].meetings.count {
//                let dateOfMeeting = accountsPerMeetings[i].meetings[j].dateBeginMeeting
//                if NSDate().dateIsLessThanDate(translateDates(dateOfMeeting)) {
//                    indexPathOfNextMeeting = NSIndexPath(forRow: j, inSection: i)
//                    foundNextMeeting = true
//                    break
//                }
//            }
//            if foundNextMeeting {
//                break
//            }
//        }
//        return indexPathOfNextMeeting
//    }
    
    func translateDates(sqliteDate: String) -> NSDate! {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            return formattedDate
        }
        return nil
    }
    
    // MARK: - SegmentedControl Actions
    @IBAction func switchSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            meetingAToZ = false
            accountsPerMeetings = SearchForAccountsAPI.sharedInstance.getAccountsPerMeetings()
            accountsSearchResults.reloadData()
        case 1:
            meetingAToZ = true
            accountsPerName = SearchForAccountsAPI.sharedInstance.getAccountsPerName(ascendant: true)
            accountsSearchResults.reloadData()
        case 2:
            meetingAToZ = true
            accountsPerName = SearchForAccountsAPI.sharedInstance.getAccountsPerName(ascendant: false)
            accountsSearchResults.reloadData()
        default: break
        }
    }
    
    @IBAction func searchForAccount(sender: UITextField) {
        meetingAToZ = true
        accountsPerName = SearchForAccountsAPI.sharedInstance.searchAccountByNAmeAccount(sender.text)
        accountsSearchResults.reloadData()
    }
    
    
    // MARK: - Navigation
    private struct segueIdentifiers {
        static let seguePerMeeting = "show details of account"
        static let seguePerName = "show details of account from A to Z"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController.topViewController as? DetailsOfAccountViewController {
            
            if let indexPath = accountsSearchResults.indexPathForSelectedRow() {
                if !meetingAToZ {
                    destinationViewController.account = accountsPerMeetings[indexPath.section].accounts[indexPath.row]
                } else {
                    destinationViewController.account = accountsPerName[indexPath.section].accounts[indexPath.row]
                }
            }
        }
    }
}

 extension SearchForAccountsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if meetingAToZ {
            return accountsPerName.count
        }
        return accountsPerMeetings.count
    }
    
    var sectionIndexTitles: [String] {
        var indexes = [String]()
        for elements in accountsPerName {
            indexes.append((elements.headerIndex + "     ").capitalizedString)
        }
        return indexes
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if meetingAToZ {
            return sectionIndexTitles
        }
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if meetingAToZ {
            return accountsPerName[section].headerIndex
        }
        return accountsPerMeetings[section].headerDates
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meetingAToZ {
            return accountsPerName[section].accounts.count
        }
        return  accountsPerMeetings[section].accounts.count
    }
    
    private struct cellIdentifiers {
        static let SearchPerMeeting = "search per meeting"
        static let SearchPerNameAToZ = "search per name"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        if meetingAToZ {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.SearchPerNameAToZ, forIndexPath: indexPath) as! SearchAccountsPerNameTableViewCell
            let account = accountsPerName[section].accounts[row]
            cell.nameAccount.text = account.nameAccount
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.SearchPerMeeting, forIndexPath: indexPath) as! SearchAccountsPerMeetingsTableViewCell
            let account = accountsPerMeetings[section].accounts[row]
            let meeting = accountsPerMeetings[section].meetings[row]
            cell.dateBeginMeeting.text = "From " + translateDatesToHours(meeting.dateBeginMeeting)
            cell.dateEndMeeting.text = "To " + translateDatesToHours(meeting.dateEndMeeting)
            cell.nameAccount.text = account.nameAccount
            cell.subjectMeeting.text = meeting.subjectMeeting
            return cell
        }
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

extension SearchForAccountsViewController: UITableViewDelegate {
    
}

extension SearchForAccountsViewController: UITextFieldDelegate {
    
}

extension NSDate
{
    func dateIsGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        return isGreater
    }
    func dateIsLessThanDate(dateToCompare : NSDate) -> Bool
    {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        return isLess
    }
    func dateIsEqualToDate(dateToCompare : NSDate) -> Bool
    {
        var isEqualTo = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame
        {
            isEqualTo = true
        }
        return isEqualTo
    }
    func addDays(daysToAdd : Int) -> NSDate
    {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    func addHours(hoursToAdd : Int) -> NSDate
    {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}