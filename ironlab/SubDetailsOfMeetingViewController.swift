//
//  SubDetailsOfMeetingViewController.swift
//  IronLab
//
//  Created by CSC CSC on 12/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class SubDetailsOfMeetingViewController: UIViewController {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateBegin: UILabel!
    @IBOutlet weak var salesRep: UILabel!
    @IBOutlet weak var notesMeeting: UITextView! {
        didSet {
            notesMeeting.delegate = self
        }
    }
    @IBOutlet weak var objectivesMeeting: UITextView!{
        didSet {
            objectivesMeeting.delegate = self
        }
    }
    
    @IBOutlet var textFieldAgendaItem: UITextField! {
        didSet {
            textFieldAgendaItem.delegate = self
        }
    }
    @IBOutlet weak var agendaMeeting: UITableView! {
        didSet {
            agendaMeeting.dataSource = self
            agendaMeeting.delegate = self
            agendaMeeting.estimatedRowHeight = agendaMeeting.rowHeight
            agendaMeeting.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var containerForMeetingAgenda: UIView!
    var updateItemInAgenda = false
    // MARK: - Models
    var meeting: MeetingsModel! {
        didSet {
            updateUI()
        }
    }
    
    var agendaItemToUpdate: AgendaMeetingModel! {
        didSet {
            updateItemInAgenda = true
        }
    }
    // MARK: - Compounded model
    
    var agendaOfMeeting: [AgendaMeetingModel] {
        return DetailsOfMeetingAPI.sharedInstance.getAgendaOfMeeting(meeting)
    }
    
    // MARK: - updateUI
    func updateUI() {
        if let meeting = meeting {
            location?.text = meeting.adressMeeting
            dateBegin?.text = meeting.dateBeginMeeting
            salesRep?.text = meeting.dateEndMeeting
            notesMeeting?.text = meeting.notesMeeting
            objectivesMeeting?.text = meeting.agendaMeeting
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let observer = cookieForKeyboardAppears {
            center.removeObserver(observer)
        }
        if let observer = cookieForKeyboardDisappears {
            center.removeObserver(observer)
        }
    }
    
    // MARK: - keyboard notifications
    
    @IBOutlet var scrollViewContainer: UIScrollView!
    var cookieForKeyboardAppears: NSObjectProtocol!
    var cookieForKeyboardDisappears: NSObjectProtocol!
    let center = NSNotificationCenter.defaultCenter()
    let queue = NSOperationQueue.mainQueue()
    
    var activeTextField: UITextField!
    func registerForKeyboardNotifications() {
        cookieForKeyboardAppears = center.addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: queue, usingBlock: { notification in
            self.keyBoardWasShown(notification)
        })
        cookieForKeyboardDisappears = center.addObserverForName(UIKeyboardDidHideNotification, object: nil, queue: queue, usingBlock: { notification in
            self.keyboardWillBeHidden(notification)
        })
    }
    func keyBoardWasShown(aNotification: NSNotification) {
        if let info: NSDictionary = aNotification.userInfo {
            if let kbSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
                let scrollView = self.scrollViewContainer
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
                var aRect = self.view.frame
                aRect.size.height -= kbSize.height
                if activeTextField != nil {
                    if activeTextField == textFieldAgendaItem {
                        
                        let lastIndexPath = NSIndexPath(forRow: agendaMeeting.numberOfRowsInSection(agendaMeeting.numberOfSections() - 1)-1, inSection: agendaMeeting.numberOfSections() - 1)
                        if agendaMeeting.numberOfRowsInSection(0) > 0 {
                            agendaMeeting.contentInset = UIEdgeInsetsMake(0, 0, agendaMeeting.bounds.height, 0)
                            agendaMeeting.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Top, animated: true)
                        }
                        scrollView.contentOffset = containerForMeetingAgenda.frame.origin
                    }
                }
            }
        }
    }
    func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollViewContainer.contentInset = contentInsets
        agendaMeeting.contentInset = contentInsets
        scrollViewContainer.scrollIndicatorInsets = contentInsets
    }
    
}

extension SubDetailsOfMeetingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        textView.layer.borderColor = UIColor.blackColor().CGColor
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.layer.borderWidth = 0
    }
    
    func textViewDidChange(textView: UITextView) {
        // update meeting
        DetailsOfMeetingAPI.sharedInstance.updateAgendaAndNotesMeeting([objectivesMeeting.text ,notesMeeting.text], meeting: meeting)
    }
}

extension SubDetailsOfMeetingViewController: UITableViewDataSource {
    private struct CellIdentifiers {
        static let AgendaCell = "agenda cell 2"
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaOfMeeting.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.AgendaCell, forIndexPath: indexPath) as! UITableViewCell
        let agendaItem = agendaOfMeeting[indexPath.row]
        cell.textLabel?.text = agendaItem.titleAgenda
        if agendaItem.coveredAgenda == 1 {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}

extension SubDetailsOfMeetingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let agendaItem = agendaOfMeeting[indexPath.row]
        DetailsOfMeetingAPI.sharedInstance.updateCoveredAgenda(agendaItem)
        if let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath) {
            if agendaItem.coveredAgenda == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete") { (action, indexPath) -> Void in
            DetailsOfMeetingAPI.sharedInstance.deleteAgendaItem(self.agendaOfMeeting[indexPath.row])
            tableView.reloadData()
        }
        
        return [deleteAction]
        
    }
    @IBAction func longPressOnCell(sender: UILongPressGestureRecognizer) {
        let locationOfPress = sender.locationInView(agendaMeeting)
        let indexPath = agendaMeeting.indexPathForRowAtPoint(locationOfPress)
        
        if indexPath != nil {
            if sender.state == UIGestureRecognizerState.Began {
                agendaItemToUpdate = agendaOfMeeting[indexPath!.row]
                if let indexPath = indexPath {
                    let cell = agendaMeeting.cellForRowAtIndexPath(indexPath)
                    cell?.textLabel?.text = ""
                    let frame = cell?.textLabel?.frame
                    let textField = UITextField(frame: frame!)
                    textField.text = agendaOfMeeting[indexPath.row].titleAgenda
                    textField.returnKeyType = UIReturnKeyType.Done
                    textField.delegate = self
                    textField.becomeFirstResponder()
                    
                    cell?.addSubview(textField)
                    agendaMeeting.contentInset = UIEdgeInsetsMake(0, 0, agendaMeeting.frame.height - cell!.frame.height, 0)
                    agendaMeeting.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
            }
        }
    }
}

extension SubDetailsOfMeetingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        println(textField.bounds)
        println(textField.frame)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !updateItemInAgenda {
            // insert new task
            DetailsOfMeetingAPI.sharedInstance.insertAgendaMeeting(textField.text, meeting: meeting)
            textField.text = ""
            agendaMeeting.reloadData()
            if agendaMeeting.numberOfRowsInSection(0) > 3 {
                agendaMeeting.contentInset = UIEdgeInsetsMake(0, 0, agendaMeeting.frame.height, 0)
            agendaMeeting.scrollToRowAtIndexPath(NSIndexPath(forRow: agendaMeeting.numberOfRowsInSection(0) - 4, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        } else {
            DetailsOfMeetingAPI.sharedInstance.updateAgendaItem(textField.text, agendaItem: agendaItemToUpdate)
            textField.text = ""
            updateItemInAgenda = false
            agendaMeeting.reloadData()
            textField.resignFirstResponder()
            textField.removeFromSuperview()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
}
