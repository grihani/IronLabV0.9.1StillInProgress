//
//  Vue360OfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class Vue360OfAccountViewController: UIViewController {

    var account: AccountsModel! {
        didSet {
            nameAccount?.text = account.nameAccount
            shortNameAccount?.text = account.shortNameAccount
            typeAccount?.text = account.typeAccount
            websiteAccount?.text = account.websiteAccount
            parentAccount?.text = DetailsOfAccountAPI.sharedInstance.findParentAccount(account)
            phoneAccount?.text = account.phoneAccount
            addressAccount?.text = account.adressAccount
        }
    }
    
    var contactsOfAccount: [ContactsModel] {
        return DetailsOfAccountAPI.sharedInstance.getContactsOfAccount(account)
    }
    
    var topOpportunitiesOfAccount: [OpportunityModel] {
        return DetailsOfAccountAPI.sharedInstance.getTopOpportunitiesOfAccount(account, limit: 3)
    }
    
    @IBOutlet weak var nameAccount: UILabel! { didSet {
        nameAccount.text = account.nameAccount
    }}
    @IBOutlet weak var shortNameAccount: UILabel! {didSet {
        shortNameAccount.text = account.shortNameAccount
    }}
    @IBOutlet weak var typeAccount: UILabel!{didSet {
        typeAccount.text = account.typeAccount
    }}
    @IBOutlet weak var websiteAccount: UILabel!{ didSet {
        websiteAccount.text = account.websiteAccount
    }}
    @IBOutlet weak var parentAccount: UILabel!{ didSet {
        parentAccount.text = DetailsOfAccountAPI.sharedInstance.findParentAccount(account)
    }}
    @IBOutlet weak var phoneAccount: UILabel!{didSet {
        phoneAccount.text = account.phoneAccount
    }}
    @IBOutlet weak var addressAccount: UILabel!{didSet {
        addressAccount.text = account.adressAccount
    }}
    @IBOutlet weak var favoriteContacts: UITableView! {didSet {
        favoriteContacts.dataSource = self
    }}
    @IBOutlet weak var topDeals: UITableView!{didSet {
        topDeals.dataSource = self
    }}
    
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
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

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
}

extension Vue360OfAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favoriteContacts {
            if contactsOfAccount.count != 0 {
                return contactsOfAccount.count
            }
            else {
                return 1
            }
        } else if tableView == topDeals {
            if topOpportunitiesOfAccount.count != 0 {
                return topOpportunitiesOfAccount.count
            }
            else {
                return 1
            }
        }
        return 0
    }
    private struct cellIdentifiers {
        static let contactsIdentifier = "Cells of contact"
        static let topDealsIdentifier = "Cells of top deals"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cellIdentifier = ""
        if tableView == favoriteContacts {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.contactsIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if contactsOfAccount.count != 0 {
                cell.textLabel?.text = contactsOfAccount[row].firstNameContact + " " + contactsOfAccount[row].lastNameContact
                cell.detailTextLabel?.text = contactsOfAccount[row].jobTitleContact
            }
            else {
                cell.textLabel?.text = undefinedInformation
                cell.detailTextLabel?.text = ""
            }
            return cell
        } else if tableView == topDeals {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.topDealsIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if topOpportunitiesOfAccount.count != 0 {
                cell.textLabel?.text = topOpportunitiesOfAccount[row].nameOpportunity
                cell.detailTextLabel?.text = String(topOpportunitiesOfAccount[row].potentialAmountOpportunity)
            }
            else {
                cell.textLabel?.text = undefinedInformation
                cell.detailTextLabel?.text = ""
            }
            return cell
        }
        return UITableViewCell()
    }
}
