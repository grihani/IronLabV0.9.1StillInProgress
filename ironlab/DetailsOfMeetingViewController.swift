//
//  DetailsOfMeetingViewController.swift
//  IronLab
//
//  Created by CSC CSC on 11/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfMeetingViewController: UIViewController {
    
    let dateFormatter = NSDateFormatter()
    
    private let TabBarButtonTitles = ["Meeting's details", "360° View", "Participants", "Attachments", "Action plan"]
    
    private let viewControllerIdentifiers = ["details of meeting", "vue 360 of account of meeting", "participants of meeting", "attachments of meeting", "action plan of meeting"]
    
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
    
    @IBOutlet var reportBarButton: UIBarButtonItem! { didSet {
        navigationItem.rightBarButtonItems?.append(reportBarButton)
        }}
    @IBOutlet var homeBarButton: UIBarButtonItem! { didSet {
        navigationItem.leftBarButtonItems?.append(homeBarButton)
        }}
    @IBOutlet var menuBarButton: UIBarButtonItem! { didSet {
        navigationItem.leftBarButtonItems?.append(menuBarButton)
        }}
    
    @IBOutlet weak var imageAccount: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var shownPage = 0
    
    // MARK: - Models
    
    var meeting: MeetingsModel! {
        didSet {
            meeting = DetailsOfMeetingAPI.sharedInstance.getMeetingDetails(meeting)
            updateUI()
        }
    }
    
    var account: AccountsModel! {
        didSet {
            if account != nil {
                println("passage2")
                accountName?.text = account.nameAccount
            }
        }
    }
    
    func updateUI() {
        meetingSubject?.text = meeting.subjectMeeting
        meetingObjective?.text = meeting.descriptionMeeting
        meetingDate?.text = translateDates(meeting.dateBeginMeeting)
        if account != nil {
            println("passage")
            accountName?.text = account.nameAccount
        }
    }
    // MARK: - ViewControllerLifeCycle
    private var viewControllers: [UIViewController] = []
    private var viewsOfViewControllers: [UIView] = []
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        println(meeting)
        if meeting == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            let idMeeting = defaults.integerForKey(UserDefaults.Meeting)
            if idMeeting != 0 {
                self.meeting = MeetingsModel(idMeeting: idMeeting, elementsOfMeeting: nil)
                defaults.removeObjectForKey(UserDefaults.Meeting)
            }
            if meeting == nil {
                let nextMeeting = DetailsOfMeetingAPI.sharedInstance.getNextMeeting()
                if nextMeeting == nil {
                    let alert = UIAlertController(title: "No account found", message: "Please contact your administrator", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Back home", style: .Destructive, handler: { alert in
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alert.addAction(action)
                    presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    meeting = nextMeeting
                }
            }
        }
        
        println(meeting)
        account = DetailsOfMeetingAPI.sharedInstance.getAccountOfMeeting(meeting)
        println(account)
        updateUI()
        viewControllers = createViewControllers()
        viewsOfViewControllers = getViewsFromViewControllers(viewControllers)
        pageControl.numberOfPages = viewControllers.count
        
        colorButton(shownPage)
    }
    

    func createViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[0]) as? SubDetailsOfMeetingViewController {
            viewController.meeting = meeting
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[01]) as? Vue360OfAccountOfMeetingViewController {
            viewController.account = account
            viewController.meeting = meeting
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[02]) as? ParticipantsOfMeetingViewController {
            viewController.meeting = meeting
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[03]) as? AttachmentsOfMeetingViewController {
            viewController.meeting = meeting
            viewControllers.append(viewController)
        }
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[04]) as? TaskViewController {
            viewController.meeting = meeting
            viewController.account = account
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println(self.getHomePageViewController())
        println(self.presentingViewController?.contentViewController)
        println(self.presentingViewController)
        println(self.presentingViewController?.presentingViewController)
    }
    
    private var didShowInitialView = false
    override func viewDidLayoutSubviews() {
        loadPages(viewsOfViewControllers)
        if !didShowInitialView {
            didShowInitialView = true
            showPage(shownPage)
        }
    }
    
    // MARK: - Calculate pages size
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
    // MARK: - ShowMaster IBActions
    @IBOutlet var languetteGauche: UIButton!
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
    
    // MARK: - Interface elements
    
    @IBOutlet var meetingImage: UIImageView!
    @IBOutlet var meetingSubject: UILabel!
    @IBOutlet var accountName: UILabel!
    @IBOutlet var meetingObjective: UILabel!
    @IBOutlet var meetingDate: UILabel!
    @IBOutlet var disableEnable: UIButton!
    @IBAction func stopUserInteraction(sender: UIButton) {
        containerForDetails.scrollEnabled = !containerForDetails.scrollEnabled
        if containerForDetails.scrollEnabled {
            disableEnable.setImage(UIImage(named: "enableGesture"), forState: .Normal)
        } else {
            disableEnable.setImage(UIImage(named: "disableTouch"), forState: .Normal)
        }
    }
    
    // MARK: - compte rendu
    
    
    @IBAction func generateCR(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SegueIdentifiers.CallReport, sender: sender)
    }
    
    // MARK: - Navigation
    
    private struct SegueIdentifiers {
        static let CallReport = "show CR"
        static let MapOfMeeting = "show location of meeting"
        static let AccountOfMeeting = "show account of meeting"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.CallReport {
            if let destinationViewController = segue.destinationViewController as? CallReportViewController {
                destinationViewController.meeting = self.meeting
            }
        }
        if segue.identifier == SegueIdentifiers.MapOfMeeting {
            if let destinationVC = segue.destinationViewController.topViewController as? LocationOfMeetingViewController {
                destinationVC.meeting = meeting
                destinationVC.preferredContentSize = CGSizeMake(400, 400)
            }
        }
        if segue.identifier == SegueIdentifiers.AccountOfMeeting {
            if let destinationVC = segue.destinationViewController as? SWRevealViewController {
                let defaults = NSUserDefaults.standardUserDefaults()
                println(account.idAccount)
                defaults.setInteger(account.idAccount, forKey: UserDefaults.Account)
            }
        }
        
    }
    
    
    @IBAction func returnBackHome(sender: UIBarButtonItem) {
        if self.getHomePageViewController() is HomePageV2ViewController {
        self.getHomePageViewController().dismissViewControllerAnimated(false, completion: nil)
        } else {
            self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

extension DetailsOfMeetingViewController: UIScrollViewDelegate {
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

extension DetailsOfMeetingViewController {
    
    func translateDates(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
