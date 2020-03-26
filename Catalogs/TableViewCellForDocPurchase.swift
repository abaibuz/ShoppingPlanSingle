//
//  TableViewCellForDocPurchase.swift
//  ShoppingPlanSingle
//
//  Created by Olexandr Baybuz on 03.12.2017.
//  Copyright © 2017 Olexandr Baybuz. All rights reserved.
//

import UIKit

class TableViewCellForDocPurchase: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var checkLabel: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
