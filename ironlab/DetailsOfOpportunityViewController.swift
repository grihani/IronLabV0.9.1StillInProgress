//
//  DetailsOfOpportunityViewController.swift
//  IronLab
//
//  Created by Formation iOS on 01/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class DetailsOfOpportunityViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - BarButton Definition
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet var createOpportunityButton: UIBarButtonItem!
    @IBOutlet var homeButton: UIBarButtonItem!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    @IBOutlet var opportunityStatus: UILabel!
    // MARK: - BarButton Actions
    @IBAction func createOpportunity(sender: UIBarButtonItem) {
    }
    @IBAction func goHome(sender: UIBarButtonItem) {
        self.presentingViewController?.contentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func displayMenu(sender: UIBarButtonItem) {
//        performSegueWithIdentifier("show Menu", sender: sender)
    }
    // MARK: - Region Static Definition
    @IBOutlet weak var showList: UIView!
    @IBOutlet weak var logoOpportunity: UIImageView! {
        didSet {
            if let opportunity = opportunity {
                var imageStatusOpportunity: UIImage!
                if opportunity.statusOpportunity == "Closed Won" {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_Win_64")
                    logoOpportunity.image = imageStatusOpportunity
                } else if opportunity.statusOpportunity == "Closed Lost" {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_Lost_64")
                    logoOpportunity.image = imageStatusOpportunity
                } else {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_Draft_64")
                    logoOpportunity.image = imageStatusOpportunity
                }
            }
        }
    }
    @IBOutlet weak var opportunityNameLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                if opportunity.teamOpportunity != nil && opportunity.teamOpportunity != "" {
                    self.opportunityNameLabel.text = opportunity.nameOpportunity + " (\(opportunity.teamOpportunity))"
                } else {
                    self.opportunityNameLabel.text = opportunity.nameOpportunity
                }
                
            }
        }
    }
    @IBOutlet weak var accountNameLabel: UILabel! 
