//
//  FirstStepCreatingMeetingOfAccount.swift
//  IronLab
//
//  Created by ghassane rihani on 27/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import EventKit

class FirstStepCreatingMeetingOfAccount: UIViewController {
    
    typealias MeetingsOfDay = DetailsOfAccountAPI.MeetingsAndContacts
    
    var account: AccountsModel!
    
    var meetingsOfDay: MeetingsOfDay! {
        didSet {
            howManyMeetingsThatDay?.text = "you already have " + String(meetingsOfDay.count) + " meeting"
            if meetingsOfDay.count > 1 {
                howManyMeetingsThatDay?.text = howManyMeetingsThatDay.text! + "s"
            }
        }
    }
    
    private let dateFormatter = NSDateFormatter()
    private var didBeginEditingTextView = false
    
    // MARK: - ViewLifeCycle
    
    var calendarModify: String?
    let textCellIdentifier = "ChoixCalendar"
    var titleOfCalendar: [String] = []
    let titleOfCalendarToSaveTO = "Benjamin Amsaleg - Mon agenda"
    
    @IBAction func saveMeetingInCalendar(sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateBeginMeetingPicker.minimumDate = NSDate()
        meetingsOfDay = DetailsOfAccountAPI.sharedInstance.getMeetingsOfDay(NSDate())
        initializeView()
        let eventStore = EKEventStore()
        verifyUserEventAuthorization(eventStore)
    }
    
    func initializeView() {
        dateFormatter.dateStyle = .FullStyle
        dateBeginMeeting.setTitle(dateFormatter.stringFromDate(NSDate()), forState: .Normal)
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let locale = NSLocale(localeIdentifier: "da_DK")
        durationOfMeetingPicker.locale = locale
    }
    
