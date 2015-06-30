//
//  OpportunityDetailsViewController.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class OpportunityDetailsViewController: UIViewController {
    
    // MARK: - Liste Phase Opportunity
    @IBOutlet weak var phaseOpportunityView: UIView!
    @IBOutlet weak var phase1: UIButton!
//    {
//        didSet {
//            if let opportunity = opportunity {
//                if opportunity.statusOpportunity == "Closed/Won" {
//                    self.phase1?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Closed/Lost" {
//                    self.phase1?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Draft" {
//                    self.phase1?.enabled = true
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase1?.enabled = false
//                }
//            }
//        }
//    }
    @IBOutlet weak var phase2: UIButton!
//    {
//        didSet {
//            if let opportunity = opportunity {
//                if opportunity.statusOpportunity == "Closed/Won" {
//                    self.phase2?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Closed/Lost" {
//                    self.phase2?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Draft" {
//                    self.phase2?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase2?.enabled = false
//                }
//            }
//        }
//    }
    @IBOutlet weak var phase3: UIButton!
//    {
//        didSet {
//            if let opportunity = opportunity {
//                if opportunity.statusOpportunity == "Closed Won" {
//                    self.phase3?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Closed Lost" {
//                    self.phase3?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Draft" {
//                    self.phase3?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase3?.enabled = true
//                }
//            }
//        }
//    }
    @IBOutlet weak var phase4: UIButton!
//    {
//        didSet {
//            if let opportunity = opportunity {
//                if opportunity.statusOpportunity == "Closed Won" {
//                    self.phase4?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Closed Lost" {
//                    self.phase4?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Draft" {
//                    self.phase4?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase4?.enabled = false
//                }
//            }
//        }
//    }
    @IBOutlet weak var phase5: UIButton!
