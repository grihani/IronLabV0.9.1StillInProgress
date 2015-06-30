//
//  AddParticipantsToMeetingOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 27/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class AddParticipantsToMeetingOfAccountViewController: UIViewController {

    var account: AccountsModel!
    var contacts: [ContactsModel]! {
        return DetailsOfAccountAPI.sharedInstance.getContactsOfAccount(account)
    }
    var allContactsToAdd: [ContactsModel]! {
        return DetailsOfAccountAPI.sharedInstance.getAllContacts()
    }
    var meeting : MeetingsModel!
    
    var participantsOfMeeting: [ContactsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var accountsContacts: UITableView! {
        didSet {
            accountsContacts.dataSource = self
            accountsContacts.editing = true
            accountsContacts.allowsSelectionDuringEditing = true
        }
    }

    @IBOutlet weak var allContacts: UITableView!{
        didSet {
            allContacts.dataSource = self
            allContacts.editing = true
            allContacts.allowsSelectionDuringEditing = true
        }
    }
    @IBOutlet weak var accountsContactsBarButtonItem: UIBarButtonItem! {
        didSet {
            accountsContactsBarButtonItem.enabled = false
        }
    }
    @IBOutlet weak var allContactsBarButtonItem: UIBarButtonItem!
    var enableBarButtonItems = true {
        didSet {
            accountsContactsBarButtonItem?.enabled = !enableBarButtonItems
            allContactsBarButtonItem?.enabled = enableBarButtonItems
        }
    }
    @IBAction func showAllContacts(sender: UIBarButtonItem) {
        UIView.transitionFromView(accountsContacts, toView: allContacts, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom | .ShowHideTransitionViews, completion: nil)
        enableBarButtonItems = !enableBarButtonItems
    }
    @IBAction func showAccountContacts(sender: UIBarButtonItem) {
        UIView.transitionFromView(allContacts, toView: accountsContacts, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom | .ShowHideTransitionViews, completion: nil)
        enableBarButtonItems = !enableBarButtonItems
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addParticipants(sender: UIButton) {
        println(presentingViewController)
         println(presentingViewController?.presentingViewController)
    }
    
}

extension AddParticipantsToMeetingOfAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == accountsContacts {
            return contacts.count
        }
        else if tableView == allContacts {
            return allContactsToAdd.count
        }
        return 0
    }
    private struct cellIdentifiers {
        static let AccountsContacts = "cell for contacts of account"
        static let allContacts = "cell for all contacts"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == accountsContacts {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.AccountsContacts, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = contacts[indexPath.row].firstNameContact + " " + contacts[indexPath.row].lastNameContact
            return cell
        }
        else if tableView == allContacts {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.allContacts, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = allContactsToAdd[indexPath.row].firstNameContact + " " + allContactsToAdd[indexPath.row].lastNameContact
            return cell
        }
        return UITableViewCell()
    }
}

extension AddParticipantsToMeetingOfAccountViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected")
        participantsOfMeeting.append(contacts[indexPath.row])
        println(participantsOfMeeting)
        if accountsContacts.editing {
            let selectedRow = accountsContacts.indexPathsForSelectedRows()
            println(selectedRow)
        }
        if allContacts.editing {
            let selectedRow = allContacts.indexPathsForSelectedRows()
            println(selectedRow)
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("selected")
        participantsOfMeeting.append(contacts[indexPath.row])
        println(participantsOfMeeting)
    }
}
