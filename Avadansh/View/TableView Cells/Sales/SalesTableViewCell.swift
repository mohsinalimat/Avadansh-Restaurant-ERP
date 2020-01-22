//
//  SalesTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class SalesTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var invoiceBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
