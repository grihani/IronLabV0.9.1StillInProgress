//
//  SubDetailsOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SubDetailsOfAccountViewController: UIViewController, XMLParserDelegate {

    var xmlParser : XMLParser!
    
    
    var account: AccountsModel! { didSet {
        idCRM?.text = String(account.idAccount)
        typeAccount?.text = account.typeAccount
        coverageAccount?.text = account.coverageAccount
        turnoverAccount?.text = account.turnoverAccount
        parentAccount?.text = DetailsOfAccountAPI.sharedInstance.findParentAccount(account)
        industryAccount?.text = account.industryAccount
        regionAccount?.text = account.regionAccount
        numberEmployeesAccount?.text = String(account.numberEmployeesAccount)
        websiteAccount?.text = account.websiteAccount
        phoneAccount?.text = account.phoneAccount
        addressAccount?.text = account.adressAccount
        
        
        }}
    
    @IBOutlet weak var idCRM: UILabel! { didSet {
        idCRM?.text = String(account.idAccount)
    }}
    @IBOutlet weak var typeAccount: UILabel! { didSet {
        typeAccount?.text = account.typeAccount
        }}
    @IBOutlet weak var coverageAccount: UILabel! { didSet {
        coverageAccount?.text = account.coverageAccount
        }}
    @IBOutlet weak var turnoverAccount: UILabel! { didSet {
        turnoverAccount?.text = account.turnoverAccount
        }}
    @IBOutlet weak var parentAccount: UILabel! { didSet {
        parentAccount?.text = DetailsOfAccountAPI.sharedInstance.findParentAccount(account)
        }}
    @IBOutlet weak var industryAccount: UILabel! { didSet {
        industryAccount?.text = account.industryAccount
        }}
    @IBOutlet weak var regionAccount: UILabel! { didSet {
        regionAccount?.text = account.regionAccount
        }}
    @IBOutlet weak var numberEmployeesAccount: UILabel! { didSet {
        numberEmployeesAccount?.text = String(account.numberEmployeesAccount)
        }}
    @IBOutlet weak var websiteAccount: UILabel! { didSet {
        websiteAccount?.text = account.websiteAccount
        }}
    @IBOutlet weak var phoneAccount: UILabel! { didSet {
        phoneAccount?.text = account.phoneAccount
        }}
    @IBOutlet weak var addressAccount: UILabel! { didSet {
        addressAccount?.text = account.adressAccount
        }}
    @IBOutlet weak var websiteAccountSub: UIButton!{ didSet {
        websiteAccountSub.setTitle(account.websiteAccount, forState: .Normal)
        }}
    
    @IBOutlet weak var phoneAccountSub: UILabel!{ didSet {
        phoneAccountSub?.text = account.phoneAccount
        }}
    @IBOutlet weak var addressAccountSub: UILabel!{ didSet {
        addressAccountSub?.text = account.adressAccount
        }}
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        var stringURL = "https://news.google.com/?output=rss&hl=fr&gl=fr&tbm=nws&authuser=0&q=\(account.nameAccount)&oq=\(account.nameAccount)"
        stringURL = stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: stringURL)
        xmlParser = XMLParser()
        xmlParser.delegate = self
        let qos = Int(DISPATCH_QUEUE_PRIORITY_HIGH)
        let queue = dispatch_get_global_queue(qos, 0)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        xmlTableView.addSubview(refreshControl)
        refreshControl.beginRefreshing()
        dispatch_async(queue, {
            self.xmlParser.startParsingWithContentsOfURL(url!)
            dispatch_async(dispatch_get_main_queue(), {
                refreshControl.endRefreshing()
                self.xmlTableView.reloadData()})
        })
        
        xmlTableView.estimatedRowHeight = xmlTableView.rowHeight
        xmlTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var xmlTableView: UITableView! {didSet {
        xmlTableView.dataSource = self
        }
    }
    
    func parsingWasFinished() {
        self.xmlTableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        xmlParser = XMLParser()
        var stringURL = "https://news.google.com/?output=rss&hl=fr&gl=fr&tbm=nws&authuser=0&q=\(account.nameAccount)&oq=\(account.nameAccount)"
        stringURL = stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: stringURL)
        let qos = Int(DISPATCH_QUEUE_PRIORITY_HIGH)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue, {
            self.xmlParser.startParsingWithContentsOfURL(url!)
            dispatch_async(dispatch_get_main_queue(), {
                refreshControl.endRefreshing()
                self.xmlTableView.reloadData()})
        })
    }
    
    private struct segueIdentifiers {
        static let showRssSegue = "show rss feed"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.showRssSegue {
            if let presentedViewController = segue.destinationViewController.topViewController as? RssFeedWebViewController {
                if let indexPath = self.xmlTableView.indexPathForSelectedRow() {
                    let dictionary = xmlParser.arrParsedData[indexPath.row + 1] as Dictionary<String, String>
                    let rssLink = dictionary["link"]!
                    presentedViewController.url = NSURL(string: rssLink)
                }
            }
        }
    }
}

extension SubDetailsOfAccountViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return xmlParser.arrParsedData.count - 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}

