//
//  HomeFoodCollectionViewCell.swift
//  Avadansh
//
//  Created by Admin on 27/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class HomeFoodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var foodTypeView: UIView!{
        didSet{
            foodTypeView.changeCornerRadiusOfTheView(borderWidth: 1, cornerRadius: foodTypeView.frame.size.width / 2, borderColor: UIColor.clear.cgColor)
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var qtyBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
