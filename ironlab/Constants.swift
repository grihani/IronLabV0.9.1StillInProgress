//
//  File.swift
//  IronLab
//
//  Created by CSC CSC on 22/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import Foundation
import UIKit
import EventKit

// Hexa: 84a3cd for blueCheckedColor
// Hexa: 2f9372 for greenMenuButtons
let whiteColor: UIColor = UIColor.whiteColor()

let blueCheckedColor: UIColor = UIColor(red: 132/255, green: 163/255, blue: 205/255, alpha: 1)

let blueUncheckedColor: UIColor = UIColor(red: 221/255, green: 231/255, blue: 243/255, alpha: 1)

let blackColor: UIColor = UIColor.blackColor()

let blueButtonColor: UIColor = UIColor(red: 58/255, green: 144/255, blue: 219/255, alpha: 1)

typealias InitializationData = (name: String, value: String)

let undefinedInformation = "This information isn't provided"

extension UIViewController {
    var presenterViewController: UIViewController {
        if let swRevealController = self as? SWRevealViewController {
            if let navCon = swRevealController.frontViewController as? UINavigationController {
                return navCon.topViewController
            }
            else {
                return swRevealController.frontViewController
            }
        } else {
            if let navCon = self as? UINavigationController {
                return navCon.topViewController
            }
            else {
                return self
            }
        }
    }
    
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.topViewController
        } else {
            return self
        }
    }
    
    func getHomePageViewController() -> UIViewController {
        if self.presentingViewController != nil {
            if self.presentingViewController is HomePageV2ViewController {
                return self.presentingViewController!
            } else {
                return self.presentingViewController!.getHomePageViewController()
            }
        }else {return self}
    } 
}

struct UserDefaults {
    static let Meeting = "meeting"
    static let Account = "account"
    static let Opportunity = "opportunity"
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