//
//  PipelineOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class PipelineOfAccountViewController: UIViewController {

    var account: AccountsModel!
    
    var opportunitiesOfAccount: [OpportunityModel] = [] {
        didSet {
            detailsOpportunitiesOfAccount?.reloadData()
        }
    }
    
    @IBOutlet var detailsOpportunitiesOfAccount: UITableView! {
        didSet {
            detailsOpportunitiesOfAccount.delegate = self
            detailsOpportunitiesOfAccount.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsOpportunitiesOfAccount.estimatedRowHeight = detailsOpportunitiesOfAccount.rowHeight
        detailsOpportunitiesOfAccount.rowHeight = UITableViewAutomaticDimension
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getOpenOpportunitiesOfAccount(account)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private struct colorsForButtons {
        static let uncheckedBackground = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        static let checkedBackground = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let fontColorChecked = UIColor(red: 01, green: 01, blue: 01, alpha: 1)
        static let fontColorUnchecked = UIColor(red: 01, green: 01, blue: 01, alpha: 1)
    }
    
    @IBOutlet var barForItems: [UIButton]!
    
    @IBAction func leadClicked(sender: UIButton) {
        colorButtons(sender)
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getDraftOpportunitiesOfAccount(account)
    }
    
    @IBAction func openClicked(sender: UIButton) {
        colorButtons(sender)
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getOpenOpportunitiesOfAccount(account)
    }
    
    @IBAction func lostClicked(sender: UIButton) {
        colorButtons(sender)
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getLostOpportunitiesOfAccount(account)
    }

    @IBAction func wonClicked(sender: UIButton) {
        colorButtons(sender)
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getWonOpportunitiesOfAccount(account)
    }
    
    @IBAction func allClicked(sender: UIButton) {
        colorButtons(sender)
        opportunitiesOfAccount = DetailsOfAccountAPI.sharedInstance.getOpportunitiesOfAccount(account)
    }
    
    func colorButtons(button: UIButton) {
        for button in barForItems {
            button.backgroundColor = colorsForButtons.uncheckedBackground
        }
        let index = find(barForItems, button)
        barForItems[index!].backgroundColor = colorsForButtons.checkedBackground
    }
    
    // MARK: - Navigation
    private struct SegueIdentifiers {
        static let OpportunityChosen = "show opportunity details"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.OpportunityChosen {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let defaults = NSUserDefaults.standardUserDefaults()
                let indexPath = detailsOpportunitiesOfAccount.indexPathForSelectedRow()!
                
                let chosenOpportunity = opportunitiesOfAccount[indexPath.row]
                defaults.setInteger(chosenOpportunity.idOpportunity, forKey: UserDefaults.Opportunity)
            }
        }
    }
}

extension PipelineOfAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opportunitiesOfAccount.count
    }
    
    private struct cellIdentifiers {
        static let CellForPipeline = "cell for opportunity"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.CellForPipeline, forIndexPath: indexPath) as! CellForPipelineOfAccountTableViewCell
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
}

extension PipelineOfAccountViewController: UITableViewDelegate {
    
}
