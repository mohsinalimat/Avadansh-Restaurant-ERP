//
//  AccountInformationTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 18/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class AccountInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var sno: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var expense: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
