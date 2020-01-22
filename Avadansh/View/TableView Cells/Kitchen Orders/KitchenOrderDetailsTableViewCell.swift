//
//  KitchenOrderDetailsTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 08/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class KitchenOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
