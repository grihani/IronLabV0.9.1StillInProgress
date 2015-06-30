//
//  CallReportViewController.swift
//  ironlab
//
//  Created by CSC CSC on 22/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import MessageUI

class CallReportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var meeting: MeetingsModel!
    typealias TasksForCR = [DetailsOfMeetingAPI.TasksForCR]
    
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(meeting)
        // Create a string that will be our paragraph
        let para = NSMutableAttributedString()
        
        // Font details
        let titleFont = UIFont(name: "Georgia", size: 18.0) ?? UIFont.systemFontOfSize(18.0)
        let titleColor = UIColor(red: 47/255, green: 66/255, blue: 124/255, alpha: 1)
        
        let fontForTitle = [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: titleColor, NSUnderlineStyleAttributeName: 1]
        
        let subtitleFont = UIFont(name: "Georgia", size: 16.0) ?? UIFont.systemFontOfSize(16.0)
        let subtitleColor = UIColor.blackColor()
        let fontForSubtitle = [NSFontAttributeName: subtitleFont, NSForegroundColorAttributeName: subtitleColor]
        
        let fontForSecondSubtitle = [NSFontAttributeName: subtitleFont, NSForegroundColorAttributeName: titleColor, NSUnderlineStyleAttributeName: 1]
        
        let paragraphFont = UIFont(name: "Georgia", size: 14.0) ?? UIFont.systemFontOfSize(14.0)
        let fontForParagraph = [NSFontAttributeName: paragraphFont, NSForegroundColorAttributeName: subtitleColor]
        
        
        let content = NSMutableAttributedString()
        
        
        
        // Add locally formatted strings to paragraph
        let title = NSAttributedString(string: "                COMPTE RENDU DE LA RÉUNION DU \(getDate(meeting.dateBeginMeeting))\n", attributes: fontForTitle)
        para.appendAttributedString(title)
        
        let subtitle = NSAttributedString(string: "          Subject: "+meeting.subjectMeeting + "\n", attributes: fontForSubtitle)
        para.appendAttributedString(subtitle)
        
        let participantsSection = NSAttributedString(string: "\n Participants\n", attributes: fontForSecondSubtitle)
        para.appendAttributedString(participantsSection)
        
        let participantsToMeeting = DetailsOfMeetingAPI.sharedInstance.getContactsOfMeeting(meeting)
        for participant in participantsToMeeting {
            let nameParticipant = "   -   " + participant.firstNameContact + " " + participant.lastNameContact
            let participantString = NSAttributedString(string: nameParticipant+": "+participant.jobTitleContact+"\n", attributes: fontForParagraph)
            para.appendAttributedString(participantString)
        }
        
        let ordreDuJour = NSAttributedString(string: "\n Ordre du jour\n", attributes: fontForSecondSubtitle)
        para.appendAttributedString(ordreDuJour)
        
        let agenda = DetailsOfMeetingAPI.sharedInstance.getAgendaOfMeeting(meeting)
        for agendaItem in agenda {
            var title = "   -   " + agendaItem.titleAgenda
            if agendaItem.coveredAgenda == 1 {
                title += " (covered) "
            }
            title += "\n"
            let agendaItemString = NSAttributedString(string: title, attributes: fontForParagraph)
            para.appendAttributedString(agendaItemString)
        }
        
        let tasksSection = NSAttributedString(string: "\n Détails \n", attributes: fontForSecondSubtitle)
        para.appendAttributedString(tasksSection)
        
        let tasksSentence = NSAttributedString(string: "Pendant notre échange, nous avons convenu que les points suivants doivent être traités de notre côté:\n", attributes: fontForParagraph)
        para.appendAttributedString(tasksSentence)
        
        // Add the tasks from our part
        let account = DetailsOfMeetingAPI.sharedInstance.getAccountOfMeeting(meeting)
        let activities = DetailsOfMeetingAPI.sharedInstance.getFlaggedActivitiesForAccount(account!)
        for activity in activities {
            let date = NSAttributedString(string: " D'ici le " + activity.date + " :\n", attributes: fontForParagraph)
            para.appendAttributedString(date)
            for task in activity.tasks {
                let taskString = NSAttributedString(string: "   -   " + task.subjectActivity + "\n", attributes: fontForParagraph)
                para.appendAttributedString(taskString)
            }
        }
        
        let tasksSentenceForThem = NSAttributedString(string: "Par ailleurs:\n", attributes: fontForParagraph)
        para.appendAttributedString(tasksSentenceForThem)
        
        // Add the tasks from their part
        
        let taskEnding = NSAttributedString(string: "Nous vous remercions par avance des points que vous aviez indiqués prendre en charge.", attributes: fontForParagraph)
        para.appendAttributedString(taskEnding)
        
        
        // Define paragraph styling
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.firstLineHeadIndent = 30
        paraStyle.paragraphSpacingBefore = 10.0
        
        // Apply paragraph styles to paragraph
        para.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange(location: 0,length: para.length))
        
        // Create UITextView
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.blackColor().CGColor
        // Add string to UITextView
        textView.attributedText = para
        
        // Add UITextView to main view
//        self.view.addSubview(view)
        
        // For a more detailed look at UITextView (not yet in Swift) see: http://sketchytech.blogspot.co.uk/2013/11/making-most-of-uitextview-in-ios-7.html?q=UITextview
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet var sendMail: UIBarButtonItem!
    @IBAction func sendAMail(sender: UIBarButtonItem) {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            
        }else {
            self.showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device couldn't send email.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["bamsaleg@csc.com"])
        mailComposerVC.setSubject("Compte rendu de la réunion du \(getDate(meeting.dateBeginMeeting))")
        mailComposerVC.setMessageBody(textView.text, isHTML: false)
        return mailComposerVC
    }
    
    func getDate(sqlDate: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let dateFromSQLDate = dateFormatter.dateFromString(sqlDate) {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .ShortStyle
            return dateFormatter.stringFromDate(dateFromSQLDate)
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateFromSQLDate = dateFormatter.dateFromString(sqlDate) {
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .NoStyle
            return dateFormatter.stringFromDate(dateFromSQLDate)
        }
        return sqlDate
    }
}

extension CallReportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
