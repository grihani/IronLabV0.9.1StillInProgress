//
//  CalendarView.swift
//  IronLab
//
//  Created by CSC CSC on 22/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
//@IBDesignable
class CalendarView: UIView {

    var labelsOfWeek = ["D", "L", "M", "M", "J","V","S"]
    var numberOfWeeksToShow = 5
    var heightOfLabels: CGFloat = 20
    
    @IBInspectable var backgroundColorForHighlightedButton: UIColor = UIColor(red: 221/255, green: 231/255, blue: 243/255, alpha: 1)
    @IBInspectable var backgroundColorForUnhighlightedButton: UIColor = whiteColor
    @IBInspectable var fontColorForHighlightedState: UIColor = whiteColor
    @IBInspectable var fontColorForNormalState: UIColor = blackColor
    
    @IBOutlet var buttons: [UIButton] = []
    
    @IBOutlet var chosenButton: UIButton! {
        didSet {
            for button in buttons {
                button.backgroundColor = backgroundColorForUnhighlightedButton
                button.setTitleColor(fontColorForNormalState, forState: .Normal)
            }
            chosenButton.backgroundColor = backgroundColorForHighlightedButton
            chosenButton.setTitleColor(fontColorForHighlightedState, forState: .Normal)
            
            if let index = find(buttons, chosenButton) {
                chosenDay = daysOfCalendar[index]
            }
        }
    }
    
    @IBOutlet var labelsForMeetings : [UILabel] = []
    
    private let dateFormatter = NSDateFormatter()
    private let calendar = NSCalendar.currentCalendar()
    
    private var numberOfDays: Int {
        return labelsOfWeek.count * numberOfWeeksToShow
    }
    
    var chosenDay = NSDate()
    
