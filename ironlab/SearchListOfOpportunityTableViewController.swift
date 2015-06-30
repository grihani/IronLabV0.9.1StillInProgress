//
//  SearchListOfOpportunityTableViewController.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class SearchListOfOpportunityTableViewController: UITableViewController {
    
    typealias TypeForSection = [(sectionName: String, opportunity: [OpportunityModel])]
    // MARK: - IBOutlet
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var listOpportunitiesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    var listOpportunitiesToDisplay: TypeForSection = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOpportunitiesToDisplay = SearchListOfOpportunityAPI().getSearchListOpportunitiesFromCloseDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeOpportunityList(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listOpportunitiesToDisplay = SearchListOfOpportunityAPI().getSearchListOpportunitiesFromCloseDate()
        case 1:
            listOpportunitiesToDisplay = SearchListOfOpportunityAPI().getSearchListOpportunitiesFromAToZ()
        case 2:
            listOpportunitiesToDisplay = SearchListOfOpportunityAPI().getSearchListOpportunitiesFromStatus()
        default:
            break
        }
        listOpportunitiesTableView.reloadData()
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listOpportunitiesToDisplay.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return listOpportunitiesToDisplay[section].opportunity.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        let row = indexPath.row
        let section = indexPath.section
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell opportunity close date", forIndexPath: indexPath) as! SearchListOfOpportunityCloseDateTableViewCell
            cell.opportunityNameLabel.text = listOpportunitiesToDisplay[section].opportunity[row].nameOpportunity
            cell.opportunityOwnerLabel.text = listOpportunitiesToDisplay[section].opportunity[row].ownerOpportunity
            cell.opportunityStatusLabel.text = listOpportunitiesToDisplay[section].opportunity[row].statusOpportunity
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell opportunity A to Z", forIndexPath: indexPath) as! SearchListOfOpportunityAToZTableViewCell
            cell.opportunityNameLabel.text = listOpportunitiesToDisplay[section].opportunity[row].nameOpportunity
            cell.opportunityOwnerLabel.text = listOpportunitiesToDisplay[section].opportunity[row].ownerOpportunity
            cell.opportunityStatusLabel.text = listOpportunitiesToDisplay[section].opportunity[row].statusOpportunity
            cell.opportunityCloseDateLabel.text = listOpportunitiesToDisplay[section].opportunity[row].expectedCloseDateOpportunity
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell opportunity status", forIndexPath: indexPath) as! SearchListOfOpportunityStatusTableViewCell
            cell.opportunityNameLabel.text = listOpportunitiesToDisplay[section].opportunity[row].nameOpportunity
            cell.opportunityOwnerLabel.text = listOpportunitiesToDisplay[section].opportunity[row].ownerOpportunity
            cell.opportunityCloseDateLabel.text = listOpportunitiesToDisplay[section].opportunity[row].expectedCloseDateOpportunity
            return cell
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listOpportunitiesToDisplay[section].sectionName
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chosenOpportunityCloseDate" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let controller = segue.destinationViewController.contentViewController as? DetailsOfOpportunityViewController {
                    let row = indexPath.row
                    let section = indexPath.section
                    var opportunity = SearchListOfOpportunityAPI().getOpportunityFromIdOpportunity(idOpportunity: listOpportunitiesToDisplay[section].opportunity[row].idOpportunity)
                    controller.opportunity = opportunity
                }
            }
        } else if segue.identifier == "chosenOpportunityAToZ" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let controller = segue.destinationViewController.contentViewController as? DetailsOfOpportunityViewController {
                    let row = indexPath.row
                    let section = indexPath.section
                    var opportunity = SearchListOfOpportunityAPI().getOpportunityFromIdOpportunity(idOpportunity: listOpportunitiesToDisplay[section].opportunity[row].idOpportunity)
                    controller.opportunity = opportunity
                }
            }
        } else if segue.identifier == "chosenOpportunityStatus" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let controller = segue.destinationViewController.contentViewController as? DetailsOfOpportunityViewController {
                    let row = indexPath.row
                    let section = indexPath.section
                    var opportunity = SearchListOfOpportunityAPI().getOpportunityFromIdOpportunity(idOpportunity: listOpportunitiesToDisplay[section].opportunity[row].idOpportunity)
                    controller.opportunity = opportunity
                }
            }
        }
    }
}