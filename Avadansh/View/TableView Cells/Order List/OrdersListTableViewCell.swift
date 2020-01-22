//
//  OrdersListTableViewCell.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OrdersListTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var tableNoLbl: UILabel!
    @IBOutlet weak var expectedTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
