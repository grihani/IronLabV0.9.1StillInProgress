//
//  DoughnutsForVue360.swift
//  UIScrollViewForMobilite
//
//  Created by CSC CSC on 19/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
//@IBDesignable
class DoughnutsForVue360: UIView {

    @IBInspectable
    var background: UIColor = UIColor.greenColor()
    @IBInspectable
    var onTopColor: UIColor = UIColor.blackColor()
    @IBInspectable
    var overAchiever: UIColor = UIColor.grayColor()
    
    @IBInspectable
    var totalActivities: Int = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var doneActivities: Int = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let π:CGFloat = CGFloat(M_PI)
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let center = CGPoint(x:rect.width/2, y: rect.height/2)
        // 2
        let radius: CGFloat = max(rect.size.width-20, rect.size.height-20)
        // 3
        let arcWidth: CGFloat = 20
        // 4
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = π / 4
        
        // background
        var pathForBackground = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        pathForBackground.lineWidth = arcWidth
        background.setStroke()
        pathForBackground.stroke()
        
        // counter
        var numberOfActivitiesToDraw  = doneActivities
        var overAchieved = false
        if doneActivities > totalActivities {
            numberOfActivitiesToDraw = totalActivities
            overAchieved = true
        }
        
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        let arcLengthPerActivity = angleDifference / CGFloat(totalActivities)
        let topDoneActivitiesAngle = arcLengthPerActivity * CGFloat(numberOfActivitiesToDraw) + startAngle
        
        var pathForCounter = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: topDoneActivitiesAngle,
            clockwise: true)
        pathForCounter.lineWidth = arcWidth
        onTopColor.setStroke()
        pathForCounter.stroke()
        
        if overAchieved {
            var pathForOverAchieving = UIBezierPath(arcCenter: center,
                radius: radius/2 - arcWidth/2,
                startAngle: endAngle,
                endAngle: endAngle + π/8,
                clockwise: true)
            pathForOverAchieving.lineWidth = arcWidth
            overAchiever.setStroke()
            pathForOverAchieving.stroke()
        }
        
    }
    

}
