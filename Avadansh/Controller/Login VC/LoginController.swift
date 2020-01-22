//
//  ViewController.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passTF: UITextField!{
        didSet{
            passTF.isSecureTextEntry = true
        }
    }
    @IBAction func loginBTN(_ sender: UIButton) {
        
        
        if usernameTF.text != "" && passTF.text != ""{
            self.showProgress()
            
            alamofireRequest(url: "login.php", params: ["user":usernameTF.text!, "pass":passTF.text!, "token":apiToken]){ (json, data) in
                
                if json["status"].stringValue == "1"{
                    self.showSuccessProgress(msg: json["message"].stringValue)
                    
                    defaults.set(json["data"]["brand_id"].stringValue, forKey: "brandID")
                    defaults.set(json["data"]["name"].stringValue, forKey: "name")
                    defaults.set(json["data"]["outlet_name"].stringValue, forKey: "outletName")
                    defaults.set(json["data"]["outlet_id"].stringValue, forKey: "outletID")
                    defaults.set(json["data"]["cat"].stringValue, forKey: "userCat")
                    defaults.set(json["data"]["bar"].stringValue, forKey: "barVAT")
                    defaults.set(json["data"]["id"].stringValue, forKey: "userID")
                    
                    if json["data"]["cat"].stringValue == "3" || json["data"]["cat"].stringValue == "4"{
                        self.goToPage(goto: "Home")
                    }else if json["data"]["cat"].stringValue == "5"{
                        self.goToPage(goto: "KO")
                    }else if json["data"]["cat"].stringValue == "2"{
                        self.goToPage(goto: "OH")
                    }else if json["data"]["cat"].stringValue == "1"{
                        self.goToPage(goto: "AH")
                    }
                    
                    
                }else{
                    self.showErrorProgress(msg: json["message"].stringValue)
                    self.passTF.text = ""
                    self.usernameTF.text = ""
                }
            }
            
        }else{
            if usernameTF.text == ""{
              self.showInfoProgress(msg: "Username can't be empty")
            }else if passTF.text == ""{
                self.showInfoProgress(msg: "Pass can't be empty")
            }
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
       
    }

}

