//
//  ContactsOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ContactsOfAccountViewController: UIViewController {

    var account: AccountsModel!
    var contacts: [ContactsModel] {
        return DetailsOfAccountAPI.sharedInstance.getContactsOfAccount(account)
    }
    
    @IBOutlet weak var contactsOfAccountTableView: UITableView! {didSet {
        contactsOfAccountTableView.dataSource = self
        contactsOfAccountTableView.delegate = self
    }}
    
    var selectedContact: ContactsModel! {
        didSet {
            selectContact(selectedContact)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsOfAccountTableView.estimatedRowHeight = contactsOfAccountTableView.rowHeight
        contactsOfAccountTableView.rowHeight = UITableViewAutomaticDimension
        if contacts.count > 0 {
            selectedContact = contacts[0]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Selected Contact
    
    @IBOutlet var adressOfContactInMeeting: UILabel!
    @IBOutlet var languageOfContactInMeeting: UILabel!
    @IBOutlet var telecopieOfContactInMeeting: UILabel!
    @IBOutlet var serviceOfContactInMeeting: UILabel!
    @IBOutlet var functionOfContactInMeeting: UILabel!
    @IBOutlet var emailOfContactInMeeting: UILabel!
    @IBOutlet var workingPhoneOfContactInMeeting: UILabel!
    @IBOutlet var mobilePhoneOfContactInMeeting: UILabel!
    
    
    
    func selectContact(contact: ContactsModel) {
        adressOfContactInMeeting.text = contact.workingAdressContact
        languageOfContactInMeeting.text = contact.preferredLanguageContact
        serviceOfContactInMeeting.text = contact.jobTitleContact
        functionOfContactInMeeting.text = contact.typeContact
        emailOfContactInMeeting.text = contact.emailContact
        workingPhoneOfContactInMeeting.text = contact.phoneBusinessContact
        mobilePhoneOfContactInMeeting.text = contact.phoneMobileContact
        telecopieOfContactInMeeting.text = "--"
    }
}

extension ContactsOfAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    private struct CellIdentifiers {
        static let nameAndSurname = "cell for contacts of account"
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.nameAndSurname, forIndexPath: indexPath) as! ContactsOfAccountTableViewCell
        let row = indexPath.row
        let nameAndSurnameContact = contacts[row].firstNameContact + " " + contacts[row].lastNameContact
        cell.nameAndSurnameContact.text = nameAndSurnameContact
        cell.jobDescriptionContact.text = contacts[row].jobTitleContact
        if contacts[row].favoriteContact == 1 {
            cell.favoriteContact.image = UIImage(named: "Favorites")
        }
        return cell
    }
}

extension ContactsOfAccountViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContact = contacts[indexPath.row]
    }
}
