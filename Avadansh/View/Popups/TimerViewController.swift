//
//  TimerViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 09/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import DropDown

class TimerViewController: UIViewController {

    private var preprationTime = ""
    var orderID = ""
    
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = UIColor.flatWhite()?.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var popupView: UIView!{
        didSet{
            popupView.backgroundColor = UIColor.white.withAlphaComponent(1)
        }
    }
    
    @IBOutlet weak var selectPrepration: UIButton!
    @IBAction func selectPrepration(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.anchorView = selectPrepration
        dropDown.bottomOffset = CGPoint(x: 0, y: 0.5)
        
        dropDown.dataSource = ["5 Minutes","10 Minutes", "15 Minutes","20 Minutes","30 Minutes","45 Minutes", "60 Minutes"]
        
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            switch index{
            case 0 : self.preprationTime = "05:00"
            case 1 : self.preprationTime = "10:00"
            case 2 : self.preprationTime = "15:00"
            case 3 : self.preprationTime = "20:00"
            case 4 : self.preprationTime = "30:00"
            case 5 : self.preprationTime = "45:00"
            default  : self.preprationTime = "60:00"
                
            }
            
            
            self.selectPrepration.setTitle(item, for: .normal)
            
        }
        
        dropDown.cancelAction = {
            self.selectPrepration.setTitle("--- Select ---", for: .normal)
            self.preprationTime = ""
        }
        
        
        
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        
//        print(preprationTime)
//        print(orderID)
        if preprationTime != ""{

            if let outlet = defaults.string(forKey: "outletID"){
                alamofireRequest(url: "set_time.php", params:["outlet_id":outlet,"token":apiToken,"order_id":orderID,"time":preprationTime]) { (json, data) in

                    if json["status"].stringValue == "1"{
                        self.showSuccessProgress(msg: json["message"].stringValue)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.showErrorProgress(msg: json["message"].stringValue)
                    }

                }
            }


        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
