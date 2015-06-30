//
//  HomePageV2ViewController.swift
//  IronLab
//
//  Created by CSC CSC on 19/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class HomePageV2ViewController: UIViewController {
    typealias DataOfNextMeetings = [MeetingsOfHomePageAPI.TypeData]
    typealias DataOfMissingDocs = MeetingsOfHomePageAPI.DataOfMissingDocs
    
    @IBOutlet var meetingTableView: UITableView! {
        didSet {
            meetingTableView.delegate = self
            meetingTableView.dataSource = self
            meetingTableView.estimatedRowHeight = meetingTableView.rowHeight
            meetingTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var opportunitiesTableView: UITableView!  {
        didSet {
            opportunitiesTableView.delegate = self
            opportunitiesTableView.dataSource = self
            opportunitiesTableView.estimatedRowHeight = opportunitiesTableView.rowHeight
            opportunitiesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var accountsTableView: UITableView!{
        didSet {
            accountsTableView.delegate = self
            accountsTableView.dataSource = self
            accountsTableView.estimatedRowHeight = accountsTableView.rowHeight
            accountsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var newsTableView: UITableView!{
        didSet {
            newsTableView.delegate = self
            newsTableView.dataSource = self
            newsTableView.estimatedRowHeight = newsTableView.rowHeight
            newsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var containerView: UIView!
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Models
    var nextMeetings: DataOfNextMeetings {
        return MeetingsOfHomePageAPI.sharedInstance.getNextMeetings()
    }
    
    var missingDocs: DataOfMissingDocs {
        return MeetingsOfHomePageAPI.sharedInstance.getMissingDocuments()
    }
    
    var nextOpportunities: [OpportunityModel] {
        return MeetingsOfHomePageAPI.sharedInstance.getOpportunities()
    }
    
    var accountsToFolllow: [MeetingsOfHomePageAPI.DataOfAccountsToFollow]{
        return MeetingsOfHomePageAPI.sharedInstance.getAccountsToFollow()
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindSegueToHomePageV2(segue: UIStoryboardSegue) {
        
    }
    
    private struct SegueIdentifiers {
        static let SelectedMeeting = "show selected meeting from homepage"
        static let SelectedOpportunity = "show opportunities from homepage"
        static let SelectedAccount = "show account"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.SelectedMeeting {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let indexPath = meetingTableView.indexPathForSelectedRow()
//                destinationVC.meeting = nextMeetings[indexPath!.row].meeting
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(nextMeetings[indexPath!.row].meeting.idMeeting, forKey: UserDefaults.Meeting)
            }
        }
        if segue.identifier == SegueIdentifiers.SelectedOpportunity {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let indexPath = opportunitiesTableView.indexPathForSelectedRow()
                let opportunity = nextOpportunities[indexPath!.row]
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(opportunity.idOpportunity, forKey: UserDefaults.Opportunity)
            }
        }
        if segue.identifier == SegueIdentifiers.SelectedAccount {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let indexPath = accountsTableView.indexPathForSelectedRow()
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(accountsToFolllow[indexPath!.row].idAccount, forKey: UserDefaults.Account)
            }
        }
    }
    private struct CellIdentifiers {
        static let Meetings = "homepage meetings"
        static let MeetingsSubtitle = "homepage meetings subtitle"
        static let Opportunities = "homepage opportunities"
        static let Accounts = "homepage accounts"
        static let MissingDocuments = "homepage missing documents"
        
    }
}

extension HomePageV2ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
extension HomePageV2ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == meetingTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.MeetingsSubtitle, forIndexPath: indexPath) as! UITableViewCell
            let account = nextMeetings[indexPath.row].account
            let meeting = nextMeetings[indexPath.row].meeting
            cell.textLabel?.text = account.nameAccount
            cell.detailTextLabel?.text = translateDatesToDay(meeting.dateBeginMeeting) + " From " + translateDatesToHours(meeting.dateBeginMeeting) + " To " + translateDatesToHours(meeting.dateEndMeeting)
            return cell
        }
        else if tableView == newsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.MissingDocuments, forIndexPath: indexPath) as! MissingDocumentsTableViewCell
            let row = indexPath.row
            let customer = missingDocs[row].customer
            let description = missingDocs[row].description
            let revenue = String(missingDocs[row].revenue) + "k€"
            cell.customerLabel.text = customer
            cell.descriptionLabel.text = description
            cell.revenueLabel.text = revenue
            return cell
        }
        else if tableView == opportunitiesTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Opportunities, forIndexPath: indexPath) as! HomePageOpportunitiesTableViewCell
            let opportunity = nextOpportunities[indexPath.row]
            cell.subjectOpportunity.text = opportunity.nameOpportunity
            cell.somethingElseOpportunity.text = opportunity.statusOpportunity
            cell.eurosView.potentialAmountOpportunity = opportunity.potentialAmountOpportunity
            
            return cell
            
        }
        else if tableView == accountsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Accounts, forIndexPath: indexPath) as! HomePageAccountToFollowTableViewCell
            let account = accountsToFolllow[indexPath.row]
            cell.titleOfAccountToFollow.text = account.nameAccount + " - " + " (" + "\(account.nbrOfOpportunities)" + " opp - Total " + "\(Int(account.sumOfOpportunities))" + " K€)"
            cell.lastMeetingAccountToFollow.text = "Last meeting: " + translateDatesToDay(account.lastMeeting)
            cell.nextMeetingAccountToFollow.text = "Next meeting: " + translateDatesToDay(account.nextMeeting)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == meetingTableView {
            return nextMeetings.count
        }
        if tableView == newsTableView {
            return missingDocs.count
        }
        if tableView == opportunitiesTableView {
            return nextOpportunities.count
        }
        if tableView == accountsTableView {
            return accountsToFolllow.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == meetingTableView {
            return "Next meetings"
        }
        if tableView == opportunitiesTableView {
            return "Coming opportunities"
        }
        if tableView == accountsTableView {
            return "Accounts to follow"
        }
        if tableView == newsTableView {
            return "Missing documents"
        }
        return ""
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
    
    func translateDatesToDay(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
