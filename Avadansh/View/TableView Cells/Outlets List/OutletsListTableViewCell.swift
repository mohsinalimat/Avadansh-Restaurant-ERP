//
//  OutletsListTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 12/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OutletsListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
