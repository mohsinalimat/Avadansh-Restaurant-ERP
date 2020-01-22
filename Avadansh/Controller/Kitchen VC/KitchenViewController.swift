//
//  KitchenViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 08/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class KitchenViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    
    struct KitchenOrder{
        let orderID, orderType, table, expectedTime: String
        let remainingTime: String
    }
    
    private var kitchenorders = [KitchenOrder]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        setNavBarIcon()
        
        self.tableView.register(UINib(nibName: "KitchenOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "KitchenOrderTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showProgress()
        getData()
    }
    
    
    private func getData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "orders_in_kitchen.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    
                    self.kitchenorders = [KitchenOrder]()
                    
                    let order = try JSONDecoder().decode(KitchenOrdersRoot.self, from: data)
                    
                    if order.status == "1"{
                        
                        for x in order.data{
                            self.kitchenorders.append(KitchenOrder(orderID: x.orderID, orderType: x.orderType, table: x.table, expectedTime: x.expectedTime, remainingTime: x.remainingTime))
                        }
                        
                        
                        
                    }else{
                        
                        self.showErrorProgress(msg: order.message)
                    }
                    
                    self.dismissProgress()
                    self.tableView.reloadData()
                    
                }catch{
                    print(error)
                }
            }
        }
        
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kitchenorders.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KitchenOrderTableViewCell", for: indexPath) as! KitchenOrderTableViewCell
        
        cell.orderIDLbl.text = kitchenorders[indexPath.row].orderID
        
        if kitchenorders[indexPath.row].orderType == "0"{
            cell.orderTypeLbl.text = "Dine IN"
        }else if kitchenorders[indexPath.row].orderType == "1"{
            cell.orderTypeLbl.text = "Take Away"
        }else if kitchenorders[indexPath.row].orderType == "2"{
            cell.orderTypeLbl.text = "Delivery"
        }
        
        cell.tableLbl.text = kitchenorders[indexPath.row].table
        cell.timerLbl.text = kitchenorders[indexPath.row].remainingTime
        cell.timeToCompleteLbl.text = kitchenorders[indexPath.row].expectedTime
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Kitchen", bundle: nil).instantiateViewController(withIdentifier: "KODVC") as! KitchenOrderDetailsViewController
        if let navigator = navigationController {
            viewController.orderID = kitchenorders[indexPath.row].orderID
            if kitchenorders[indexPath.row].expectedTime == ""{
                viewController.timer = false
            }
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    
}
