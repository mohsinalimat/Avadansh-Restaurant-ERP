//
//  PurchaseListTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class PurchaseListTableViewCell: UITableViewCell {

    @IBOutlet weak var refNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var supplierLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var dueLbl: UILabel!{
        didSet{
            dueLbl.textColor = UIColor.flatRed()
        }
    }
    @IBOutlet weak var paidLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
