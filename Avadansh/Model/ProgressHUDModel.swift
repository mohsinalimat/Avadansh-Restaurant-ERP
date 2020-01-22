//
//  ProgressHUDModel.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import Foundation
import SVProgressHUD


extension UIViewController{
    
    
    
    func showProgress(){
        
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 5)
        
    }
    
    func showSuccessProgress(msg : String){
        
        SVProgressHUD.showSuccess(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 2)
        
    }
    func showErrorProgress(msg : String){
        
        SVProgressHUD.showError(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 2)
        
    }
    
    func showInfoProgress(msg : String){
        
        SVProgressHUD.showInfo(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 2)
        
    }
    
    
    func dismissProgress(){
        SVProgressHUD.dismiss()
    }
    
}

