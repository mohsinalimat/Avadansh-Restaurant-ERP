//
//  HomeViewController.swift
//  Avadansh
//
//  Created by Admin on 26/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeViewController: BaseVC {

    @IBOutlet weak var profileImg: UIImageView!{
        didSet{
            profileImg.changeToCircularImageView(borderColor: (UIColor.flatBrown()?.cgColor)!)
        }
    }
    @IBOutlet weak var nameLbl: UILabel!{
        didSet{
            nameLbl.text = defaults.string(forKey: "name")!
        }
    }
    
    @IBOutlet weak var outletLbl: UILabel!{
        didSet{
            outletLbl.text = defaults.string(forKey: "outletName")!
        }
    }
    
    
    @IBOutlet weak var tablesLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarIcon()
        // Do any additional setup after loading the view.
    }
    

    
}



