//
//  BaseVC.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var rightButtonItem : UIBarButtonItem!
    
   func setNavBarIcon(){
        
       
        rightButtonItem = UIBarButtonItem(image: UIImage.init(named: "logout-icon"), style:.plain, target: self, action: #selector(self.rightButtonTapped))
        rightButtonItem.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButtonItem
    }
    
    
    @objc func rightButtonTapped(){
        defaults.removeObject(forKey: "brandID")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "outletName")
        defaults.removeObject(forKey: "outletID")
        defaults.removeObject(forKey: "userCat")
        defaults.removeObject(forKey: "barVAT")
        defaults.removeObject(forKey: "userID")
       
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(vc, animated: true, completion: nil)
        
    }

    
}





/*
 
 if let outlet = defaults.string(forKey: "outletID"){
 alamofireRequest(url: "menus.php", params: ["":""]) { (json, data) in
 
 do{
 
 }catch{
    print(error)
 
 }
 }
 }
 */
 
 
 
