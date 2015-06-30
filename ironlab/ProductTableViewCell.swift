//
//  ProductTableViewCell.swift
//  IronLab
//
//  Created by Formation iOS on 04/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productLabel: UILabel! {
        didSet {
//            self.productLabel.backgroundColor = blueUncheckedColor
        }
    }
    @IBOutlet weak var listUnitPriceLabel: UILabel! {
        didSet {
//            self.listUnitPriceLabel.backgroundColor = blueUncheckedColor
        }
    }
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
//            self.quantityLabel.backgroundColor = blueUncheckedColor
        }
    }
    @IBOutlet weak var priceHTLabel: UILabel! {
        didSet {
//            self.priceHTLabel.backgroundColor = blueUncheckedColor
        }
    }
    @IBOutlet weak var priceTTLabel: UILabel! {
        didSet {
//            self.priceTTLabel.backgroundColor = blueUncheckedColor
        }
    }
    
}
