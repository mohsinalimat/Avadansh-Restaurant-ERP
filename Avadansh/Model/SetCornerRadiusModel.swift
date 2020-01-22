//
//  SetCornerRadiusModel.swift
//  Avadansh
//
//  Created by Admin on 26/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit


extension UIImageView{
    
    func changeToCircularImageView(borderColor : CGColor){
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    
    
}

extension UIView{
    
    func changeCornerRadiusOfTheView(borderWidth : CGFloat, cornerRadius : CGFloat , borderColor : CGColor){
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
