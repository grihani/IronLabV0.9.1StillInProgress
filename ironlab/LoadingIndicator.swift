//
//  LoadingIndicator.swift
//  IronLab
//
//  Created by ghassane rihani on 05/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    var activityIndicator: UIActivityIndicatorView!
    var labelMessage: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.80
        self.layer.cornerRadius = 5
        var theLabelMessage = UILabel(frame: CGRectMake(15, 65, 240, 20))
        theLabelMessage.backgroundColor = UIColor.clearColor()
        theLabelMessage.textColor = UIColor.whiteColor()
        theLabelMessage.text = "Loading"
        theLabelMessage.textAlignment = NSTextAlignment.Center
        theLabelMessage.font = UIFont.boldSystemFontOfSize(16)
        theLabelMessage.adjustsFontSizeToFitWidth = true
        self.labelMessage = theLabelMessage
        self.addSubview(theLabelMessage)
        
        var theActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        theActivityIndicator.frame = CGRectMake(115, 15, 40, 40)
        self.activityIndicator = theActivityIndicator
        self.addSubview(theActivityIndicator)
    }
    
    func show(theMessage: String) {
        self.labelMessage.text = theMessage
        self.activityIndicator.startAnimating()
        self.hidden = false
        self.superview?.bringSubviewToFront(self)
        self.refreshPosition()
    }
    
    func hide() {
        self.activityIndicator.stopAnimating()
        self.hidden = true
    }
    
    func refreshPosition() {
        if let center = self.superview?.center as CGPoint! {
            self.center = center
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
