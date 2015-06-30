//
//  DetailsViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 25/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfAccountViewController: UIViewController {
    private let TabBarButtonTitles = ["Meetings", "Dashboard", "Contacts", "Activities", "Pipeline", "Account Details"]
    
    private let viewControllerIdentifiers = ["Meetings of account", "Vue360 of account", "Contacts of account", "Activities of account", "Pipeline of account", "Details of account"]
    
    @IBOutlet var tabBarButtons: [UIButton]! { didSet {
        var i = 0
        // name the buttons and add their action (goPage:)
        for button in tabBarButtons {
            button.setTitle(TabBarButtonTitles[i], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("goPage:"), forControlEvents: UIControlEvents.TouchUpInside)
            button.backgroundColor = blueUncheckedColor
            i++
        }
        }}
    
    @IBOutlet var homeBarButton: UIBarButtonItem! { didSet {
        navigationItem.leftBarButtonItems?.append(homeBarButton)
        }}
    @IBOutlet var menuBarButton: UIBarButtonItem! { didSet {
        navigationItem.leftBarButtonItems?.append(menuBarButton)
        }}
    @IBOutlet weak var nameAccount: UILabel!{ didSet {
        if account != nil {
            nameAccount.text = account.nameAccount
        }
        }}
    @IBOutlet weak var addressAccount: UILabel!{ didSet {
        if account != nil {
            addressAccount.text = account.adressAccount
        }
        }}
    @IBOutlet weak var imageAccount: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var shownPage = 1
    
    var account: AccountsModel! {
        didSet {
            account = DetailsOfAccountAPI.sharedInstance.getWholeAccountFromAccount(account)
            addressAccount?.text = account.adressAccount
            nameAccount?.text = account.nameAccount
        }
    }
    
    // MARK: - ViewControllerLifeCycle
    private var viewControllers: [UIViewController] = []
    private var viewsOfViewControllers: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if account == nil {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let idAccount = defaults.integerForKey(UserDefaults.Account)
            if idAccount != 0 {
                account = AccountsModel(idAccount: idAccount, elementsOfAccount: nil)
                defaults.removeObjectForKey(UserDefaults.Account)
            }
            if account == nil {
                account = DetailsOfAccountAPI.sharedInstance.getFirstAccountToShow()
                if account == nil {
                    let alert = UIAlertController(title: "No account found", message: "Please contact your administrator", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Back home", style: .Destructive, handler: { alert in
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alert.addAction(action)
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        viewControllers = createViewControllers()
        viewsOfViewControllers = getViewsFromViewControllers(viewControllers)
        pageControl.numberOfPages = viewControllers.count
        
        let url = NSURL(string: account.logoUrlAccount)
        let qos = Int(DISPATCH_QUEUE_PRIORITY_DEFAULT.value)
        let queue = dispatch_get_global_queue(qos, 0)
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.startAnimating()
        imageAccount.addSubview(activityIndicator)
        activityIndicator.center = imageAccount.center
        dispatch_async(queue,{
            let data = NSData(contentsOfURL: url!)
            
            
            dispatch_async(dispatch_get_main_queue(), {
                if let data = data {
                    self.imageAccount.image = UIImage(data: data)
                    activityIndicator.stopAnimating()
                }
                
            })
            
        })
        
    }
    
    func createViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[0]) as? MeetingsOfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[01]) as? Vue360OfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[02]) as? ContactsOfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[03]) as? ActivitiesOfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[04]) as? PipelineOfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[05]) as? SubDetailsOfAccountViewController {
            viewController.account = self.account
            viewControllers.append(viewController)
        }
        return viewControllers
    }
    func getViewsFromViewControllers(viewControllers: [UIViewController]) -> [UIView] {
        var views: [UIView] = []
        for viewControllers in viewControllers {
            views.append(viewControllers.view)
        }
        return views
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var didShowInitialView = false
    override func viewDidLayoutSubviews() {
        loadPages(viewsOfViewControllers)
        if !didShowInitialView {
            didShowInitialView = true
            showPage(shownPage)
        }
    }
    
    @IBOutlet weak var containerForDetails: ContainerForAccountDetails!{didSet{containerForDetails.delegate = self}}
    func loadPages(views: [UIView]) {
        let pageSize = containerForDetails.bounds
        var pageBoundsForViews = pageSize
        var i = 0
        for page in views {
            pageBoundsForViews.origin.x = CGFloat(i) * pageSize.width
            page.frame = pageBoundsForViews
            containerForDetails.addSubview(page)
            i++
        }
        
        containerForDetails.contentSize = CGSize(width: pageSize.width * CGFloat(views.count), height: pageSize.height)
    }
    
    // MARK: - show a specific page
    func showPage(index: Int) {
        let pageSize = containerForDetails.bounds
        let xContentOffset = pageSize.width * CGFloat(index)
        containerForDetails.setContentOffset(CGPoint(x: xContentOffset, y: 0), animated: false)
    }
    // MARK: - MasterDetail actions
    @IBOutlet weak var languetteGauche: UIButton!
    var masterShown = false { didSet {
        if masterShown {
            languetteGauche.setImage(UIImage(named: "LanguetteFermeture"), forState: .Normal)
        } else {
            languetteGauche.setImage(UIImage(named: "LanguetteGauche"), forState: .Normal)
        }
        }}
    @IBAction func barButtonShowMaster(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        masterShown = !masterShown
    }
    @IBAction func buttonShowMaster(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
        masterShown = !masterShown
    }
    
    // MARK: TabBarButton Actions
    @IBAction func goPage(sender: UIButton) {
        if let index = find(tabBarButtons, sender) {
            showPage(index)
        }
    }
    
    private struct segueIdentifiers {
        static let showWebsiteAccount = "show web site of account"
        static let showMapOfAccount = "show location of account"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.showWebsiteAccount {
            if let destinationViewController = segue.destinationViewController.topViewController as? WebsiteOfAccountViewController {
                var maximumSize = destinationViewController.view.systemLayoutSizeFittingSize(UILayoutFittingExpandedSize)
                maximumSize.width = 1000
                maximumSize.height = 1000
                destinationViewController.preferredContentSize = maximumSize
                destinationViewController.url = NSURL(string: account.websiteAccount)
            }
        }
        if segue.identifier == segueIdentifiers.showMapOfAccount {
            if let destinationVC = segue.destinationViewController.topViewController as? mapPositionOfAccountViewController {
                destinationVC.account = account
                let size = CGSizeMake(320, 320)
                destinationVC.preferredContentSize = size
            }
        }
    }
}

extension DetailsOfAccountViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2 + pageWidth)/(pageWidth*2)))
        colorButton(page)
        pageControl.currentPage = page
        shownPage = page
    }
    
    func colorButton(index: Int) {
        tabBarButtons[shownPage].backgroundColor = blueUncheckedColor
        tabBarButtons[index].backgroundColor = blueCheckedColor
        shownPage = index
    }
}