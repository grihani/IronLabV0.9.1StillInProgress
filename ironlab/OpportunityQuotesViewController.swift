//
//  OpportunityQuotesViewController.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class OpportunityQuotesViewController: UIViewController {
    
    // MARK: - IBOutlet TableView
    @IBOutlet weak var listQuotesTableView: UITableView!
    @IBOutlet weak var listProductsTableView: UITableView! {
        didSet {
            self.listProductsTableView.delegate = self
            self.listProductsTableView.dataSource = self
        }
    }
    // MARK: - IBOutlet Detail of Contrat
    @IBOutlet weak var quoteNumberLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.quoteNumberLabel.text = contratSelected.nameContrat
            }
        }
    }
    @IBOutlet weak var startDateQuoteLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.startDateQuoteLabel.text = contratSelected.startDateContrat
            }
        }
    }
    @IBOutlet weak var expireOnQuoteLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.expireOnQuoteLabel.text = contratSelected.expiresOnContrat
            }
        }
    }
    @IBOutlet weak var totalAmountDiscountQuoteLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.totalAmountDiscountQuoteLabel.text = contratSelected.totalAmountDiscountContrat
            }
        }
    }
    @IBOutlet weak var totalPercentageDiscountQuoteLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.totalPercentageDiscountQuoteLabel.text = contratSelected.totalPercentageDiscountContrat
            }
        }
    }
    @IBOutlet weak var statusQuoteLabel: UILabel! {
        didSet {
            if let contratSelected = contratSelected {
                self.statusQuoteLabel.text = contratSelected.statusContrat
            }
        }
    }
    // MARK: - IBOutlet Product
    @IBOutlet weak var productLabel: UILabel! {
        didSet {
//            self.productLabel?.backgroundColor = blueCheckedColor
//            self.productLabel?.tintColor = whiteColor
        }
    }
    @IBOutlet weak var listUnitPriceLabel: UILabel! {
        didSet {
//            self.listUnitPriceLabel?.backgroundColor = blueCheckedColor
//            self.listUnitPriceLabel?.tintColor = whiteColor
        }
    }
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
//            self.quantityLabel?.backgroundColor = blueCheckedColor
//            self.quantityLabel?.tintColor = whiteColor
        }
    }
    @IBOutlet weak var priceHTLabel: UILabel! {
        didSet {
//            self.priceHTLabel?.backgroundColor = blueCheckedColor
//            self.priceHTLabel?.tintColor = whiteColor
        }
    }
    @IBOutlet weak var priceTTLabel: UILabel! {
        didSet {
//            self.priceTTLabel?.backgroundColor = blueCheckedColor
//            self.priceTTLabel?.tintColor = whiteColor
        }
    }
    @IBOutlet weak var totalQuotesTTCLabel: UILabel!
    // MARK: - Variables
    var contrats: [ContratModel] = []
    var idOpportunity: Int!
    var contratSelected: ContratModel! {
        didSet {
            self.quoteNumberLabel?.text = contratSelected.nameContrat
            self.startDateQuoteLabel?.text = contratSelected.startDateContrat
            self.expireOnQuoteLabel?.text = contratSelected.expiresOnContrat
            self.totalAmountDiscountQuoteLabel?.text = contratSelected.totalAmountDiscountContrat
            self.totalPercentageDiscountQuoteLabel?.text = contratSelected.totalPercentageDiscountContrat
            self.statusQuoteLabel?.text = contratSelected.statusContrat
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if idOpportunity != nil {
            contrats = OpportunityQuotesAPI().getContratsFromIdOpportunity(idOpportunity: idOpportunity)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            listQuotesTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
            tableView(self.listQuotesTableView, didSelectRowAtIndexPath: indexPath)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OpportunityQuotesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == listQuotesTableView {
            return "Quote list"
        } else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == listQuotesTableView {
            if contrats.count != 0 {
                contratSelected = contrats[indexPath.row]
                self.quoteNumberLabel?.text = contratSelected.nameContrat
                self.startDateQuoteLabel?.text = contratSelected.startDateContrat
                self.expireOnQuoteLabel?.text = contratSelected.expiresOnContrat
                self.totalAmountDiscountQuoteLabel?.text = contratSelected.totalAmountDiscountContrat + "€"
                self.totalPercentageDiscountQuoteLabel?.text = contratSelected.totalPercentageDiscountContrat + "%"
                self.statusQuoteLabel?.text = contratSelected.statusContrat
            }
        }
    }
}

extension OpportunityQuotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let cell = UITableViewCell()
        if tableView == listQuotesTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell opportunity quotes", forIndexPath: indexPath) as! OpportunityQuotesTableViewCell
            cell.quoteNumberLabel.text = contrats[row].nameContrat
            cell.statusQuoteLabel.text = contrats[row].statusContrat
            
            return cell
        } else if tableView == listProductsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell product for quote", forIndexPath: indexPath) as! ProductTableViewCell
            cell.productLabel.text = "PDTA"
            cell.listUnitPriceLabel.text = "15"
            cell.quantityLabel.text = "2"
            cell.priceHTLabel.text = "30 k€"
            cell.priceTTLabel.text = "32,5 k€"
            
            return cell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listQuotesTableView {
            return contrats.count
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == listQuotesTableView {
            return 1
        } else {
            return 1
        }
    }
}