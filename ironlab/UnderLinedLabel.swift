//
//  UnderLinedLabel.swift
//  IronLab
//
//  Created by ghassane rihani on 26/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class UnderLinedLabel: UILabel {

    private let HeightOfLine: CGFloat = 1
    private let ColorOfLine: UIColor = UIColor.grayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLine()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLine()
    }
    
    override func didMoveToSuperview() {
        addLine()
    }
    
    func addLine() {
        let rectSize = CGSize(width: frame.width, height: HeightOfLine)
        let rectOrigin = CGPoint(x: 0, y: frame.height - HeightOfLine)
        let rect = CGRect(origin: rectOrigin, size: rectSize)
        var line = UIView(frame: rect)
        line.backgroundColor = ColorOfLine
        addSubview(line)
    }
    
}
