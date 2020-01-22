//
//  Last10OrdersTableViewCell.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class Last10OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var custLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var discLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
