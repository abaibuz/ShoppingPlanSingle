//
//  RowTableViewCellForDocPurchase.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 11.12.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import UIKit

class RowTableViewCellForDocPurchase: UITableViewCell {
    
    @IBOutlet weak var switchLabel: BEMCheckBox!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageCategory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
   }
   
}

