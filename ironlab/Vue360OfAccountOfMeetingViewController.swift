//
//  Vue360OfAccountOfMeetingViewController.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class Vue360OfAccountOfMeetingViewController: UIViewController {
    
    @IBOutlet var typeAccount: UILabel!
    @IBOutlet var parentAccount: UILabel!
    @IBOutlet var webSiteAccount: UILabel!
    @IBOutlet var meetingsTableView: UITableView! {
        didSet {
            meetingsTableView.dataSource = self
            meetingsTableView.delegate = self
            meetingsTableView.estimatedRowHeight = meetingsTableView.rowHeight
            meetingsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var opportunitiesTableView: UITableView!{
        didSet {
            opportunitiesTableView.dataSource = self
            opportunitiesTableView.estimatedRowHeight = opportunitiesTableView.rowHeight
            opportunitiesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var contactsTableView: UITableView! {
        didSet {
            contactsTableView.dataSource = self
            contactsTableView.delegate = self
            contactsTableView.estimatedRowHeight = contactsTableView.rowHeight
            contactsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var xmlTableView: UITableView! {
        didSet {
            xmlTableView.dataSource = self
            xmlTableView.estimatedRowHeight = xmlTableView.rowHeight
            xmlTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Models
    var account: AccountsModel! {
        didSet {
            updateUI()
        }
    }
    var meeting: MeetingsModel!
    
    func updateUI() {
        if account != nil {
            typeAccount?.text = account.typeAccount
            parentAccount?.text = DetailsOfMeetingAPI.sharedInstance.findParentAccount(account)
            webSiteAccount?.text = account.websiteAccount
        }
    }
    
    // MARK: - compounded data
    var meetingsOfAccount: [MeetingsModel] {
        if account != nil {
            return DetailsOfMeetingAPI.sharedInstance.meetingsOfAccount(account)
        }
        return []
    }
    
    var opportunitiesOfAccount: [OpportunityModel] {
        if account != nil {
            return DetailsOfMeetingAPI.sharedInstance.getOpportunitiesOfAccount(account)
        }
        return []
    }
    
    var contactsOfAccount: [ContactsModel] {
        if account != nil {
            return DetailsOfMeetingAPI.sharedInstance.getContactsOfAccount(account)
        }
        return []
    }
    var xmlParser : XMLParser!
    
    // MARK: - selected data
    
    var selectedMeeting: MeetingsModel! {
        didSet {
            selectMeeting(selectedMeeting)
        }
    }
    
    var selectedContact: ContactsModel! {
        didSet {
            selectContact(selectedContact)
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHeights(nil)
        updateUI()
        if account != nil {
            var stringURL = "https://news.google.com/?output=rss&hl=fr&gl=fr&tbm=nws&authuser=0&q=\(account.nameAccount)&oq=\(account.nameAccount)"
            stringURL = stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let url = NSURL(string: stringURL)
            xmlParser = XMLParser()
            xmlParser.delegate = self
            let qos = Int(DISPATCH_QUEUE_PRIORITY_HIGH)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue, {
                self.xmlParser.startParsingWithContentsOfURL(url!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.xmlTableView.reloadData()})
            })
        } else {
            
        }
        if meetingsOfAccount.count > 0 {
            selectedMeeting = meetingsOfAccount[0]
        }
        if contactsOfAccount.count > 0 {
            selectedContact = contactsOfAccount[0]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBOutlets for heights
    
    @IBOutlet var heightTabs: [NSLayoutConstraint]!
    
    @IBOutlet var tabs: [UIBarButtonItem]!
    
    private struct heights {
        static let minHeight: CGFloat = 44.0
        static let maxHeight: CGFloat = 400.0
    }
    
    @IBAction func showTab(sender: UIBarButtonItem) {
        let index = find(tabs, sender)
        if let index = index {
            if heightTabs[index].constant == heights.maxHeight {
                initializeHeights(nil)
            } else {
                initializeHeights(index)
            }
        }
    }
    
    func initializeHeights(index: Int!) {
        for height in heightTabs {
            height.constant = heights.minHeight
        }
        if index != nil {
            heightTabs[index].constant = heights.maxHeight
        }
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Navigation
    private struct SegueIdentifiers {
        static let ShowRssSegue = "show rss feed"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.ShowRssSegue {
            if let presentedViewController = segue.destinationViewController.topViewController as? RssFeedWebViewController {
                if let indexPath = self.xmlTableView.indexPathForSelectedRow() {
                    let dictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
                    let rssLink = dictionary["link"]!
                    presentedViewController.url = NSURL(string: rssLink)
                }
            }
        }
    }
    
    // MARK: - Selected meeting
    
    @IBOutlet var dateBeginToEndMeeting: UILabel!
    @IBOutlet var regardingMeeting: UILabel!
    @IBOutlet var locationMeeting: UILabel!
    @IBOutlet var primaryInterlocutor: UILabel!
    @IBOutlet var salesRep: UILabel!
    @IBOutlet var personalNotes: UITextView!
    
    func selectMeeting(meeting: MeetingsModel) {
        dateBeginToEndMeeting.text = getDate(fromDate: meeting.dateBeginMeeting, toDate: meeting.dateEndMeeting)
        regardingMeeting.text = meeting.regardingMeeting
        locationMeeting.text = meeting.adressMeeting
        
        let contactOfMeeting = DetailsOfMeetingAPI.sharedInstance.getPrincipalContactOfMeeting(meeting)
        if let contactOfMeeting = contactOfMeeting {
            primaryInterlocutor.text = contactOfMeeting.lastNameContact + " " + contactOfMeeting.firstNameContact
        } else {
            primaryInterlocutor.text = "--"
        }
        salesRep.text = String(meeting.idAccount)
        personalNotes.text = meeting.notesMeeting
    }
    
    func getDate(#fromDate: String, toDate: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let nsDateOfFromDate = dateFormatter.dateFromString(fromDate)
        let nsDateOfToDate = dateFormatter.dateFromString(toDate)
        var compoundedDate = ""
        dateFormatter.dateStyle = .LongStyle
        compoundedDate += dateFormatter.stringFromDate(nsDateOfFromDate!)
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle
        compoundedDate += " From \(dateFormatter.stringFromDate(nsDateOfFromDate!)) To \(dateFormatter.stringFromDate(nsDateOfToDate!))"
        return compoundedDate
    }
    
    
    
    // MARK: - Selected Contact
    
    @IBOutlet var AddOrRemoveButtonContactInMeeting: UIButton!
    @IBOutlet var adressOfContactInMeeting: UILabel!
    @IBOutlet var languageOfContactInMeeting: UILabel!
    @IBOutlet var telecopieOfContactInMeeting: UILabel!
    @IBOutlet var serviceOfContactInMeeting: UILabel!
    @IBOutlet var functionOfContactInMeeting: UILabel!
    @IBOutlet var emailOfContactInMeeting: UILabel!
    @IBOutlet var workingPhoneOfContactInMeeting: UILabel!
    @IBOutlet var mobilePhoneOfContactInMeeting: UILabel!
    
    
    @IBAction func AddOrRemoveContactForMeeting(sender: UIButton) {
        if( selectedContact != nil ) {
            var querySQLHeader = "SELECT * FROM Meetings_Contacts WHERE idContact == '\(selectedContact.idContact)' AND idMeeting == '\(meeting.idMeeting)' "
            let results: FMResultSet? = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
            if ( results != nil) {
                if( results!.next() ) {
                    querySQLHeader = "DELETE FROM Meetings_Contacts WHERE idContact = '\(selectedContact.idContact)' AND idMeeting = '\(meeting.idMeeting)' "
                    DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
                    AddOrRemoveButtonContactInMeeting.setImage(UIImage(named: "AddToParticipants"), forState: .Normal)
                } else {
                    querySQLHeader = "INSERT INTO Meetings_Contacts VALUES ('\(selectedContact.idContact)' , '\(meeting.idMeeting)' )"
                    DataBase.executeUpdate(querySQLHeader, withArgumentsInArray: nil)
                    AddOrRemoveButtonContactInMeeting.setImage(UIImage(named: "removeFromParticipants"), forState: .Normal)
                }
            }
        }
    }
    
    func selectContact(contact: ContactsModel) {
        adressOfContactInMeeting.text = contact.workingAdressContact
        languageOfContactInMeeting.text = contact.preferredLanguageContact
        serviceOfContactInMeeting.text = contact.jobTitleContact
        functionOfContactInMeeting.text = contact.typeContact
        emailOfContactInMeeting.text = contact.emailContact
        workingPhoneOfContactInMeeting.text = contact.phoneBusinessContact
        mobilePhoneOfContactInMeeting.text = contact.phoneMobileContact
        telecopieOfContactInMeeting.text = "--"
        
        var querySQLHeader = "SELECT * FROM Meetings_Contacts WHERE idContact == \(contact.idContact) AND idMeeting == \(meeting.idMeeting)"
        let results: FMResultSet? = DataBase.executeQuery(querySQLHeader, withArgumentsInArray: nil)
        if (results != nil) {
            if( results!.next() ) {
                AddOrRemoveButtonContactInMeeting.setImage(UIImage(named: "removeFromParticipants"), forState: .Normal)
            } else {
                AddOrRemoveButtonContactInMeeting.setImage(UIImage(named: "AddToParticipants"), forState: .Normal)
            }
        }
    }
    // MARK: - Graphs
    // MARK: - IBAction For Showing and Hiding the graphs
    @IBOutlet weak var doughnutGraphView: UIView!
    @IBOutlet weak var barGraphContainer: UIView!
    @IBOutlet weak var buttonForDoughnutGraphView: UIButton!
    @IBOutlet weak var buttonForBarGraphView: UIButton!
    @IBAction func showDoughnutGraphs(sender: UIButton) {
        UIView.transitionFromView(barGraphContainer, toView: doughnutGraphView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromBottom | .ShowHideTransitionViews, completion: nil)
        buttonForDoughnutGraphView.enabled = false
        buttonForBarGraphView.enabled = true
    }
    
    @IBAction func showBarGraph(sender: UIButton) {
        UIView.transitionFromView(doughnutGraphView, toView: barGraphContainer, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromBottom | .ShowHideTransitionViews, completion: nil)
        buttonForDoughnutGraphView.enabled = true
        buttonForBarGraphView.enabled = false
    }
    
    // MARK: - IBAction for clicking on the graph view
    
    @IBOutlet weak var budgettedLabel: UILabel! {didSet {
        budgettedLabel.text = "budgeted: \(Int(barGraphView.valueForOpportunities[5])) k€"
        }}
    @IBOutlet weak var topLabel: UILabel! {didSet {
        topLabel.text = "YR-1: \(Int(barGraphView.valueForLine[5])) k€"
        }}
    @IBOutlet weak var midLabel: UILabel! {didSet {
        midLabel.text = "Real: \(Int(barGraphView.valueForFirstBar[5])) k€"
        }}
    @IBOutlet weak var bottomLabel: UILabel! {didSet {
        bottomLabel.text = "Opportunities: \(Int(barGraphView.valueForSecondBar[5])) k€"
        }}
    
    @IBOutlet weak var barGraphView: GraphViewForVue360!
    
    @IBAction func tapTheGraphView(sender: UITapGestureRecognizer) {
        let pointOfTap = sender.locationInView(barGraphView)
        let margin = barGraphView.margin
        let spacer = barGraphView.spacer
        
        if pointOfTap.x > margin * 3/4 && pointOfTap.x < barGraphView.bounds.size.width - margin * 3/4 {
            
            let sectionOfTouch = Int((pointOfTap.x - margin/2) / spacer)
            budgettedLabel.text = "budgeted: \(Int(barGraphView.valueForOpportunities[sectionOfTouch])) k€"
            topLabel.text = "YR-1: \(Int(barGraphView.valueForLine[sectionOfTouch])) k€"
            midLabel.text = "Real: \(Int(barGraphView.valueForFirstBar[sectionOfTouch])) k€"
            bottomLabel.text = "Opportunities: \(Int(barGraphView.valueForSecondBar[sectionOfTouch])) k€"
            //            barGraphView.selectedMonth = sectionOfTouch
            barGraphView.actualMonth = sectionOfTouch
        }
    }
    
    // MARK: - Dougnuts
    @IBOutlet weak var numbersOfLeftDoughnut: UILabel! {
        didSet {
            if let leftDoughnut = leftDoughnut {
                numbersOfLeftDoughnut.text = "\(leftDoughnut.doneActivities)/\(leftDoughnut.totalActivities)"
            }
        }
    }
    @IBOutlet weak var leftDoughnut: DoughnutsForVue360! {
        didSet {
            leftDoughnut.background = UIColor(red: 220/255, green: 230/255, blue: 242/255, alpha: 1)
            leftDoughnut.onTopColor = UIColor(red: 149/255, green: 178/255, blue: 216/255, alpha: 1)
            leftDoughnut.overAchiever = leftDoughnut.onTopColor
            leftDoughnut.totalActivities = 30
            leftDoughnut.doneActivities = 20
            numbersOfLeftDoughnut?.text = "\(leftDoughnut.doneActivities)/\(leftDoughnut.totalActivities)"
        }
    }
    
    @IBOutlet weak var numbersOfLeftMiddleDoughnut: UILabel! {
        didSet {
            if let leftMiddleDoughnut = leftMiddleDoughnut {
                numbersOfLeftMiddleDoughnut.text = "\(leftMiddleDoughnut.doneActivities)/\(leftMiddleDoughnut.totalActivities)"
            }
        }
    }
    @IBOutlet weak var leftMiddleDoughnut: DoughnutsForVue360! {
        didSet {
            leftMiddleDoughnut.background = UIColor(red: 253/255, green: 234/255, blue: 218/255, alpha: 1)
            leftMiddleDoughnut.onTopColor = UIColor(red: 250/255, green: 192/255, blue: 144/255, alpha: 1)
            leftMiddleDoughnut.overAchiever = leftMiddleDoughnut.onTopColor
            leftMiddleDoughnut.totalActivities = 10
            leftMiddleDoughnut.doneActivities = 2
            numbersOfLeftMiddleDoughnut?.text = "\(leftMiddleDoughnut.doneActivities)/\(leftMiddleDoughnut.totalActivities)"
        }
    }
    
    @IBOutlet weak var numbersOfRightMiddleDoughnut: UILabel!{
        didSet {
            if let rightMiddleDoughnut = rightMiddleDoughnut {
                numbersOfRightMiddleDoughnut.text = "\(rightMiddleDoughnut.doneActivities)/\(rightMiddleDoughnut.totalActivities)"
            }
        }
    }
    @IBOutlet weak var rightMiddleDoughnut: DoughnutsForVue360! {
        didSet {
            rightMiddleDoughnut.background = UIColor(red: 225/255, green: 234/255, blue: 205/255, alpha: 1)
            rightMiddleDoughnut.onTopColor = UIColor(red: 164/255, green: 215/255, blue: 109/255, alpha: 1)
            rightMiddleDoughnut.overAchiever = rightMiddleDoughnut.onTopColor
            rightMiddleDoughnut.totalActivities = 25
            rightMiddleDoughnut.doneActivities = 25
            numbersOfRightMiddleDoughnut?.text = "\(rightMiddleDoughnut.doneActivities)/\(rightMiddleDoughnut.totalActivities)"
        }
    }
    
    @IBOutlet weak var numbersOfRightDoughnut: UILabel!{
        didSet {
            if let rightDoughnut = rightDoughnut {
                numbersOfRightDoughnut.text = "\(rightDoughnut.doneActivities)/\(rightDoughnut.totalActivities)"
            }
        }
    }
    @IBOutlet weak var rightDoughnut: DoughnutsForVue360! {
        didSet {
            rightDoughnut.background = UIColor(red: 223/255, green: 238/255, blue: 241/255, alpha: 1)
            rightDoughnut.onTopColor = UIColor(red: 194/255, green: 227/255, blue: 236/255, alpha: 1)
            rightDoughnut.overAchiever = rightDoughnut.onTopColor
            rightDoughnut.totalActivities = 20
            rightDoughnut.doneActivities = 30
            numbersOfRightDoughnut?.text = "\(rightDoughnut.doneActivities)/\(rightDoughnut.totalActivities)"
        }
    }
}

// MARK: - Extensions

extension Vue360OfAccountOfMeetingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == meetingsTableView {
            return meetingsOfAccount.count
        }
        if tableView == opportunitiesTableView {
            return opportunitiesOfAccount.count
        }
        if tableView == contactsTableView {
            return contactsOfAccount.count
        }
        if tableView == xmlTableView {
            if xmlParser == nil {
                return 0
            } else {
                return xmlParser.arrParsedData.count-1
            }
        }
        return 0
    }
    private struct CellIdentifiers {
        static let Meetings = "cell for meetings"
        static let Opportunities = "cell for opportunity"
        static let Contacts = "cell for contact"
        static let News = "cell for news of account"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == meetingsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Meetings, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = meetingsOfAccount[indexPath.row].subjectMeeting
            cell.detailTextLabel?.text = meetingsOfAccount[indexPath.row].dateBeginMeeting
            
            return cell
        }
        if tableView == opportunitiesTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Opportunities, forIndexPath: indexPath) as! CellForPipelineOfAccountTableViewCell
            let row = indexPath.row
            let opportunityInCell = opportunitiesOfAccount[row]
            cell.nameOpportunity.text = opportunityInCell.nameOpportunity
            cell.bUOpportunity.text = opportunityInCell.teamOpportunity
            cell.priorityOpportunity.text = opportunityInCell.priorityOpportunity
            cell.typeOpportunity.text = opportunityInCell.typeOpportunity
            cell.estimatedPriceOpportunity.text = String(opportunityInCell.potentialAmountOpportunity) + " €"
            cell.weightedPriceOpportunity.text = String(opportunityInCell.potentialAmountOpportunity * opportunityInCell.probabilityOpportunity / 100) + " €"
            cell.phaseOpportunity.text = opportunityInCell.statusOpportunity
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateFromString = dateFormatter.dateFromString(opportunityInCell.expectedCloseDateOpportunity)
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = .NoStyle
            cell.estimatedDateOpportunity.text = dateFormatter.stringFromDate(dateFromString!)
            return cell
        }
        if tableView == contactsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Contacts, forIndexPath: indexPath) as! ContactsOfAccountTableViewCell
            let row = indexPath.row
            let nameAndSurnameContact = contactsOfAccount[row].firstNameContact + " " + contactsOfAccount[row].lastNameContact
            cell.nameAndSurnameContact.text = nameAndSurnameContact
            cell.jobDescriptionContact.text = contactsOfAccount[row].jobTitleContact
            if contactsOfAccount[row].favoriteContact == 1 {
                cell.favoriteContact.image = UIImage(named: "Favorites")
            }
            return cell
        }
        if tableView == xmlTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell for news of account", forIndexPath: indexPath) as! RssFeedTableViewCell
            
            let currentDictionary = self.xmlParser.arrParsedData[indexPath.row + 1] as Dictionary<String, String>
            
            var tittleWithoutTitleOfMagazine = currentDictionary["title"]
            var myArray = tittleWithoutTitleOfMagazine!.componentsSeparatedByString("-")
            var countNumberOfCharacterInTittle: Int = count(tittleWithoutTitleOfMagazine!)
            let i = myArray.count
            let countNumberOfCharacterToDelete = count(myArray[i-1])
            countNumberOfCharacterInTittle = countNumberOfCharacterInTittle - countNumberOfCharacterToDelete
            tittleWithoutTitleOfMagazine = tittleWithoutTitleOfMagazine!.substringToIndex(advance(tittleWithoutTitleOfMagazine!.startIndex, countNumberOfCharacterInTittle - 1 ))
            
            var dateModify = currentDictionary["pubDate"]
            dateModify = dateModify!.substringWithRange(Range<String.Index>(start: advance(dateModify!.startIndex, 5), end: advance(dateModify!.endIndex, -10))) + "H" + dateModify!.substringWithRange(Range<String.Index>(start: advance(dateModify!.startIndex, 20), end: advance(dateModify!.endIndex, -7))) + "min"
            
            
            cell.dateTimeRssFeed.text = dateModify
            cell.summaryRssFeed.text = tittleWithoutTitleOfMagazine
            cell.dateTimeRssFeed.text = cell.dateTimeRssFeed.text! + " - " + myArray[i-1]
            
            
            return cell
        }
        return UITableViewCell()
    }
}

extension Vue360OfAccountOfMeetingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == meetingsTableView {
            selectedMeeting = meetingsOfAccount[indexPath.row]
        }
        if tableView == contactsTableView {
            selectedContact = contactsOfAccount[indexPath.row]
        }
    }
}

extension Vue360OfAccountOfMeetingViewController: XMLParserDelegate {
    func parsingWasFinished() {
        xmlTableView.reloadData()
    }
}