//    {
//        didSet{
//            accountNameLabel.text = account.nameAccount
//        }
//    }
    @IBOutlet weak var relatedAccountLabel: UILabel! {
        didSet {
            if let opportunity = opportunity {
                self.relatedAccountLabel.text = opportunity.relatedAccountOpportunity
            }
        }
    }
    @IBOutlet weak var eurosClassificationView: EurosClassificationView! {
        didSet {
            if let opportunity = opportunity {
                eurosClassificationView.potentialAmountOpportunity = opportunity.potentialAmountOpportunity
            }
        }
    }
    
    // MARK: - Onglet Definition
    @IBOutlet weak var ListButtonsForPages: UIView!
    @IBOutlet weak var lineUnderMenu: UIView! {
        didSet {
            lineUnderMenu.backgroundColor = blueCheckedColor
        }
    }
    @IBOutlet weak var containerView: UIScrollView! {
        didSet {
            containerView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.pageIndicatorTintColor = blueUncheckedColor
            pageControl.currentPageIndicatorTintColor = blueCheckedColor
        }
    }
    @IBOutlet var buttonPages: [UIButton] = []
    
    // MARK: - Variables
    var opportunity: OpportunityModel! {
        didSet {
            opportunity = DetailsOfOpportunityAPI.sharedInstance.getOpportunityParametersFrom(opportunity)
            if opportunity != nil {
                if opportunity.teamOpportunity != nil && opportunity.teamOpportunity != "" {
                    self.opportunityNameLabel?.text = opportunity.nameOpportunity + " (\(opportunity.teamOpportunity))"
                } else {
                    self.opportunityNameLabel?.text = opportunity.nameOpportunity
                }
                self.relatedAccountLabel?.text = opportunity.relatedAccountOpportunity
                self.eurosClassificationView?.potentialAmountOpportunity = opportunity.potentialAmountOpportunity
                var imageStatusOpportunity: UIImage!
                if opportunity.statusOpportunity == "Closed Won" {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_Win_64")
                    logoOpportunity?.image = imageStatusOpportunity
                } else if opportunity.statusOpportunity == "Closed Lost" {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_Lost_64")
                    logoOpportunity?.image = imageStatusOpportunity
                } else {
                    imageStatusOpportunity = UIImage(named: "Dollar_Coin_Stack_64")
                    logoOpportunity?.image = imageStatusOpportunity
                }
            }
        }
    }
    
    var account: AccountsModel {
        return DetailsOfOpportunityAPI.sharedInstance.getAccountOfOpportunity(opportunity)
    }
    
    var identifiers: [String] = ["Opportunity Details", "Meetings", "Activities", "Contacts", "Quotes"]
    var opportunityDetails: OpportunityDetailsViewController = OpportunityDetailsViewController()
    var opportunityActivities: OpportunityActivitiesViewController = OpportunityActivitiesViewController()
    var opportunityQuotes: OpportunityQuotesViewController = OpportunityQuotesViewController()
    var opportunityMeetings: UIViewController = UIViewController()
    var opportunityContacts: OpportunityContactsViewController = OpportunityContactsViewController()
    var pageControllers: [UIViewController] = []
    var pageViews: [UIView] = []
    var firstPage = 0
    
    var viewDidItsLayout: Bool = false
    
    // MARK: - View Life
    override func viewDidLoad() {
        super.viewDidLoad()
        println(opportunity)
        if opportunity == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            let idOpportunity = defaults.integerForKey(UserDefaults.Opportunity)
            if idOpportunity != 0 {
                self.opportunity = OpportunityModel(idOpportunity: idOpportunity, elementsOfOpportunity: nil)
                defaults.removeObjectForKey(UserDefaults.Opportunity)
            }
            if opportunity == nil {
                opportunity = DetailsOfOpportunityAPI().getOpportunityFirstClosingDate()
            }
        }
        self.eurosClassificationView?.potentialAmountOpportunity = opportunity.potentialAmountOpportunity
        opportunityStatus.text = opportunity.statusOpportunity
        createMenuButtons(identifiers, lastCreatedFrame: CGRectZero, view: ListButtonsForPages)
        
        colorButtons(firstPage)
        
        navigationBar.leftBarButtonItems?.append(self.createOpportunityButton)
        navigationBar.leftBarButtonItems?.append(self.homeButton)
        navigationBar.leftBarButtonItems?.append(self.menuButton)
        accountNameLabel.text = account.nameAccount
    }
    
    override func viewDidLayoutSubviews() {
        if !viewDidItsLayout {
            pageControllers = getViewControllers()
            pageViews = getViews(pageControllers)
            let pageCount = pageControllers.count
            loadVisiblePages(pageCount)
            pageControl.numberOfPages = pageCount
            
            showPage(firstPage)
            
            let pageScrollViewSize = containerView.frame.size
            containerView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageCount), height: pageScrollViewSize.height)
            var i: CGFloat = 0
            for button in buttonPages {
                button.frame.size.width = self.ListButtonsForPages.frame.size.width / CGFloat(buttonPages.count) - 8
                button.frame.origin.x = i * (button.frame.size.width + 8)
                i++
            }
            viewDidItsLayout = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // get all the viewControllers that have identifiers defined in var identifiers
    func getViewControllers() -> [UIViewController]{
        var viewControllers: [UIViewController] = [UIViewController]()
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifiers[0]) as? OpportunityDetailsViewController {
            viewControllers.append(viewController)
            viewController.opportunity = self.opportunity
            self.opportunityDetails = viewController
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifiers[1]) as? MeetingsOfAccountInOpportunityViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
            self.opportunityMeetings = viewController
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifiers[2]) as? OpportunityActivitiesViewController {
            viewControllers.append(viewController)
            viewController.idOpportunity = self.opportunity.idOpportunity
            self.opportunityActivities = viewController
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifiers[3]) as? OpportunityContactsViewController {
            viewController.account = account
            viewControllers.append(viewController)
            self.opportunityContacts = viewController
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifiers[4]) as? OpportunityQuotesViewController {
            viewControllers.append(viewController)
            viewController.idOpportunity = self.opportunity.idOpportunity
            self.opportunityQuotes = viewController
        }
        return viewControllers
    }
    
    // from the controllers that we set up earlier, we get their views and show them
    func getViews(viewControllers: [UIViewController]) -> [UIView] {
        var views: [UIView] = []
        for viewController in viewControllers {
            if let view = viewController.view as UIView? {
                views.append(view)
            }
        }
        return views
    }
    
    // load the pages that we want shown
    func loadVisiblePages(numberOfPages: Int) {
        let pageSize = containerView.bounds
        var pageBoundsForViews = pageSize
        
        for i in 0..<numberOfPages {
            pageBoundsForViews.origin.x = CGFloat(i) * pageSize.width
            let newPageView = pageViews[i]
            newPageView.frame = pageBoundsForViews
            containerView.addSubview(newPageView)
        }
    }
    
    // action added to the buttons of the menu to show a specific page
    @IBAction func goPage(sender: UIButton) {
        let textLabel = sender.titleLabel?.text
        var index = find(buttonPages, sender)
        if let index = index {
            showPage(index)
        }
    }
    
    // show the page that we want seen and updates the pageControl's shown page
    func showPage(page: Int) {
        let  pageSize = containerView.bounds
        let xContentOffset = pageSize.width * CGFloat(page)
        containerView.setContentOffset(CGPoint(x: xContentOffset, y: 0), animated: false)
        firstPage = page
    }
    
    // delegate method of scrollview : called everytime the scrollView is scrolled and update the pageControl's shown page
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        colorButtons(page)
        pageControl.currentPage = page
        firstPage = page
        self.view.endEditing(true)
    }
    
    // creates the button to add to the view
    func buttonForPages(view: UIView) {
        let frame = view.frame
        var i = 0
        let width = CGFloat(100)
        for identifier in identifiers {
            
            let button = UIButton(frame: CGRect(x: CGFloat(i) * width, y: 0, width: 92, height: 37))
            button.setTitle(identifier, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("goPage:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.layer.cornerRadius = 8
            button.sizeToFit()
            view.addSubview(button)
            buttonPages.append(button)
            
            i++
        }
    }
    
    // colorier les boutons avec la couleur choisie
    func colorButtons(page:Int) {
        for button in buttonPages {
            button.backgroundColor = blueUncheckedColor
        }
        buttonPages[page].backgroundColor = blueCheckedColor
    }
    
    func createMenuButtons(menuTitles: [String], lastCreatedFrame: CGRect, view:UIView) {
        if menuTitles != [] {
            var menu = menuTitles
            var frame = lastCreatedFrame
            frame.origin.x = frame.origin.x + 8 + frame.size.width
            frame.size.height = 38
            let button = UIButton(frame: frame)
            let firstItemOfMenuTitles = menu.removeAtIndex(0)
            button.setTitle(firstItemOfMenuTitles, forState: .Normal)
            
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("goPage:"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(button)
            buttonPages.append(button)
            createMenuButtons(menu, lastCreatedFrame: button.frame, view: view)
        }
    }
    
    // MARK: - Actions of showing the Master
    @IBOutlet weak var languette: UIImageView!
    var leftListShown: Bool = false {
        didSet {
            if leftListShown {
                languette?.image = UIImage(named: "languetteFermeture")
            } else {
                languette?.image = UIImage(named: "languette gauche")
            }
        }
    }
    
    @IBAction func showList(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        if !leftListShown {
            leftListShown = true
        } else {
            leftListShown = false
        }
    }
    
    @IBAction func showListTapGestureRecognizer(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
        if !leftListShown {
            leftListShown = true
        } else {
            leftListShown = false
        }
    }
    
    private struct SegueIdentifiers {
        static let AccountOfOpp = "account of opportunity"
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.AccountOfOpp {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(account.idAccount, forKey: UserDefaults.Account)
            }
        }
    }
}