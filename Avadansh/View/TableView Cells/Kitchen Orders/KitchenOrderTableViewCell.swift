//
//  KitchenOrderTableViewCell.swift
//  Avadansh
//
//  Created by ASD Informatics on 08/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class KitchenOrderTableViewCell: UITableViewCell {

    private var timer : Timer!
    
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!{
        didSet{
            
        }
    }
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var tableLbl: UILabel!
    @IBOutlet weak var timeToCompleteLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func fire()
    {
        if let time = timerLbl.text{
            if time != "00:00"{
                let formatter = DateFormatter()
                formatter.dateFormat = "mm:ss"
                if let formattedtime = formatter.date(from: time){
                    print(formattedtime)
                    timerLbl.text = formatter.string(from: formattedtime.addingTimeInterval(-1))
                }
                
                
            }else{
                timerLbl.text = "Time UP"
                timerLbl.textColor = UIColor.flatRed()
                timer.invalidate()
            }
           
        }
        
    }
    
}
