//
//  HomePageViewController.swift
//  IronLab
//
//  Created by CSC CSC on 22/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    typealias DataOfTableView = [MeetingsOfHomePageAPI.TypeData]
    @IBOutlet weak var centeredPicture: UIImageView! {
        didSet {
            centeredPicture.layer.cornerRadius = centeredPicture.frame.size.width / 2
        }
    }
    @IBOutlet weak var meetingsOfDayTableView: UITableView! {
        didSet {
            meetingsOfDayTableView.dataSource = self
            meetingsOfDayTableView.delegate = self
        }
    }
    var meetingsOfDate = DataOfTableView()
    
    private let dateFormatter = NSDateFormatter()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenDateLabel.text = calendarView.stringFromChosenDay
        calendarView.chosenButton = calendarView.buttons[calendarView.index]
        meetingsOfDate = MeetingsOfHomePageAPI.sharedInstance.getMeetingsOfDate(NSDate())
        for i in 0..<calendarView.daysOfCalendar.count {
            calendarView.numberOfMeetings.append(1)
        }
        meetingsOfDayTableView.estimatedRowHeight = meetingsOfDayTableView.rowHeight
        meetingsOfDayTableView.rowHeight = UITableViewAutomaticDimension
        meetingsOfDayTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        rightContainerSpaceMargin.constant = hidingCalendar.Calendrier
        leftMarginForPictureContainer.constant = hidingCalendar.Picture
        rightLanguetteMargin.constant = hidingCalendar.LanguetteGauche
        view.layoutIfNeeded()
    }
    
    // MARK: - CalendarActions
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var chosenDateLabel: UILabel!
    
    @IBAction func chooseADay(sender: UIButton) {
        calendarView.chosenButton = sender
        chosenDateLabel.text = calendarView.stringFromChosenDay
        let chosenDate = calendarView.chosenDay
        meetingsOfDate = MeetingsOfHomePageAPI.sharedInstance.getMeetingsOfDate(chosenDate)
        meetingsOfDayTableView.reloadData()
    }
    
    @IBOutlet weak var pictureContainerView: UIView!
    
    // MARK: - actions of hiding and showing the views
    
    @IBOutlet weak var rightContainerSpaceMargin: NSLayoutConstraint!
    @IBOutlet weak var leftMarginForPictureContainer: NSLayoutConstraint!
    @IBOutlet weak var rightLanguetteMargin: NSLayoutConstraint!
    
    private struct hidingCalendar {
        static let LanguetteGauche: CGFloat = -20
        static let Calendrier: CGFloat = 400
        static let Picture: CGFloat = 322
    }
    private struct showingCalendar {
        static let LanguetteGauche: CGFloat = -100
        static let Calendrier: CGFloat = 0
        static let Picture: CGFloat = 200
    }
    @IBAction func showCalendar(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.rightContainerSpaceMargin.constant = showingCalendar.Calendrier
            self.leftMarginForPictureContainer.constant = showingCalendar.Picture
            self.rightLanguetteMargin.constant = showingCalendar.LanguetteGauche
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func hideCalendar(sender: UIButton) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.rightContainerSpaceMargin.constant = hidingCalendar.Calendrier
            self.leftMarginForPictureContainer.constant = hidingCalendar.Picture
            self.rightLanguetteMargin.constant = hidingCalendar.LanguetteGauche
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - unwind function
    
}

extension HomePageViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingsOfDate.count
    }
    private struct cellIdentifiers {
        static let LeftDetails = "meetings of day"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers.LeftDetails, forIndexPath: indexPath) as! HomePageMeetingsTableViewCell
        let row = indexPath.row
        let account = meetingsOfDate[row].account
        let meeting = meetingsOfDate[row].meeting
        cell.dateBeginMeeting.text = translateDatesToHours(meeting.dateBeginMeeting)
        cell.dateEndMeeting.text = translateDatesToHours(meeting.dateEndMeeting)
        cell.nameAccount.text = account.nameAccount
        cell.subjectMeeting.text = meeting.subjectMeeting
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(meetingsOfDate.count) + " Meeting(s)"
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func translateDatesToHours(sqliteDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let formattedDate = dateFormatter.dateFromString(sqliteDate) {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .MediumStyle
            return dateFormatter.stringFromDate(formattedDate)
        }
        return sqliteDate
    }
}
extension HomePageViewController: UITableViewDelegate {
    
}
