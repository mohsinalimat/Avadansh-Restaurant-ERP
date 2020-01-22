//
//  OnHoldOrdersViewController.swift
//  Avadansh
//
//  Created by Admin on 03/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OnHoldOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    private struct Order{
        
         let orderID, name: String
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var order = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getOrders()
        showProgress()
        
        self.tableView.register(UINib(nibName: "OnHoldOrdersListTableViewCell", bundle: nil), forCellReuseIdentifier: "OnHoldOrdersListTableViewCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Hold List"
    }
    
    
    private func getOrders(){
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "hold_orders.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                do{
                    self.order = [Order]()
                    
                    let order = try JSONDecoder().decode(OnHoldListRoot.self, from: data)
                    
                    if order.status == "1"{
                        for x in order.data{
                            self.order.append(Order(orderID: x.orderID, name: x.name))
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
        return order.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnHoldOrdersListTableViewCell", for: indexPath) as! OnHoldOrdersListTableViewCell
        
        cell.orderIDLbl.text = order[indexPath.row].orderID
        cell.custNameLbl.text = order[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OLDVC") as! OrderListDetailsViewController
        if let navigator = navigationController {
            viewController.orderID = order[indexPath.row].orderID
            viewController.onHoldOrder = true
            navigator.pushViewController(viewController, animated: true)
        }
    }
    

}
