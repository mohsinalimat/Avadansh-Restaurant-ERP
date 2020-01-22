//
//  ConvertStringToJSONModel.swift
//  Avadansh
//
//  Created by Admin on 02/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import SwiftyJSON

extension UIViewController{
    
    func getStringFromJSON(parameters : [Any]) -> String{
        
       return JSON(parameters).rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.sortedKeys)!
        
        
        
    }
    
    
}
