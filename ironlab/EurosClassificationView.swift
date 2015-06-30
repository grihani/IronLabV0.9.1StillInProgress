//
//  EurosClassificationView.swift
//  IronLab
//
//  Created by Formation iOS on 05/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit
//@IBDesignable
class EurosClassificationView: UIView {
    
    var nombreImage: Int = 5
    
    var potentialAmountOpportunity: Int! {
        didSet {
            if potentialAmountOpportunity == nil {
                potentialAmountOpportunity = 0
            }
            var nbImageJaune: Int = nombreImageJaune(potentialAmountOpportunity)
            var frameView = frame
            frameView.origin.x = 8
            frameView.origin.y = 0
            frameView.size.height = 20
            frameView.size.width = 20
            let eurosJaune = UIImage(named: "eurosJaune")
            let eurosGris = UIImage(named: "eurosGris")
            var imageView = UIImageView(frame: frameView)
            for i in 0..<nbImageJaune {
                var imageView = UIImageView(frame: frameView)
                imageView.image = eurosJaune
                addSubview(imageView)
                var width = Float(frameView.size.width)
                var offset = Float(i)+1
                frameView.origin.x = (CGFloat)(8 + width * offset)
            }
            for i in nbImageJaune..<nombreImage {
                var imageView = UIImageView(frame: frameView)
                imageView.image = eurosGris
                addSubview(imageView)
                var width = Float(frameView.size.width)
                var offset = Float(i)+1
                frameView.origin.x = (CGFloat)(8 + width * offset)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func nombreImageJaune(potentialAmountOpportunity: Int?) -> Int {
        if potentialAmountOpportunity == nil {
            return 0
        }
        if potentialAmountOpportunity <= 5000 {
            return 1
        }
        if potentialAmountOpportunity <= 10000 {
            return 2
        }
        if potentialAmountOpportunity <= 100000 {
            return 3
        }
        if potentialAmountOpportunity <= 200000 {
            return 4
        }
        else {
            return 5
        }
    }
}