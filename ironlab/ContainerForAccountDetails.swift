//
//  ContainerForAccountDetails.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class ContainerForAccountDetails: UIScrollView {
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        if !self.dragging {
            self.nextResponder()?.touchesMoved(touches, withEvent: event)
        }
    
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        self.nextResponder()?.touchesEnded(touches, withEvent: event)
    }
}

extension ContainerForAccountDetails: UIGestureRecognizerDelegate {
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.state != .Failed {
//            return true
//        }
//        else {
//            return false
//        }
//    }
}
