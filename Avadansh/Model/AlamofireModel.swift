//
//  AlamofireModel.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import Alamofire
import AlamofireImage
import SwiftyJSON



//var x = 0

let baseURLForInvoice  = "http://advanced-pos.indiansmarthub.co.in/pos/invoice.php?order_id="
let baseURLForKOT = "http://advanced-pos.indiansmarthub.co.in/pos/kot.php?order_id="

func alamofireRequest(url: String, params : [String:String], completion : @escaping (JSON, Data) -> Void ){
    
    
    let baseURL = "http://advanced-pos.indiansmarthub.co.in/apis/"
    
    request(baseURL+url, method: .post, parameters: params).responseJSON{
        response in
        
        
        let apiJSON : JSON = JSON(response.result.value as Any)
        
        print(baseURL+url)
        print(params)
        print(apiJSON)
        
        if response.result.isSuccess{
            
            //print(baseURL+url)
            completion(apiJSON,response.data!)
            
        }else{
            
            if let error = response.result.error{
                print(error)
            }
            
        }
    }
    
}


func alamofireImageRequest(url:String, completion : @escaping (UIImage) -> Void){
    
    request(url).responseImage { response in
        
        if let image = response.result.value {
            completion(image)
            
        }
    }
    
    
}