//    {
//        didSet {
//            if let opportunity = opportunity {
//                if opportunity.statusOpportunity == "Closed Won" {
//                    self.phase5?.enabled = true
//                    self.phase5?.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Win"), forState: UIControlState.Normal)
//                    self.phase5?.setTitle(opportunity.statusOpportunity.uppercaseString, forState: UIControlState.Normal)
//                }
//                if opportunity.statusOpportunity == "Closed Lost" {
//                    self.phase5?.enabled = true
//                    self.phase5?.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Lost"), forState: UIControlState.Normal)
//                    self.phase5?.setTitle(opportunity.statusOpportunity.uppercaseString, forState: UIControlState.Normal)
//                }
//                if opportunity.statusOpportunity == "Draft" {
//                    self.phase5?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase5?.enabled = false
//                }
//            }
//        }
//    }
    
    // MARK: - Label Definition
    @IBOutlet weak var idOpportunityLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.idOpportunityLabel.text = "\(opportunity.idOpportunity)"
            }
        }
    }
    @IBOutlet weak var salesRepLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.salesRepLabel.text = opportunity.ownerOpportunity
            }
        }
    }
    @IBOutlet weak var contactLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.contactLabel.text = opportunity.relatedContactOpportunity
            }
        }
    }
    @IBOutlet weak var probabilityLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.probabilityLabel.text = "\(opportunity.probabilityOpportunity)%"
            }
        }
    }
    @IBOutlet weak var potentialAmountLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.potentialAmountLabel.text = "\(opportunity.potentialAmountOpportunity)€"
            }
        }
    }
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.amountLabel.text = "\(opportunity.amountOpportunity)€"
            }
        }
    }
    @IBOutlet weak var competitorsLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.competitorsLabel.text = opportunity.competitorsOpportunity
            }
        }
    }
    @IBOutlet weak var typeLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.typeLabel.text = opportunity.typeOpportunity
            }
        }
    }
    @IBOutlet weak var opportunityTeamLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.opportunityTeamLabel.text = opportunity.teamOpportunity
            }
        }
    }
    @IBOutlet weak var expectedCloseDateLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.expectedCloseDateLabel.text = opportunity.expectedCloseDateOpportunity
            }
        }
    }
    @IBOutlet weak var campaignSourceLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.campaignSourceLabel.text = opportunity.campaignSourceOpportunity
            }
        }
    }
    @IBOutlet weak var priorityLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.priorityLabel.text = opportunity.priorityOpportunity
            }
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            if let opportunity = opportunity {
                self.descriptionTextView.text = opportunity.descriptionOpportunity
            }
            self.descriptionTextView.layer.borderWidth = 1
            self.descriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.descriptionTextView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var accountContextTextView: UITextView! {
        didSet {
            if let opportunity = opportunity {
                self.accountContextTextView.text = opportunity.accountContextOpportunity
            }
            self.accountContextTextView.layer.borderWidth = 1
            self.accountContextTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.accountContextTextView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var rolePropositionTextView: UITextView! {
        didSet {
            if let opportunity = opportunity {
                self.rolePropositionTextView.text = opportunity.rolePropositionOpportunity
            }
            self.rolePropositionTextView.layer.borderWidth = 1
            self.rolePropositionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.rolePropositionTextView.layer.cornerRadius = 8
        }
    }
    // MARK: - Variables
    var opportunity: OpportunityModel! {
        didSet {
            if opportunity != nil {
                self.idOpportunityLabel?.text = "\(opportunity.idOpportunity)"
                self.salesRepLabel?.text = opportunity.ownerOpportunity
                self.contactLabel?.text = opportunity.relatedContactOpportunity
                self.probabilityLabel?.text = "\(opportunity.probabilityOpportunity)%"
                self.potentialAmountLabel?.text = "\(opportunity.potentialAmountOpportunity)€"
                self.amountLabel?.text = "\(opportunity.amountOpportunity)€"
                self.competitorsLabel?.text = opportunity.competitorsOpportunity
                self.typeLabel?.text = opportunity.typeOpportunity
                self.opportunityTeamLabel?.text = opportunity.teamOpportunity
                self.expectedCloseDateLabel?.text = opportunity.expectedCloseDateOpportunity
                self.campaignSourceLabel?.text = opportunity.campaignSourceOpportunity
                self.priorityLabel?.text = opportunity.priorityOpportunity
                self.descriptionTextView?.text = opportunity.descriptionOpportunity
                self.descriptionTextView?.layer.borderWidth = 2
                self.descriptionTextView?.layer.borderColor = UIColor.grayColor().CGColor
                self.descriptionTextView?.layer.cornerRadius = 8
                self.accountContextTextView?.text = opportunity.accountContextOpportunity
                self.accountContextTextView?.layer.borderWidth = 2
                self.accountContextTextView?.layer.borderColor = UIColor.grayColor().CGColor
                self.accountContextTextView?.layer.cornerRadius = 8
                self.rolePropositionTextView?.text = opportunity.rolePropositionOpportunity
                self.rolePropositionTextView?.layer.borderWidth = 2
                self.rolePropositionTextView?.layer.borderColor = UIColor.grayColor().CGColor
                self.rolePropositionTextView?.layer.cornerRadius = 8
//                if opportunity.statusOpportunity == "Closed/Won" {
//                    self.phase1?.enabled = false
//                    self.phase2?.enabled = false
//                    self.phase3?.enabled = false
//                    self.phase4?.enabled = false
//                    self.phase5?.enabled = true
//                    self.phase5?.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Win"), forState: UIControlState.Normal)
//                    self.phase5?.setTitle(opportunity.statusOpportunity.uppercaseString, forState: UIControlState.Normal)
//                }
//                if opportunity.statusOpportunity == "Closed/Lost" {
//                    self.phase1?.enabled = false
//                    self.phase2?.enabled = false
//                    self.phase3?.enabled = false
//                    self.phase4?.enabled = false
//                    self.phase5?.enabled = true
//                    self.phase5?.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Lost"), forState: UIControlState.Normal)
//                    self.phase5?.setTitle(opportunity.statusOpportunity.uppercaseString, forState: UIControlState.Normal)
//                }
//                if opportunity.statusOpportunity == "Draft" || opportunity.statusOpportunity == "Identification" {
//                    self.phase1?.enabled = true
//                    self.phase2?.enabled = false
//                    self.phase3?.enabled = false
//                    self.phase4?.enabled = false
//                    self.phase5?.enabled = false
//                }
//                if opportunity.statusOpportunity == "Send" {
//                    self.phase1?.enabled = false
//                    self.phase2?.enabled = false
//                    self.phase3?.enabled = true
//                    self.phase4?.enabled = false
//                    self.phase5?.enabled = false
//                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if opportunity.statusOpportunity == "Closed/Won" {
            phase5.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Win"), forState: .Normal)
            phase5.setTitle(opportunity.statusOpportunity.uppercaseString, forState: .Normal)
            phase5.enabled = true
        }
        if opportunity.statusOpportunity == "Draft" || opportunity.statusOpportunity == "Identification" {
            phase1.enabled = true
        }
        if opportunity.statusOpportunity == "Closed/Lost" {
            phase5.setBackgroundImage(UIImage(named: "Arrière plans boutons phase opportunity Lost"), forState: .Normal)
            phase5.setTitle(opportunity.statusOpportunity.uppercaseString, forState: .Normal)
            phase5.enabled = true
        }
        if opportunity.statusOpportunity == "Qualification" {
            phase2.enabled = true
        }
        if opportunity.statusOpportunity == "Proposal" {
            phase3.enabled = true
        }
        if opportunity.statusOpportunity == "Post proposal" {
            phase4.enabled = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