    var stringFromChosenDay: String {
        dateFormatter.dateStyle = .FullStyle
        return dateFormatter.stringFromDate(chosenDay)
    }
    var daysOfCalendar: [NSDate] {
        var dates: [NSDate] = []
        let today = NSDate()
        var dateComponents = self.calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: today)
        let firstDayOfWeek = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay,
            value: (-dateComponents.weekday),
            toDate: today,
            options: .MatchNextTime)
        var i = 0
        var dayToShow = firstDayOfWeek
        for i in 0..<numberOfDays {
            dayToShow = calendar.dateByAddingUnit(.CalendarUnitDay,
                value: 1,
                toDate: dayToShow!,
                options: .MatchNextTime)
            if let dayToShow = dayToShow {
                dates.append(dayToShow)
            }
        }
        return dates
    }
    
    var numberOfMeetings: [Int] = [] {
        didSet {
            
            let widthOfComponents = widthOfLabels(labelsOfWeek.count, rect: frame)
            let heightOfComponents = heightOfButtons(numberOfWeeksToShow, rect: frame)
            var countLabels = 0
            for j in 0..<numberOfWeeksToShow {
                for i in 0..<labelsOfWeek.count {
                    let label = drawLabelsInView(numberOfDays: labelsOfWeek.count, width: widthOfComponents, height: heightOfComponents, xIndexOfElement: i, yIndexOfElement: j, count: countLabels)
                    labelsForMeetings.append(label)
                    addSubview(label)
                    countLabels++
                }
            }
        }
    }
    
    private var datesOfCalendar: [String] {
        var dates: [String] = []
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for date in daysOfCalendar {
            dates.append(dateFormatter.stringFromDate(date))
        }
        return dates
    }
    private var chosenDate: String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(chosenDay)
    }
    var index: Int {
        if let index = find(datesOfCalendar, chosenDate) {
            return index
        } else {
            return 0
        }
    }
    
    
    // MARK: - init & required init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtons(frame)
        if let index = find(datesOfCalendar, chosenDate) {
            chosenButton = buttons[index]
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addButtons(frame)
        if let index = find(datesOfCalendar, chosenDate) {
            chosenButton = buttons[index]
        }
    }
    
    // MARK: - INIT Function
    func addButtons(frame: CGRect) {
        
        let widthOfComponents = widthOfLabels(labelsOfWeek.count, rect: frame)
        for i in 0..<labelsOfWeek.count {
            drawLabelsInView(labelOfDay: labelsOfWeek[i], numberOfDays: labelsOfWeek.count, width: widthOfComponents,indexOfElement: i)
        }
        let heightOfComponents = heightOfButtons(numberOfWeeksToShow, rect: frame)
        var countLabels = 0
        for j in 0..<numberOfWeeksToShow {
            for i in 0..<labelsOfWeek.count {
                let label = drawLabelsInView(numberOfDays: labelsOfWeek.count, width: widthOfComponents, height: heightOfComponents, xIndexOfElement: i, yIndexOfElement: j, count: countLabels)
                labelsForMeetings.append(label)
                addSubview(label)
                countLabels++
            }
        }
      
        buttons = []
        var countButtons = 0
        for j in 0..<numberOfWeeksToShow {
            for i in 0..<labelsOfWeek.count {
                let button = drawButtonsInView(numberOfDays: labelsOfWeek.count, width: widthOfComponents, height: heightOfComponents, xIndexOfElement: i, yIndexOfElement: j, count: countButtons)
                buttons.append(button)
                addSubview(button)
                countButtons++
            }
        }
        labelsForMeetings = []
        
    }
    
    private var stringFromDaysOfCalendar: [String] {
        var stringFromDays = [String]()
        dateFormatter.dateFormat = "d"
        for date in daysOfCalendar {
            stringFromDays.append(dateFormatter.stringFromDate(date))
        }
        return stringFromDays
    }
    
    
    // MARK: - button & labels
    func widthOfLabels(numberOfDays: Int,rect: CGRect) -> CGFloat {
        let numberOfDays = CGFloat(numberOfDays)
        let widthOfLabels = (rect.size.width - 8 * (numberOfDays - 1)) / numberOfDays
        return widthOfLabels
    }
    
    func drawLabelsInView(#labelOfDay: String, numberOfDays: Int, width: CGFloat, indexOfElement: Int) {
        var origin = CGPointZero
        origin.x = CGFloat(indexOfElement) * (width + 8)
        let size = CGSize(width: width, height: heightOfLabels)
        let rectOfLabel = CGRect(origin: origin, size: size)
        let label = UILabel(frame: rectOfLabel)
        label.text = labelOfDay
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
    }
    
    func heightOfButtons(numberOfWeeks: Int,rect: CGRect) -> CGFloat {
        let numberOfWeeks = CGFloat(numberOfWeeks)
        let heightOfButtons = (rect.size.height - heightOfLabels - 8 * (numberOfWeeks - 1) ) / numberOfWeeks
        return heightOfButtons
    }
    
    func drawLabelsInView(#numberOfDays: Int, width: CGFloat, height: CGFloat, xIndexOfElement: Int, yIndexOfElement: Int, count: Int) -> UILabel {
        var origin = CGPointZero
        origin.x = CGFloat(xIndexOfElement) * (width + 8)
        origin.y = CGFloat(yIndexOfElement) * (height + 8) + heightOfLabels
        
        let size = CGSize(width: width, height: height/2)
        let rectOfLabel = CGRect(origin: origin, size: size)
        
        let label = UILabel(frame: rectOfLabel)
        label.textAlignment = NSTextAlignment.Right
        if numberOfMeetings.count == datesOfCalendar.count {
            label.text = String(numberOfMeetings[count])
        }
        label.textColor = UIColor.blackColor()
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFontOfSize(10)
        
        return label
    }
    
    func drawButtonsInView(#numberOfDays: Int, width: CGFloat, height: CGFloat, xIndexOfElement: Int, yIndexOfElement: Int, count: Int) -> UIButton {
        var origin = CGPointZero
        origin.x = CGFloat(xIndexOfElement) * (width + 8)
        origin.y = CGFloat(yIndexOfElement) * (height + 8) + heightOfLabels
        
        let size = CGSize(width: width, height: height)
        let rectOfButton = CGRect(origin: origin, size: size)
        
        let button = UIButton(frame: rectOfButton)
        button.setTitleColor(fontColorForNormalState, forState: .Normal)
        button.setTitle("\(stringFromDaysOfCalendar[count])", forState: .Normal)
        button.layer.cornerRadius = min(width,height)/2
        button.addTarget(nil, action: "chooseADay:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }
    

}
