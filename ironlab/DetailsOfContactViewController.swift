//
//  DetailsOfContactViewController.swift
//  IronLab
//
//  Created by CSC CSC on 09/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class DetailsOfContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet var languetteGauche: UIButton!
    var masterShown = false { didSet {
        if masterShown {
            languetteGauche.setImage(UIImage(named: "LanguetteFermeture"), forState: .Normal)
        } else {
            languetteGauche.setImage(UIImage(named: "LanguetteGauche"), forState: .Normal)
        }
        }}
    @IBAction func barButtonShowMaster(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(sender)
        masterShown = !masterShown
    }
    @IBAction func buttonShowMaster(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
        masterShown = !masterShown
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
