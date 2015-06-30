//
//  ParticipantsOfMeetingViewController.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ParticipantsOfMeetingViewController: UIViewController {

    var meeting: MeetingsModel!
    
    var participantsToMeeting: [ContactsModel] {
        return DetailsOfMeetingAPI.sharedInstance.getContactsOfMeeting(meeting)
    }
    @IBOutlet var participantsTableView: UITableView! {
        didSet {
            participantsTableView.dataSource = self
            participantsTableView.estimatedRowHeight = participantsTableView.rowHeight
            participantsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        participantsTableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        participantsTableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ParticipantsOfMeetingViewController: UITableViewDataSource {
    private struct CellIdentifiers {
        static let Participants = "participants"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Participants, forIndexPath: indexPath) as! ParticipantsToMeetingTableViewCell
        
        let row = indexPath.row
        let participant = participantsToMeeting[row]
        let nameAndSurnameParticipant = participant.lastNameContact + " " + participant.firstNameContact
        cell.nameAndSurnameLabel.text = nameAndSurnameParticipant
        cell.jobLabel.text = participant.jobTitleContact
//        cell.accountLabel.text = 
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantsToMeeting.count
    }
}
