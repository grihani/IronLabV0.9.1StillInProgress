//
//  ActivitiesOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ActivitiesOfAccountViewController: UIViewController {
    
    var account: AccountsModel!
    var withoutFlag = TaskViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let meetings = DetailsOfAccountAPI.sharedInstance.getMeetingsOfAccount(account)
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("action plan of meeting") as! TaskViewController
        
        if meetings.count > 0 {
            let meeting = meetings[0]
            
            viewController.meeting = meeting
        }
        viewController.account = account
        
        viewController.view.frame = view.frame
        switchViewController(from: nil, to: viewController)
        withoutFlag = viewController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        withoutFlag.FlagButtonTask.hidden = true
        
    }
    
    private func switchViewController(from fromVC:UIViewController?, to toVC:UIViewController?) {
        if fromVC != nil {
            fromVC!.willMoveToParentViewController(nil)
            fromVC!.view.removeFromSuperview()
            fromVC!.removeFromParentViewController()
        }
        if toVC != nil {
            self.addChildViewController(toVC!)
            self.view.insertSubview(toVC!.view, atIndex: 0)
            toVC!.didMoveToParentViewController(self)
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
