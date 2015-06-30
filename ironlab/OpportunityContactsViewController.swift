//
//  OpportunityContactsViewController.swift
//  IronLab
//
//  Created by Formation iOS on 10/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class OpportunityContactsViewController: UIViewController {
    
    var account: AccountsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("Contacts of account") as! ContactsOfAccountViewController
        
        viewController.account = account
        
        viewController.view.frame = view.frame
        switchViewController(from: nil, to: viewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