    func verifyUserEventAuthorization(eventStore: EKEventStore) {
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            println("authorized")
            retrieveYourCalendar(eventStore)
        case .Denied:
            println("denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                { [weak self](granted: Bool, error: NSError!) -> Void in
                    if granted {
                        self!.retrieveYourCalendar(eventStore)
                    }
                    else {
                    }
                })
        case .Restricted:
            println("Restricted")
        }
    }
    func retrieveYourCalendar(eventStore: EKEventStore) {
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent)
        for calendar in calendars as! [EKCalendar] {
            titleOfCalendar.append(calendar.title)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var heightOfDayDatePicker: NSLayoutConstraint!
    @IBOutlet weak var heightOfDurationPicker: NSLayoutConstraint!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        heightOfDayDatePicker.constant = 0.0
        dateBeginMeetingPicker.hidden = true
        heightOfDurationPicker.constant = 0.0
        durationOfMeetingPicker.hidden = true
        durationOfMeetingPicker.date = NSDate(timeIntervalSinceReferenceDate: 0)
        view.layoutSubviews()
    }
    
    // MARK: - IBOutlets and their actions
    
    @IBOutlet weak var durationOfMeetingPicker: UIDatePicker!
    @IBOutlet weak var howManyMeetingsThatDay: UILabel!
    @IBOutlet weak var meetingSubject: UITextField!
    @IBOutlet weak var meetingAddress: UITextField! {
        didSet {
            if account != nil {
                meetingAddress.text = account.adressAccount
            }
        }
    }
    @IBOutlet weak var meetingDescription: UITextView! {didSet {
        meetingDescription.layer.cornerRadius = 8
        meetingDescription.layer.borderWidth = 1
        meetingDescription.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1).CGColor
        meetingDescription.delegate = self
        }}
    @IBOutlet weak var dateBeginMeeting: UIButton!
    @IBOutlet weak var dateBeginMeetingPicker: UIDatePicker!
    
    @IBOutlet weak var segmentedControlForDuration: UISegmentedControl!
    
    @IBAction func choosingDuration(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 5:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h'h'mm'm'"
            segmentedControlForDuration.setTitle(dateFormatter.stringFromDate(durationOfMeetingPicker.date), forSegmentAtIndex: 5)
            heightOfDurationPicker.constant = 162
            durationOfMeetingPicker.hidden = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        default:
            heightOfDurationPicker.constant = 0
            durationOfMeetingPicker.hidden = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func setDuration(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h'h'mm'm'"
        segmentedControlForDuration.setTitle(dateFormatter.stringFromDate(sender.date), forSegmentAtIndex: 5)
    }
    
    
    @IBAction func dateChosenForTakingAMeeting(sender: UIDatePicker) {
        let date = sender.date
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .NoStyle
        meetingsOfDay = DetailsOfAccountAPI.sharedInstance.getMeetingsOfDay(date)
        let numberOfMeetings = meetingsOfDay.count
        dateBeginMeeting.setTitle(dateFormatter.stringFromDate(date), forState: .Normal)
    }
    
    @IBAction func goToSecondStepCreatingMeeting(sender: UIBarButtonItem) {
        if meetingSubject.text == "" {
            let alert = UIAlertController(title: "Error", message: "You have to have a subject for the meeting", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier(SegueIdentifiers.AddParticipants, sender: self)
        }
    }
    
    @IBOutlet var alarm: UISwitch!
    
    // MARK: - Actions For layout
    
    @IBAction func showDatePicker(sender: UIButton) {
        if dateBeginMeetingPicker.hidden == true {
            heightOfDayDatePicker.constant = 162
            self.dateBeginMeetingPicker.hidden = false
            
        } else {
            self.dateBeginMeetingPicker.hidden = true
            self.heightOfDayDatePicker.constant = 0.0
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - Navigation
    
    private struct SegueIdentifiers {
        static let AddParticipants = "show participants to add"
        static let ShowMapOfMeeting = "show map of meetings of day"
        static let ShowMapOfMeetings = "show map for day"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.AddParticipants {
            if let destinationViewController = segue.destinationViewController as? AddParticipantsToMeetingOfAccountViewController {
                
                var argumentsOfMeeting: [InitializationData] = []
                let subjectMeeting: InitializationData = (MeetingsModel.SubjectMeeting, meetingSubject.text)
                argumentsOfMeeting.append(subjectMeeting)
                let addressMeeting: InitializationData = (MeetingsModel.AdressMeeting, meetingAddress.text)
                argumentsOfMeeting.append(addressMeeting)
                let agendaMeeting: InitializationData = (MeetingsModel.AgendaMeeting, meetingDescription.text)
                argumentsOfMeeting.append(agendaMeeting)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateBeginMeeting: InitializationData = (MeetingsModel.DateBeginMeeting, dateFormatter.stringFromDate(dateBeginMeetingPicker.date))
                argumentsOfMeeting.append(dateBeginMeeting)
                dateFormatter.dateFormat = "h'h'mm'm'"
                let indexSegment = segmentedControlForDuration.selectedSegmentIndex
                var minutes = 0
                var hours = 0
                if indexSegment < 6 && indexSegment > 0 {
                    if let durationString = segmentedControlForDuration.titleForSegmentAtIndex(indexSegment) {
                        let hoursAndMinutes = split(durationString) {$0 == "h"}
                        hours = hoursAndMinutes[0].toInt()!
                        let otherMinutes = hoursAndMinutes[1]
                        let splitMinutes = split(otherMinutes) {$0 == "m"}
                        minutes = splitMinutes[0].toInt()!
                    }
                } else if indexSegment == 0 {
                    minutes = 30
                }
                let seconds = minutes * 60 + hours * 60 * 60
                let dateEndBegin = dateBeginMeetingPicker.date.add(seconds: seconds)
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateEndMeeting: InitializationData = (MeetingsModel.DateEndMeeting, dateFormatter.stringFromDate(dateEndBegin))
                argumentsOfMeeting.append(dateEndMeeting)
                let idAccount: InitializationData = ("idAccount", String(account.idAccount))
                argumentsOfMeeting.append(idAccount)
                
                let newMeeting = MeetingsModel(idMeeting: 0, elementsOfMeeting: argumentsOfMeeting)
                
                let idNewMeeting = DetailsOfAccountAPI.sharedInstance.saveMeeting(newMeeting)
                newMeeting.idMeeting = idNewMeeting
                destinationViewController.account = account
                destinationViewController.meeting = newMeeting
                
                let eventStore = EKEventStore()
                var calendrier = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: eventStore)
                var newEvent:EKEvent = EKEvent(eventStore: eventStore)
                let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent)
                for calendar in calendars as! [EKCalendar] {
                    if titleOfCalendarToSaveTO == calendar.title {
                        if alarm.on {
                            newEvent.startDate = dateBeginMeetingPicker.date
                            newEvent.endDate = dateEndBegin
                            newEvent.title = meetingSubject.text
                            newEvent.location = meetingAddress.text
                            newEvent.notes = meetingDescription.text
                            if segmentedControlForDuration.selectedSegmentIndex == 6 {
                                newEvent.allDay = true
                            }
                            newEvent.calendar = calendar
                            eventStore.saveEvent(newEvent, span: EKSpanThisEvent, commit: true, error: nil)
                        }
                    }
                    else { println("None selected Calendar")}
                }

                
            }
        }
        if segue.identifier == SegueIdentifiers.ShowMapOfMeetings {
            if let destinationViewController = segue.destinationViewController.topViewController as? MapForMeetingsOfDayViewController {
                destinationViewController.date = dateBeginMeetingPicker.date
                destinationViewController.address = meetingAddress.text
                destinationViewController.account = account
            }
        }
    }
    
    
}

extension FirstStepCreatingMeetingOfAccount: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if !didBeginEditingTextView {
            textView.text = ""
            didBeginEditingTextView = true
        }
    }
}

extension NSDate {
    func add(#seconds: Int) -> NSDate! {
        return NSCalendar(calendarIdentifier: NSGregorianCalendar)!.dateByAddingUnit(NSCalendarUnit.CalendarUnitSecond, value: seconds, toDate: self, options: nil)
    }
}
