//
//  OrderOverviewTableViewCell.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OrderOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
